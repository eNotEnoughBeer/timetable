import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timetable/core/navigation/navigation.dart';
import 'package:timetable/core/platform/cache_folder_path.dart';
import 'package:timetable/feature/presentation/bloc/auth/auth_cubit.dart';
import 'package:timetable/feature/presentation/bloc/bells/bells_cubit.dart';
import 'package:timetable/feature/presentation/bloc/lessons/lessons_cubit.dart';
import 'package:timetable/feature/presentation/bloc/user_credentials/user_credentials_cubit.dart';
import 'package:timetable/navigation.dart';
import 'package:timetable/service_locator.dart' as di;

import 'feature/presentation/bloc/schedule_grid/schedule_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await getTempDir();
  await di.initDI();
  Future.delayed(const Duration(seconds: 2));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => di.instance<AuthCubit>()..isLoggedUser(),
        ),
        BlocProvider<UserCredentialsCubit>(
          create: (context) => di.instance<UserCredentialsCubit>(),
        ),
        BlocProvider<LessonsCubit>(
          lazy: false,
          create: (context) => di.instance<LessonsCubit>(),
        ),
        BlocProvider<BellsCubit>(
          lazy: false,
          create: (context) => di.instance<BellsCubit>(),
        ),
        BlocProvider<ScheduleCubit>(
          lazy: false,
          create: (context) => di.instance<ScheduleCubit>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: NavigationActions.navigatorKey,
        title: 'Timetable app',
        theme: ThemeData(
          fontFamily: 'Comfortaa',
        ),
        initialRoute: di.instance<AppNavigation>().initialRoute,
        routes: di.instance<AppNavigation>().routes,
        onGenerateRoute: di.instance<AppNavigation>().onGenerateRoute,
      ),
    );
  }
}
