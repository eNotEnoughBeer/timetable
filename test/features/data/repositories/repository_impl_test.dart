import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetable/core/error/constants.dart';
import 'package:timetable/core/error/failure.dart';
import 'package:timetable/core/platform/network_info.dart';
import 'package:timetable/feature/data/datasources/local_datasource.dart';
import 'package:timetable/feature/data/datasources/remote_datasource.dart';
import 'package:timetable/feature/data/models/lesson_grid_model.dart';
import 'package:timetable/feature/data/models/lesson_model.dart';
import 'package:timetable/feature/data/models/peron_model.dart';
import 'package:timetable/feature/data/models/school_bell_model.dart';
import 'package:timetable/feature/data/repositories/repository_impl.dart';
import 'package:timetable/feature/domain/entities/lesson_entity.dart';
import 'package:timetable/feature/domain/entities/lesson_grid_entity.dart';
import 'package:timetable/feature/domain/entities/person_entity.dart';
import 'package:timetable/feature/domain/entities/school_bell_entity.dart';

class MockRemoteDataSource extends Mock implements RemoteDataSource {}

class MockLocalDataSource extends Mock implements LocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockPersonModel extends Fake implements PersonModel {}

class MockLessonModel extends Fake implements LessonModel {}

class MockSchoolBellModel extends Fake implements SchoolBellModel {}

void main() {
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late RepositoryImpl repositoryImpl;

  setUp(() {
    registerFallbackValue(MockPersonModel());
    registerFallbackValue(MockLessonModel());
    registerFallbackValue(MockSchoolBellModel());
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repositoryImpl = RepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestDeviceOnline(Function testBody) {
    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      testBody();
    });
  }

  void runTestDeviceOffline(Function testBody) {
    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      testBody();
    });
  }

  group('createUser', () {
    const tEmail = 'test@test.com';
    const tPassword = '12345';
    const tUserName = 'tester';
    const tUserUid = '12345sdgsdhsh4452';
    const tModel = PersonModel(
      uid: tUserUid,
      name: tUserName,
      email: tEmail,
      role: 'student',
      avatar: '',
    );
    const PersonEntity tEntity = tModel;

    runTestDeviceOnline(() {
      test('''should return data from remote data source
      if the call is succeeded''', () async {
        when(() => mockRemoteDataSource.createUser(any(), any()))
            .thenAnswer((_) async => tUserUid);

        when(() => mockRemoteDataSource.saveUserData(any(), any(), any()))
            .thenAnswer((_) async => await Future.value());

        when(() => mockLocalDataSource.toCache(any()))
            .thenAnswer((_) async => await Future.value(true));

        final result =
            await repositoryImpl.createUser(tEmail, tPassword, tUserName);
        late PersonEntity resultEntity;
        result.fold((l) => null, (r) => resultEntity = r);

        verify(() => mockNetworkInfo.isConnected);
        verify(() => mockRemoteDataSource.createUser(tEmail, tPassword));
        verify(() =>
            mockRemoteDataSource.saveUserData(tModel, tPassword, tPassword));
        verify(() => mockLocalDataSource.toCache(tPassword));
        expect(resultEntity, tEntity);
      });
    });

    runTestDeviceOffline(() {
      test('should return exception if the device is offline', () async {
        final result =
            await repositoryImpl.createUser(tEmail, tPassword, tUserName);
        expect(
          result,
          const Left(ServerFailure(
            cNeedConnectionStr,
          )),
        );
        verifyZeroInteractions(mockLocalDataSource);
        verifyZeroInteractions(mockRemoteDataSource);
      });
    });
  });

  group('login', () {
    const tEmail = 'test@test.com';
    const tPassword = '12345';
    const tModel = PersonModel(
      uid: '',
      name: '',
      email: tEmail,
      role: 'student',
      avatar: '',
    );
    const PersonEntity tEntity = tModel;

    runTestDeviceOnline(() {
      test('''should return data from remote data source
      if the call is succeeded''', () async {
        when(() => mockRemoteDataSource.login(any(), any()))
            .thenAnswer((_) async => true);

        when(() => mockRemoteDataSource.getUserData())
            .thenAnswer((_) async => tModel);

        when(() => mockLocalDataSource.toCache(any()))
            .thenAnswer((_) async => await Future.value(true));

        final result = await repositoryImpl.login(tEmail, tPassword);
        late PersonEntity resultEntity;
        result.fold((l) => null, (r) => resultEntity = r);

        verify(() => mockNetworkInfo.isConnected);
        verify(() => mockRemoteDataSource.login(tEmail, tPassword));
        verify(() => mockRemoteDataSource.getUserData());
        verify(() => mockLocalDataSource.toCache(tPassword));
        expect(resultEntity, tEntity);
      });
    });

    runTestDeviceOffline(() {
      test('should return exception if the device is offline', () async {
        final result = await repositoryImpl.login(tEmail, tPassword);
        expect(
          result,
          const Left(ServerFailure(
            cNeedConnectionStr,
          )),
        );
        verifyZeroInteractions(mockLocalDataSource);
        verifyZeroInteractions(mockRemoteDataSource);
      });
    });
  });

  group('logout', () {
    runTestDeviceOnline(() {
      test('''should return void from remote data source
      if the call is succeeded''', () async {
        when(() => mockRemoteDataSource.logout())
            .thenAnswer((_) async => await Future.value());

        await repositoryImpl.logout();

        verify(() => mockNetworkInfo.isConnected);
        verify(() => mockRemoteDataSource.logout());
      });
    });

    runTestDeviceOffline(() {
      test('should return exception if the device is offline', () async {
        final result = await repositoryImpl.logout();
        expect(
          result,
          const Left(ServerFailure(
            cNeedConnectionStr,
          )),
        );
        verifyZeroInteractions(mockLocalDataSource);
        verifyZeroInteractions(mockRemoteDataSource);
      });
    });
  });

  group('saveUserData', () {
    const tPassword = '12345';

    const tModel = PersonModel(
      uid: '',
      name: '',
      email: '',
      role: 'student',
      avatar: '',
    );
    const PersonEntity tEntity = tModel;

    runTestDeviceOnline(() {
      test('''should return void from remote data source
      if the call is succeeded''', () async {
        when(() => mockRemoteDataSource.saveUserData(any(), any(), any()))
            .thenAnswer((_) async => await Future.value());

        when(() => mockLocalDataSource.toCache(any()))
            .thenAnswer((_) async => await Future.value(true));

        await repositoryImpl.saveUserData(tEntity, tPassword);

        verify(() => mockNetworkInfo.isConnected);
        verify(() =>
            mockRemoteDataSource.saveUserData(tModel, tPassword, tPassword));
        verify(() => mockLocalDataSource.toCache(tPassword));
      });
    });

    runTestDeviceOffline(() {
      test('should return exception if the device is offline', () async {
        final result = await repositoryImpl.saveUserData(tEntity, tPassword);
        expect(
          result,
          const Left(ServerFailure(
            cNeedConnectionStr,
          )),
        );
        verifyZeroInteractions(mockLocalDataSource);
        verifyZeroInteractions(mockRemoteDataSource);
      });
    });
  });

  group('getUserData', () {
    const tModel = PersonModel(
      uid: '',
      name: '',
      email: '',
      role: 'student',
      avatar: '',
    );
    const PersonEntity tEntity = tModel;
    runTestDeviceOnline(() {
      test('''should return data from remote data source
      if the call is succeeded''', () async {
        when(() => mockRemoteDataSource.getUserData())
            .thenAnswer((_) async => tModel);

        final result = await repositoryImpl.getUserData();
        late PersonEntity resEntity;
        result.fold((l) => null, (r) => resEntity = r);

        verify(() => mockNetworkInfo.isConnected);
        verify(() => mockRemoteDataSource.getUserData());
        expect(resEntity, tEntity);
      });
    });

    runTestDeviceOffline(() {
      test('should return exception if the device is offline', () async {
        final result = await repositoryImpl.getUserData();
        expect(
          result,
          const Left(ServerFailure(
            cNeedConnectionStr,
          )),
        );
        verifyZeroInteractions(mockLocalDataSource);
        verifyZeroInteractions(mockRemoteDataSource);
      });
    });
  });

  group('forgotPassword', () {
    const tEmail = 'test@test.com';
    runTestDeviceOnline(() {
      test('''should return void from remote data source
      if the call is succeeded''', () async {
        when(() => mockRemoteDataSource.restorePassword(any()))
            .thenAnswer((_) async => await Future.value());

        await repositoryImpl.forgotPassword(tEmail);

        verify(() => mockNetworkInfo.isConnected);
        verify(() => mockRemoteDataSource.restorePassword(tEmail));
      });
    });

    runTestDeviceOffline(() {
      test('should return exception if the device is offline', () async {
        final result = await repositoryImpl.forgotPassword(tEmail);
        expect(
          result,
          const Left(ServerFailure(
            cNeedConnectionStr,
          )),
        );
        verifyZeroInteractions(mockLocalDataSource);
        verifyZeroInteractions(mockRemoteDataSource);
      });
    });
  });

  test('getUserCachedPassword', () {
    const tPassword = '12345';
    when(() => mockLocalDataSource.fromCache()).thenReturn(tPassword);
    final result = repositoryImpl.getUserCachedPassword();
    verify(() => mockLocalDataSource.fromCache());
    expect(result, tPassword);
  });

  test('isUserLoggedIn', () {
    when(() => mockRemoteDataSource.isLoggedIn()).thenReturn(true);
    final result = repositoryImpl.isUserLoggedIn();
    verify(() => mockRemoteDataSource.isLoggedIn());
    expect(result, true);
  });

  test('getUserUid', () {
    const tUid = 'test uid';
    when(() => mockRemoteDataSource.getUserUid()).thenReturn(tUid);
    final result = repositoryImpl.getUserUid();
    verify(() => mockRemoteDataSource.getUserUid());
    expect(result, tUid);
  });

  group('addLesson', () {
    const tModel = LessonModel(
      uid: 'test uid',
      name: 'test name',
      description: 'test description',
      googleKey: 'test google key',
      iconIndex: 1,
      teacherAvatar: 'test url avatar',
      teacherName: 'test teacher name',
    );
    const LessonEntity tEntity = tModel;
    runTestDeviceOnline(() {
      test('''should return void from remote data source
      if the call is succeeded''', () async {
        when(() => mockRemoteDataSource.addLesson(any()))
            .thenAnswer((_) async => await Future.value());

        await repositoryImpl.addLesson(tEntity);

        verify(() => mockNetworkInfo.isConnected);
        verify(() => mockRemoteDataSource.addLesson(tModel));
      });
    });

    runTestDeviceOffline(() {
      test('should return exception if the device is offline', () async {
        final result = await repositoryImpl.addLesson(tEntity);
        expect(
          result,
          const Left(ServerFailure(
            cNeedConnectionStr,
          )),
        );
        verifyZeroInteractions(mockLocalDataSource);
        verifyZeroInteractions(mockRemoteDataSource);
      });
    });
  });

  group('deleteLesson', () {
    const tModel = LessonModel(
      uid: 'test uid',
      name: 'test name',
      description: 'test description',
      googleKey: 'test google key',
      iconIndex: 1,
      teacherAvatar: 'test url avatar',
      teacherName: 'test teacher name',
    );
    const LessonEntity tEntity = tModel;
    runTestDeviceOnline(() {
      test('''should return void from remote data source
      if the call is succeeded''', () async {
        when(() => mockRemoteDataSource.deleteLesson(any()))
            .thenAnswer((_) async => await Future.value());

        await repositoryImpl.deleteLesson(tEntity);

        verify(() => mockNetworkInfo.isConnected);
        verify(() => mockRemoteDataSource.deleteLesson(tModel));
      });
    });

    runTestDeviceOffline(() {
      test('should return exception if the device is offline', () async {
        final result = await repositoryImpl.deleteLesson(tEntity);
        expect(
          result,
          const Left(ServerFailure(
            cNeedConnectionStr,
          )),
        );
        verifyZeroInteractions(mockLocalDataSource);
        verifyZeroInteractions(mockRemoteDataSource);
      });
    });
  });

  group('updateLesson', () {
    const tModel = LessonModel(
      uid: 'test uid',
      name: 'test name',
      description: 'test description',
      googleKey: 'test google key',
      iconIndex: 1,
      teacherAvatar: 'test url avatar',
      teacherName: 'test teacher name',
    );
    const LessonEntity tEntity = tModel;
    runTestDeviceOnline(() {
      test('''should return void from remote data source
      if the call is succeeded''', () async {
        when(() => mockRemoteDataSource.updateLesson(any()))
            .thenAnswer((_) async => await Future.value());

        await repositoryImpl.updateLesson(tEntity);

        verify(() => mockNetworkInfo.isConnected);
        verify(() => mockRemoteDataSource.updateLesson(tModel));
      });
    });

    runTestDeviceOffline(() {
      test('should return exception if the device is offline', () async {
        final result = await repositoryImpl.updateLesson(tEntity);
        expect(
          result,
          const Left(ServerFailure(
            cNeedConnectionStr,
          )),
        );
        verifyZeroInteractions(mockLocalDataSource);
        verifyZeroInteractions(mockRemoteDataSource);
      });
    });
  });

  group('getLessons', () {
    final tLesson = LessonModel.emptyLesson();
    final listLessons = [tLesson, tLesson];
    runTestDeviceOnline(() {
      test('''should return a list of LessonEntity entities 
      from remote data source if the call is succeeded''', () async {
        when(() => mockRemoteDataSource.getLessons())
            .thenAnswer((_) async => await Future.value(listLessons));

        final result = await repositoryImpl.getLessons();
        late List<LessonEntity> resEntityList;
        result.fold((l) => null, (r) => resEntityList = r);

        verify(() => mockNetworkInfo.isConnected);
        verify(() => mockRemoteDataSource.getLessons());
        expect(resEntityList.length, 2);
      });
    });

    runTestDeviceOffline(() {
      test('should return exception if the device is offline', () async {
        final result = await repositoryImpl.getLessons();
        expect(
          result,
          const Left(ServerFailure(
            cNeedConnectionStr,
          )),
        );
        verifyZeroInteractions(mockLocalDataSource);
        verifyZeroInteractions(mockRemoteDataSource);
      });
    });
  });

  group('addBell', () {
    const tModel = SchoolBellModel(
        uid: 'test uid', lessonNumber: 1, fromTime: '08:00', toTime: '09:10');
    const SchoolBellEntity tEntity = tModel;
    runTestDeviceOnline(() {
      test('''should return void from remote data source
      if the call is succeeded''', () async {
        when(() => mockRemoteDataSource.addBell(any()))
            .thenAnswer((_) async => await Future.value());

        await repositoryImpl.addBell(tEntity);

        verify(() => mockNetworkInfo.isConnected);
        verify(() => mockRemoteDataSource.addBell(tModel));
      });
    });

    runTestDeviceOffline(() {
      test('should return exception if the device is offline', () async {
        final result = await repositoryImpl.addBell(tEntity);
        expect(
          result,
          const Left(ServerFailure(
            cNeedConnectionStr,
          )),
        );
        verifyZeroInteractions(mockLocalDataSource);
        verifyZeroInteractions(mockRemoteDataSource);
      });
    });
  });

  group('deleteBell', () {
    const tModel = SchoolBellModel(
        uid: 'test uid', lessonNumber: 1, fromTime: '08:00', toTime: '09:10');
    const SchoolBellEntity tEntity = tModel;
    runTestDeviceOnline(() {
      test('''should return void from remote data source
      if the call is succeeded''', () async {
        when(() => mockRemoteDataSource.deleteBell(any()))
            .thenAnswer((_) async => await Future.value());

        await repositoryImpl.deleteBell(tEntity);

        verify(() => mockNetworkInfo.isConnected);
        verify(() => mockRemoteDataSource.deleteBell(tModel));
      });
    });

    runTestDeviceOffline(() {
      test('should return exception if the device is offline', () async {
        final result = await repositoryImpl.deleteBell(tEntity);
        expect(
          result,
          const Left(ServerFailure(
            cNeedConnectionStr,
          )),
        );
        verifyZeroInteractions(mockLocalDataSource);
        verifyZeroInteractions(mockRemoteDataSource);
      });
    });
  });

  group('updateBell', () {
    const tModel = SchoolBellModel(
        uid: 'test uid', lessonNumber: 1, fromTime: '08:00', toTime: '09:10');
    const SchoolBellEntity tEntity = tModel;
    runTestDeviceOnline(() {
      test('''should return void from remote data source
      if the call is succeeded''', () async {
        when(() => mockRemoteDataSource.updateBell(any()))
            .thenAnswer((_) async => await Future.value());

        await repositoryImpl.updateBell(tEntity);

        verify(() => mockNetworkInfo.isConnected);
        verify(() => mockRemoteDataSource.updateBell(tModel));
      });
    });

    runTestDeviceOffline(() {
      test('should return exception if the device is offline', () async {
        final result = await repositoryImpl.updateBell(tEntity);
        expect(
          result,
          const Left(ServerFailure(
            cNeedConnectionStr,
          )),
        );
        verifyZeroInteractions(mockLocalDataSource);
        verifyZeroInteractions(mockRemoteDataSource);
      });
    });
  });

  group('getBells', () {
    final tModel = SchoolBellModel.emptyBell();
    final listModels = [tModel, tModel];
    runTestDeviceOnline(() {
      test(
          '''should return list of SchoolBellEntity entities from remote data source
      if the call is succeeded''', () async {
        when(() => mockRemoteDataSource.getBells())
            .thenAnswer((_) async => await Future.value(listModels));

        final result = await repositoryImpl.getBells();
        late List<SchoolBellEntity> resEntityList;
        result.fold((l) => null, (r) => resEntityList = r);

        verify(() => mockNetworkInfo.isConnected);
        verify(() => mockRemoteDataSource.getBells());
        expect(resEntityList.length, 2);
      });
    });

    runTestDeviceOffline(() {
      test('should return exception if the device is offline', () async {
        final result = await repositoryImpl.getBells();
        expect(
          result,
          const Left(ServerFailure(
            cNeedConnectionStr,
          )),
        );
        verifyZeroInteractions(mockLocalDataSource);
        verifyZeroInteractions(mockRemoteDataSource);
      });
    });
  });

  group('getLessonsWeekGrid', () {
    const String key = 'test key';
    final List<List<LessonGridModel>> testSchedule = List.generate(
        5, (index) => List.generate(8, (i) => LessonGridModel.emptyElement()));

    runTestDeviceOnline(() {
      test('''should return a schedule grid from remote data source
      if the call is succeeded''', () async {
        when(() => mockRemoteDataSource.getLessonsWeekGrid(any()))
            .thenAnswer((_) async => await Future.value(testSchedule));

        final result = await repositoryImpl.getLessonsWeekGrid(key);
        late List<List<LessonGridEntity>> resEntityList;
        result.fold((l) => null, (r) => resEntityList = r);

        verify(() => mockNetworkInfo.isConnected);
        verify(() => mockRemoteDataSource.getLessonsWeekGrid(key));
        expect(resEntityList.length, 5);
      });
    });

    runTestDeviceOffline(() {
      test('should return exception if the device is offline', () async {
        final result = await repositoryImpl.getLessonsWeekGrid(key);
        expect(
          result,
          const Left(ServerFailure(
            cNeedConnectionStr,
          )),
        );
        verifyZeroInteractions(mockLocalDataSource);
        verifyZeroInteractions(mockRemoteDataSource);
      });
    });
  });

  group('setLessonsWeekGrid', () {
    const String key = 'test key';
    final List<List<LessonGridModel>> testSchedule = List.generate(
        5, (index) => List.generate(8, (i) => LessonGridModel.emptyElement()));

    runTestDeviceOnline(() {
      test('should return a void if the call is succeeded', () async {
        when(() => mockRemoteDataSource.setLessonsWeekGrid(any(), testSchedule))
            .thenAnswer((_) async => await Future.value());

        await repositoryImpl.setLessonsWeekGrid(key, testSchedule);

        verify(() => mockNetworkInfo.isConnected);
        verify(
            () => mockRemoteDataSource.setLessonsWeekGrid(key, testSchedule));
      });
    });

    runTestDeviceOffline(() {
      test('should return exception if the device is offline', () async {
        final result =
            await repositoryImpl.setLessonsWeekGrid(key, testSchedule);
        expect(
          result,
          const Left(ServerFailure(
            cNeedConnectionStr,
          )),
        );
        verifyZeroInteractions(mockLocalDataSource);
        verifyZeroInteractions(mockRemoteDataSource);
      });
    });
  });
}
