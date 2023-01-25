import 'package:flutter/material.dart';

abstract class NavigationRouteNames {
  static const mainScreen = '/';
  static const authScreen = '/login';
  static const userDetailsScreen = '/user';
  static const lessonsScreen = '/lessons';
  static const lessonDetailsScreen = '/lesson_details';
  static const bellsScreen = '/bells';
  static const bellDetailsScreen = '/bell_details';
  static const weekGridScreen = '/week_grid';
}

abstract class AppNavigation {
  String get initialRoute;
  Map<String, Widget Function(BuildContext context)> get routes;
  Route<Object> onGenerateRoute(RouteSettings settings);
}
