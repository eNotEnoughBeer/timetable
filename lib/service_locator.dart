import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timetable/core/navigation/navigation.dart';
import 'package:timetable/core/platform/network_info.dart';
import 'package:timetable/feature/data/datasources/local_datasource.dart';
import 'package:timetable/feature/data/datasources/remote_datasource.dart';
import 'package:timetable/feature/data/repositories/repository_impl.dart';
import 'package:timetable/feature/domain/repositories/repository.dart';
import 'package:timetable/feature/domain/usecases/auth_forgot_password.dart';
import 'package:timetable/feature/domain/usecases/auth_is_logged_in_usecase.dart';
import 'package:timetable/feature/domain/usecases/bells_add_usecase.dart';
import 'package:timetable/feature/domain/usecases/bells_delete_usecase.dart';
import 'package:timetable/feature/domain/usecases/bells_get_all_usecase.dart';
import 'package:timetable/feature/domain/usecases/bells_update_usecase.dart';
import 'package:timetable/feature/domain/usecases/lesson_add_usecase.dart';
import 'package:timetable/feature/domain/usecases/lesson_delete_usecase.dart';
import 'package:timetable/feature/domain/usecases/lesson_get_all_usecase.dart';
import 'package:timetable/feature/domain/usecases/lesson_update_usecase.dart';
import 'package:timetable/feature/domain/usecases/peron_get_user_cached_password.dart';
import 'package:timetable/feature/domain/usecases/person_get_user_data_usecase.dart';
import 'package:timetable/feature/domain/usecases/auth_login_usecase.dart';
import 'package:timetable/feature/domain/usecases/auth_logout_usecase.dart';
import 'package:timetable/feature/domain/usecases/auth_signup_usecase.dart';
import 'package:timetable/feature/domain/usecases/person_get_user_uid.dart';
import 'package:timetable/feature/domain/usecases/person_update_user_data_usecase.dart';
import 'package:timetable/feature/domain/usecases/week_get_lessons_grid.dart';
import 'package:timetable/feature/domain/usecases/week_set_lessons_grid.dart';
import 'package:timetable/feature/presentation/bloc/auth/auth_cubit.dart';
import 'package:timetable/feature/presentation/bloc/bells/bells_cubit.dart';
import 'package:timetable/feature/presentation/bloc/lessons/lessons_cubit.dart';
import 'package:timetable/feature/presentation/bloc/schedule_grid/schedule_cubit.dart';
import 'package:timetable/feature/presentation/bloc/user_credentials/user_credentials_cubit.dart';
import 'package:timetable/navigation.dart';

final instance = GetIt.instance;

Future<void> initDI() async {
  //Logic (BLoC/Cubit)
  instance.registerFactory(() => AuthCubit(
        forgotPasswordUsecase: instance(),
        isLoggedInUsecase: instance(),
        loginUsecase: instance(),
        logoutUsecase: instance(),
        signUpUsecase: instance(),
      ));

  instance.registerFactory(() => UserCredentialsCubit(
        getUserCachedPasswordUsecase: instance(),
        getUserDataUsecase: instance(),
        updateUserDataUsecase: instance(),
        getUserUidUsecase: instance(),
      ));

  instance.registerLazySingleton(() => LessonsCubit(
        addLessonUsecase: instance(),
        deleteLessonUsecase: instance(),
        getLessonsUsecase: instance(),
        updateLessonUsecase: instance(),
      ));

  instance.registerLazySingleton(() => BellsCubit(
        addBellUsecase: instance(),
        deleteBellUsecase: instance(),
        getBellsUsecase: instance(),
        updateBellUsecase: instance(),
      ));

  instance.registerFactory(() => ScheduleCubit(
        bellsCubit: instance(),
        lessonsCubit: instance(),
        lessonsSet: instance(),
        lessonsGet: instance(),
      ));

  //Usecase
  //auth
  instance.registerLazySingleton(() => LoginUsecase(instance()));
  instance.registerLazySingleton(() => LogoutUsecase(instance()));
  instance.registerLazySingleton(() => SignUpUsecase(instance()));
  instance.registerLazySingleton(() => ForgotPasswordUsecase(instance()));
  instance.registerLazySingleton(() => IsLoggedInUsecase(instance()));
  //person profile
  instance.registerLazySingleton(() => GetUserDataUsecase(instance()));
  instance.registerLazySingleton(() => UpdateUserDataUsecase(instance()));
  instance
      .registerLazySingleton(() => GetUserCachedPasswordUsecase(instance()));
  instance.registerLazySingleton(() => GetUserUidUsecase(instance()));
  //lessons
  instance.registerLazySingleton(() => AddLessonUsecase(instance()));
  instance.registerLazySingleton(() => DeleteLessonUsecase(instance()));
  instance.registerLazySingleton(() => UpdateLessonUsecase(instance()));
  instance.registerLazySingleton(() => GetLessonsUsecase(instance()));
  //bells
  instance.registerLazySingleton(() => AddBellUsecase(instance()));
  instance.registerLazySingleton(() => DeleteBellUsecase(instance()));
  instance.registerLazySingleton(() => UpdateBellUsecase(instance()));
  instance.registerLazySingleton(() => GetBellsUsecase(instance()));
  //schedule_grid
  instance.registerLazySingleton(() => WeekGridLessonsGet(instance()));
  instance.registerLazySingleton(() => WeekGridLessonsSet(instance()));

  //Repository
  instance.registerLazySingleton<Repository>(() => RepositoryImpl(
        localDataSource: instance(),
        remoteDataSource: instance(),
        networkInfo: instance(),
      ));

  instance.registerLazySingleton<RemoteDataSource>(
      () => FirebaseRemoteDataSourceImpl(
            auth: instance(),
            firestore: instance(),
            storage: instance(),
          ));

  instance.registerLazySingleton<LocalDataSource>(
      () => LocalDataSourceImpl(storage: instance()));

  //Core
  instance
      .registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(instance()));

  instance.registerSingleton<AppNavigation>(NavigationImpl());
  //External
  final sharedPreferences = await SharedPreferences.getInstance();
  instance.registerLazySingleton(() => sharedPreferences);

  final auth = FirebaseAuth.instance;
  instance.registerLazySingleton(() => auth);

  final firestore = FirebaseFirestore.instance;
  instance.registerLazySingleton(() => firestore);

  final storage = FirebaseStorage.instance;
  instance.registerLazySingleton(() => storage);

  instance.registerLazySingleton(() => InternetConnectionChecker());
}
