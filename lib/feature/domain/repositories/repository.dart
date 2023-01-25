import 'package:dartz/dartz.dart';
import 'package:timetable/core/error/failure.dart';
import 'package:timetable/feature/domain/entities/lesson_entity.dart';
import 'package:timetable/feature/domain/entities/school_bell_entity.dart';
import '../entities/lesson_grid_entity.dart';
import '../entities/person_entity.dart';

abstract class Repository {
  //auth part
  bool isUserLoggedIn();

  Future<Either<Failure, PersonEntity>> login(
    String email,
    String password,
  );

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, PersonEntity>> createUser(
    String email,
    String password,
    String userName,
  );

  Future<Either<Failure, void>> forgotPassword(String email);

  // user profile part
  Future<Either<Failure, PersonEntity>> getUserData();

  Future<Either<Failure, void>> saveUserData(
    PersonEntity userData,
    String password,
  );

  String getUserCachedPassword();
  String getUserUid();

  //
  Future<Either<Failure, void>> addLesson(LessonEntity lesson);
  Future<Either<Failure, void>> updateLesson(LessonEntity lesson);
  Future<Either<Failure, void>> deleteLesson(LessonEntity lesson);
  Future<Either<Failure, List<LessonEntity>>> getLessons();
  //
  Future<Either<Failure, void>> addBell(SchoolBellEntity bellEntity);
  Future<Either<Failure, void>> updateBell(SchoolBellEntity bellEntity);
  Future<Either<Failure, void>> deleteBell(SchoolBellEntity bellEntity);
  Future<Either<Failure, List<SchoolBellEntity>>> getBells();
  //
  Future<Either<Failure, List<List<LessonGridEntity>>>> getLessonsWeekGrid(
      String key);
  Future<Either<Failure, void>> setLessonsWeekGrid(
      String key, List<List<LessonGridEntity>> data);
}
