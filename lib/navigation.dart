import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetable/core/navigation/navigation.dart';
import 'package:timetable/feature/data/models/lesson_model.dart';
import 'package:timetable/feature/data/models/school_bell_model.dart';
import 'package:timetable/feature/domain/entities/lesson_entity.dart';
import 'package:timetable/feature/domain/entities/school_bell_entity.dart';
import 'package:timetable/feature/presentation/bloc/auth/auth_cubit.dart';
import 'package:timetable/feature/presentation/bloc/bells/bells_cubit.dart';
import 'package:timetable/feature/presentation/bloc/schedule_grid/schedule_cubit.dart';
import 'package:timetable/feature/presentation/bloc/user_credentials/user_credentials_cubit.dart';
import 'package:timetable/feature/presentation/pages/auth_page.dart';
import 'package:timetable/feature/presentation/pages/bell_details_screen.dart';
import 'package:timetable/feature/presentation/pages/bells_screen.dart';
import 'package:timetable/feature/presentation/pages/lesson_details_screen.dart';
import 'package:timetable/feature/presentation/pages/lessons_screen.dart';
import 'package:timetable/feature/presentation/pages/main_page.dart';
import 'package:timetable/feature/presentation/pages/user_details_page.dart';
import 'package:timetable/feature/presentation/pages/week_grid_page.dart';

import 'feature/presentation/bloc/lessons/lessons_cubit.dart';

class NavigationImpl implements AppNavigation {
  @override
  String get initialRoute => NavigationRouteNames.mainScreen;

  @override
  Map<String, Widget Function(BuildContext context)> get routes => {
        NavigationRouteNames.mainScreen: (context) {
          return BlocBuilder<AuthCubit, AuthState>(builder: ((context, state) {
            if (state is Authenticated) {
              // аутентіфікація пройшла вдало.
              // вантажимо з БД всі необхідні дані
              context.read<UserCredentialsCubit>().userData();
              context.read<LessonsCubit>().getLessons();
              context.read<BellsCubit>().getBells();
              //...

              // і переходимо на головну сторінку
              return const MainPage();
            }
            return const AuthPage();
          }));
        },
        NavigationRouteNames.userDetailsScreen: (context) =>
            const UserDetailsPage(),
        NavigationRouteNames.lessonsScreen: (context) => const LessonsScreen(),
        NavigationRouteNames.bellsScreen: (context) => const BellsScreen(),
        NavigationRouteNames.weekGridScreen: (context) => const WeekGridPage(),
      };

  @override
  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case NavigationRouteNames.lessonDetailsScreen:
        final entity = settings.arguments is LessonEntity
            ? settings.arguments as LessonEntity
            : LessonModel.emptyLesson();
        return MaterialPageRoute(
          builder: (context) => LessonDetailsScreen(data: entity),
        );

      case NavigationRouteNames.bellDetailsScreen:
        final entity = settings.arguments is SchoolBellEntity
            ? settings.arguments as SchoolBellEntity
            : SchoolBellModel.emptyBell();
        return MaterialPageRoute(
          builder: (context) => BellDetailsScreen(data: entity),
        );

      default:
        const widget = Scaffold(body: Center(child: Text('Error')));
        return MaterialPageRoute(builder: (context) => widget);
    }
  }
}

class NavigationActions {
  static const instance = NavigationActions._();
  const NavigationActions._();
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // на попередню сторінку
  void returnToPreviousPage() {
    navigatorKey.currentState?.pop();
  }

  // функцією користуємося ліше після авторизації
  void showMainScreen() {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
        NavigationRouteNames.mainScreen, (route) => false);
  }

  void onUserDetails() {
    navigatorKey.currentState
        ?.pushNamed(NavigationRouteNames.userDetailsScreen);
  }

  void showLessonsScreen() {
    navigatorKey.currentState?.pushNamed(NavigationRouteNames.lessonsScreen);
  }

  void showBellsScreen() {
    navigatorKey.currentState?.pushNamed(NavigationRouteNames.bellsScreen);
  }

  void showLessonDetailsScreen(LessonEntity data) {
    navigatorKey.currentState
        ?.pushNamed(NavigationRouteNames.lessonDetailsScreen, arguments: data);
  }

  void showBellDetailsScreen(SchoolBellEntity data) {
    navigatorKey.currentState
        ?.pushNamed(NavigationRouteNames.bellDetailsScreen, arguments: data);
  }

  void showWeekGridScreen() {
    navigatorKey.currentState?.pushNamed(NavigationRouteNames.weekGridScreen);
  }
}
