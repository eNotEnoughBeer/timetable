import 'package:flutter/material.dart';
import 'package:timetable/navigation.dart';

import '../../../core/app_colors.dart';

class TeacherMenuPage extends StatelessWidget {
  const TeacherMenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.bottomBackgroundColor,
            AppColors.lightTextColor,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.7, 1.0],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 250,
              child: ElevatedButton(
                onPressed: NavigationActions.instance.showBellsScreen,
                child: const Text('Розклад дзвінків'),
              ),
            ),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                onPressed: NavigationActions.instance.showLessonsScreen,
                child: const Text('Перелік уроків'),
              ),
            ),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                onPressed: () =>
                    NavigationActions.instance.showWeekGridScreen(),
                child: const Text('Розклад на тиждень'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
