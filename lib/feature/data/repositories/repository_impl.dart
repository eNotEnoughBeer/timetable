import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:timetable/core/error/constants.dart';
import 'package:timetable/core/error/exception.dart';
import 'package:timetable/core/error/failure.dart';
import 'package:timetable/core/platform/network_info.dart';
import 'package:timetable/feature/data/datasources/local_datasource.dart';
import 'package:timetable/feature/data/datasources/remote_datasource.dart';
import 'package:timetable/feature/data/models/lesson_model.dart';
import 'package:timetable/feature/data/models/peron_model.dart';
import 'package:timetable/feature/domain/entities/lesson_entity.dart';
import 'package:timetable/feature/domain/entities/lesson_grid_entity.dart';
import 'package:timetable/feature/domain/entities/person_entity.dart';
import 'package:timetable/feature/domain/entities/school_bell_entity.dart';
import 'package:timetable/feature/domain/repositories/repository.dart';

import '../models/lesson_grid_model.dart';
import '../models/school_bell_model.dart';

class RepositoryImpl implements Repository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  RepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, PersonEntity>> createUser(
      String email, String password, String userName) async {
    if (await networkInfo.isConnected) {
      try {
        final resFunc = await remoteDataSource.createUser(email, password);
        if (resFunc != null) {
          // якщо все добре, робимо кєш
          var data = PersonModel.emptyPerson();
          data = data.copyWith(
            uid: resFunc,
            email: email,
            name: userName,
          );
          await saveUserData(data, password);
          return Right(data);
        }
        return const Left(
            ServerFailure('unknown error while create user process'));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ServerFailure(cNeedConnectionStr));
    }
  }

  @override
  Future<Either<Failure, PersonEntity>> login(
      String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.login(email, password);
        // якщо все добре, робимо кєш
        final dataEnt = await remoteDataSource.getUserData();
        await localDataSource.toCache(password);
        return Right(dataEnt);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      // інтернет відвалився
      return const Left(ServerFailure(cNeedConnectionStr));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    if (await networkInfo.isConnected) {
      return Right(await remoteDataSource.logout());
    } else {
      return const Left(ServerFailure(cNeedConnectionStr));
    }
  }

  @override
  Future<Either<Failure, void>> saveUserData(
      PersonEntity userData, String password) async {
    if (await networkInfo.isConnected) {
      try {
        // пишемо у firebase
        final model = PersonModel(
          uid: userData.uid,
          email: userData.email,
          name: userData.name,
          role: userData.role,
          avatar: userData.avatar,
        );
        var oldPassword = localDataSource.fromCache();
        if (oldPassword.isEmpty) oldPassword = password;
        await remoteDataSource.saveUserData(model, password, oldPassword);
        await localDataSource.toCache(password);
        return Right(await Future.value());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      // ну немає інтернету
      return const Left(ServerFailure(cNeedConnectionStr));
    }
  }

  @override
  Future<Either<Failure, PersonEntity>> getUserData() async {
    if (await networkInfo.isConnected) {
      // читаємо з firebase, пишемо у кеш
      try {
        final userData = await remoteDataSource.getUserData();
        return Right(userData);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      // ну немає інтернету
      return const Left(ServerFailure(cNeedConnectionStr));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await remoteDataSource.restorePassword(email));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    }
    return const Left(ServerFailure(cNeedConnectionStr));
  }

  @override
  String getUserCachedPassword() => localDataSource.fromCache();

  @override
  bool isUserLoggedIn() => remoteDataSource.isLoggedIn();

  @override
  String getUserUid() => remoteDataSource.getUserUid();

  @override
  Future<Either<Failure, void>> addLesson(LessonEntity lesson) async {
    if (await networkInfo.isConnected) {
      try {
        final model = LessonModel(
          name: lesson.name,
          uid: lesson.uid,
          teacherName: lesson.teacherName,
          teacherAvatar: lesson.teacherAvatar,
          iconIndex: lesson.iconIndex,
          googleKey: lesson.googleKey,
          description: lesson.description,
        );
        return Right(await remoteDataSource.addLesson(model));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    }
    return const Left(ServerFailure(cNeedConnectionStr));
  }

  @override
  Future<Either<Failure, void>> deleteLesson(LessonEntity lesson) async {
    if (await networkInfo.isConnected) {
      try {
        final model = LessonModel(
          name: lesson.name,
          uid: lesson.uid,
          teacherName: lesson.teacherName,
          teacherAvatar: lesson.teacherAvatar,
          iconIndex: lesson.iconIndex,
          googleKey: lesson.googleKey,
          description: lesson.description,
        );
        return Right(await remoteDataSource.deleteLesson(model));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    }
    return const Left(ServerFailure(cNeedConnectionStr));
  }

  @override
  Future<Either<Failure, List<LessonEntity>>> getLessons() async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await remoteDataSource.getLessons());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    }
    return const Left(ServerFailure(cNeedConnectionStr));
  }

  @override
  Future<Either<Failure, void>> updateLesson(LessonEntity lesson) async {
    if (await networkInfo.isConnected) {
      try {
        final model = LessonModel(
          name: lesson.name,
          uid: lesson.uid,
          teacherName: lesson.teacherName,
          teacherAvatar: lesson.teacherAvatar,
          iconIndex: lesson.iconIndex,
          googleKey: lesson.googleKey,
          description: lesson.description,
        );
        return Right(await remoteDataSource.updateLesson(model));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    }
    return const Left(ServerFailure(cNeedConnectionStr));
  }

  @override
  Future<Either<Failure, void>> addBell(SchoolBellEntity bellEntity) async {
    if (await networkInfo.isConnected) {
      try {
        final model = SchoolBellModel(
          uid: bellEntity.uid,
          toTime: bellEntity.toTime,
          lessonNumber: bellEntity.lessonNumber,
          fromTime: bellEntity.fromTime,
        );
        return Right(await remoteDataSource.addBell(model));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    }
    return const Left(ServerFailure(cNeedConnectionStr));
  }

  @override
  Future<Either<Failure, void>> deleteBell(SchoolBellEntity bellEntity) async {
    if (await networkInfo.isConnected) {
      try {
        final model = SchoolBellModel(
          uid: bellEntity.uid,
          fromTime: bellEntity.fromTime,
          lessonNumber: bellEntity.lessonNumber,
          toTime: bellEntity.toTime,
        );
        return Right(await remoteDataSource.deleteBell(model));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    }
    return const Left(ServerFailure(cNeedConnectionStr));
  }

  @override
  Future<Either<Failure, List<SchoolBellEntity>>> getBells() async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await remoteDataSource.getBells());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    }
    return const Left(ServerFailure(cNeedConnectionStr));
  }

  @override
  Future<Either<Failure, void>> updateBell(SchoolBellEntity bellEntity) async {
    if (await networkInfo.isConnected) {
      try {
        final model = SchoolBellModel(
          uid: bellEntity.uid,
          fromTime: bellEntity.fromTime,
          lessonNumber: bellEntity.lessonNumber,
          toTime: bellEntity.toTime,
        );
        return Right(await remoteDataSource.updateBell(model));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    }
    return const Left(ServerFailure(cNeedConnectionStr));
  }

  @override
  Future<Either<Failure, List<List<LessonGridEntity>>>> getLessonsWeekGrid(
    String key,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await remoteDataSource.getLessonsWeekGrid(key));
      } on ServerException catch (e) {
        debugPrint('-->getLessonsWeekGrid ServerException: ${e.message}');
        return Left(ServerFailure(e.message));
      } on CacheException {
        debugPrint('-->getLessonsWeekGrid CacheException');
        return Left(CacheFailure());
      }
    }
    return const Left(ServerFailure(cNeedConnectionStr));
  }

  @override
  Future<Either<Failure, void>> setLessonsWeekGrid(
    String key,
    List<List<LessonGridEntity>> data,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final res = data
            .map((day) => day
                .map((lesson) => LessonGridModel(
                      lessonIndex: lesson.lessonIndex,
                      lessonUid: lesson.lessonUid,
                      dayIndex: lesson.dayIndex,
                    ))
                .toList())
            .toList();
        return Right(await remoteDataSource.setLessonsWeekGrid(key, res));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    }
    return const Left(ServerFailure(cNeedConnectionStr));
  }
}
