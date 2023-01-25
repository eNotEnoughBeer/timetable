/*
щоб тести вдалися, довелося попрацювати трохи сокирою у файлі mock_user.dart
з пакету firebase_auth_mocks.
зміни:
1. прибрав final зі змінних класу
String? _email;
String? _photoURL;

2. додав функції
  set photoURL(String? value) {
    _photoURL = value;
  }

  set email(String? value) {
    _email = value;
  }

  @override
  Future<void> updateEmail(String? value){
    email = value;
    return Future.value();
  }

  @override
  Future<void> updatePhotoURL(String? value){
    photoURL = value;
    return Future.value();
  }
*/
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:timetable/feature/data/datasources/remote_datasource.dart';
import 'package:timetable/feature/data/models/peron_model.dart';

void main() {
  final mockFirestore = FakeFirebaseFirestore();
  final mockStorage = MockFirebaseStorage();
  final mockAuth = MockFirebaseAuth();
  final remoteDataSourceImpl = FirebaseRemoteDataSourceImpl(
    storage: mockStorage,
    firestore: mockFirestore,
    auth: mockAuth,
  );

  test('createUser', () async {
    const tEmail = 'test@test.com';
    const tPassword = '123456';

    final result = await remoteDataSourceImpl.createUser(tEmail, tPassword);
    expect(tEmail, mockAuth.currentUser!.email);
    expect(result, true);
  });

  test('login', () async {
    const tEmail = 'test@test.com';
    const tPassword = '123456';

    final result = await remoteDataSourceImpl.login(tEmail, tPassword);
    expect(tEmail, mockAuth.currentUser!.email);
    expect(result, true);
  });

  test('logout', () async {
    await remoteDataSourceImpl.logout();
    expect(mockAuth.currentUser, isNull);
  });

  test('saveUserData', () async {
    const tPassword = '123456';
    const tOldPassword = '123123';
    const tEmail = 'test@test.com';
    const tNewEmail = 'newtest@test.com';

    await mockAuth.signInWithEmailAndPassword(
        email: tEmail, password: tPassword);

    final tEntity = PersonModel(
        uid: mockAuth.currentUser!.uid,
        name: 'test name',
        email: tNewEmail,
        role: 'test role',
        avatar: 'local phone new picture path');

    await remoteDataSourceImpl.saveUserData(tEntity, tPassword, tOldPassword);
    expect(tEntity.email, mockAuth.currentUser!.email);
    expect(tEntity.name, mockAuth.currentUser!.displayName);
    final snapshot =
        await mockFirestore.collection('users').doc(tEntity.uid).get();
    final model = PersonModel.fromMap(snapshot.data()!);
    expect(tEntity.email, model.email);
    expect(tEntity.name, model.name);
    expect(mockAuth.currentUser!.photoURL, model.avatar);
    expect(tEntity.role, model.role);
  });
}
