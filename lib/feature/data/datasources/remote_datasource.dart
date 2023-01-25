import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../../core/error/constants.dart';
import '../../../core/error/exception.dart';
import '../../../core/platform/cache_folder_path.dart';
import '../models/lesson_model.dart';
import '../models/peron_model.dart';
import '../models/school_bell_model.dart';
import '../models/lesson_grid_model.dart';

abstract class RemoteDataSource {
  bool isLoggedIn();
  String getUserUid();
  Future<String?> createUser(String email, String password);
  Future<bool> login(String email, String password);
  Future<void> logout();
  Future<PersonModel> getUserData();
  Future<void> saveUserData(
      PersonModel userData, String password, String oldPassword);
  Future<void> restorePassword(String email);

  Future<void> addLesson(LessonModel lesson);
  Future<void> updateLesson(LessonModel lesson);
  Future<void> deleteLesson(LessonModel lesson);
  Future<List<LessonModel>> getLessons();

  Future<void> addBell(SchoolBellModel bell);
  Future<void> updateBell(SchoolBellModel bell);
  Future<void> deleteBell(SchoolBellModel bell);
  Future<List<SchoolBellModel>> getBells();

  Future<List<List<LessonGridModel>>> getLessonsWeekGrid(String key);
  Future<void> setLessonsWeekGrid(String key, List<List<LessonGridModel>> data);
}

class FirebaseRemoteDataSourceImpl implements RemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  FirebaseRemoteDataSourceImpl({
    required this.storage,
    required this.auth,
    required this.firestore,
  });

  @override
  Future<String?> createUser(String email, String password) async {
    try {
      UserCredential user = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? currentUser = user.user;
      //TODO: верифікація e-mail, якщо потрібно
      /*if (currentUser != null && !currentUser.emailVerified) {
        currentUser.sendEmailVerification();
      }*/
      return currentUser?.uid;
    } on FirebaseAuthException catch (authError) {
      if (authError.code == 'weak-password') {
        throw const ServerException('пароль недостатньо надійний');
      } else if (authError.code == 'email-already-in-use') {
        throw const ServerException(
            'вже існує обліковий запис із вказаною електронною адресою');
      } else if (authError.code == 'invalid-email') {
        throw const ServerException('адреса електронної пошти недійсна');
      } else if (authError.code == 'operation-not-allowed') {
        throw const ServerException(
            'Увімкніть "email/password accounts" на консолі Firebase');
      }
    }
    throw const ServerException(cUnknownError);
  }

  @override
  Future<bool> login(String email, String password) async {
    try {
      if (isLoggedIn()) return true;
      UserCredential user = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return user.user != null ? true : false;
    } on FirebaseAuthException catch (authError) {
      if (authError.code == 'user-not-found') {
        throw const ServerException(
            'немає користувача, який відповідає даній електронній пошті');
      } else if (authError.code == 'wrong-password') {
        throw const ServerException('неправильний пароль.');
      } else if (authError.code == 'invalid-email') {
        throw const ServerException('адреса електронної пошти недійсна');
      } else if (authError.code == 'user-disabled') {
        throw const ServerException(
            'користувача, який відповідає даній електронній пошті, вимкнено.');
      }
    }
    return false;
  }

  @override
  Future<void> logout() async {
    await auth.signOut();
  }

  @override
  Future<void> saveUserData(
      PersonModel userData, String password, String oldPassword) async {
    try {
      final credentials = EmailAuthProvider.credential(
          email: auth.currentUser!.email!, password: oldPassword);
      final resCredentials =
          await auth.currentUser?.reauthenticateWithCredential(credentials);
      User? user = resCredentials?.user;
      if (user == null) throw const ServerException(cUnknownError);
      await user.updateDisplayName(userData.name);
      await user.updateEmail(userData.email);
      await user.updatePassword(password);
      if (userData.avatar.isNotEmpty) {
        if (!userData.avatar.contains('https://')) {
          // записати у БД Firebase картинку з userData.avatar
          // та отримати посилання на нього. посилання покласти у userData.avatar
          final downloadURL = await _uploadAvatar(
              localPathName: userData.avatar,
              serverFolder: 'avatars',
              serverName: userData.uid);
          userData = userData.copyWith(avatar: downloadURL);
          // оновити у FirebaseAuth
          await user.updatePhotoURL(
              userData.avatar.isNotEmpty ? userData.avatar : null);
        }
      }
/*
      await user.reauthenticateWithCredential(
        EmailAuthProvider.credential(
          email: userData.email,
          password: password,
        ),
      );*/

      // оновити дані користувача у таблиці
      await firestore
          .collection('users')
          .doc(userData.uid)
          .set(userData.toMap());
    } catch (authError) {
      debugPrint('some error happens: $authError');
    }
  }

  @override
  Future<PersonModel> getUserData() async {
    if (!isLoggedIn()) return PersonModel.emptyPerson();

    PersonModel? res;
    final uid = auth.currentUser?.uid ?? '';
    if (uid.isNotEmpty) {
      res = await firestore.collection('users').doc(uid).get().then((snapshot) {
        if (snapshot.data() != null) {
          return PersonModel.fromMap(snapshot.data()!);
        } else {
          return null;
        }
      });
      if (res != null && res.avatar.isNotEmpty) {
        await _downloadAvatar(res.uid); // зберегти аватарку на телефоні
      }
    }
    return res ?? PersonModel.emptyPerson();
  }

  @override
  Future<void> restorePassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (authError) {
      if (authError.code == 'user-not-found') {
        throw const ServerException(
            'немає користувача, який відповідає даній електронній пошті');
      } else if (authError.code == 'wrong-password') {
        throw const ServerException('неправильний пароль.');
      } else if (authError.code == 'invalid-email') {
        throw const ServerException('адреса електронної пошти недійсна');
      } else if (authError.code == 'user-disabled') {
        throw const ServerException(
            'користувача, який відповідає даній електронній пошті, вимкнено.');
      }
    }
  }

  @override
  bool isLoggedIn() => auth.currentUser != null;

  Future<String> _uploadAvatar(
      {required String localPathName,
      required String serverFolder,
      required String serverName}) async {
    final file = File(localPathName);
    var taskSnapshot =
        await storage.ref('$serverFolder/$serverName').putFile(file);
    final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> _downloadAvatar(String uid) async {
    final localBackup = '$temDirPath/avatar.jpg';
    final bytes = await storage.ref('avatars/$uid').getData();
    final file = await File(localBackup).create();
    if (bytes != null) {
      await file.writeAsBytes(bytes);
    }
  }

  @override
  String getUserUid() => auth.currentUser?.uid ?? '';

  @override
  Future<void> addLesson(LessonModel lesson) async {
    try {
      lesson = lesson.copyWith(uid: firestore.collection('lessons').doc().id);
      await firestore.collection('lessons').doc(lesson.uid).set(lesson.toMap());
    } catch (authError) {
      throw ServerException(authError.toString());
    }
  }

  @override
  Future<void> deleteLesson(LessonModel lesson) async {
    try {
      await firestore.collection('lessons').doc(lesson.uid).delete();
    } catch (authError) {
      throw ServerException(authError.toString());
    }
  }

  @override
  Future<List<LessonModel>> getLessons() async {
    try {
      final querySnapshot = await firestore.collection('lessons').get();
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return LessonModel.fromMap(data);
      }).toList();
    } catch (authError) {
      throw ServerException(authError.toString());
    }
  }

  @override
  Future<void> updateLesson(LessonModel lesson) async {
    try {
      final collectionRef = firestore.collection('lessons').doc(lesson.uid);
      await collectionRef.update(lesson.toMap());
    } catch (authError) {
      throw ServerException(authError.toString());
    }
  }

  @override
  Future<void> addBell(SchoolBellModel bell) async {
    try {
      bell = bell.copyWith(uid: firestore.collection('bells').doc().id);
      await firestore.collection('bells').doc(bell.uid).set(bell.toMap());
    } catch (authError) {
      throw ServerException(authError.toString());
    }
  }

  @override
  Future<void> deleteBell(SchoolBellModel bell) async {
    try {
      await firestore.collection('bells').doc(bell.uid).delete();
    } catch (authError) {
      throw ServerException(authError.toString());
    }
  }

  @override
  Future<List<SchoolBellModel>> getBells() async {
    try {
      final querySnapshot =
          await firestore.collection('bells').orderBy('lesson_number').get();
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return SchoolBellModel.fromMap(data);
      }).toList();
    } catch (authError) {
      throw ServerException(authError.toString());
    }
  }

  @override
  Future<void> updateBell(SchoolBellModel bell) async {
    try {
      final collectionRef = firestore.collection('bells').doc(bell.uid);
      await collectionRef.update(bell.toMap());
    } catch (authError) {
      throw ServerException(authError.toString());
    }
  }

  @override
  Future<List<List<LessonGridModel>>> getLessonsWeekGrid(String key) async {
    try {
      final res = await firestore.collection('week_grid').doc(key).get();
      String? gridData = res.data()?['data'];
      // якщо таблицю не заповнено, повертаємо виключення, для того, щоб
      // логіка сформувала пусту таблицю за кількістю уроків на день на тиждень
      if (gridData == null) throw CacheException();
      List<dynamic> parsedGridJson = jsonDecode(gridData);
      return List<List<LessonGridModel>>.from(parsedGridJson.map((day) {
        Iterable parsedDayJson = jsonDecode(day.toString());
        return List<LessonGridModel>.from(
            parsedDayJson.map((model) => LessonGridModel.fromMap(model)));
      }));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> setLessonsWeekGrid(
      String key, List<List<LessonGridModel>> data) async {
    try {
      final resList = List<String>.generate(
          data.length,
          (index) => jsonEncode(data[index].map((i) => i.toMap()).toList())
              .toString());
      Map<String, dynamic> toWrite = {'data': jsonEncode(resList).toString()};
      await firestore.collection('week_grid').doc(key).set(toWrite);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
