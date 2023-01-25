import 'package:flutter/material.dart';
import 'package:timetable/core/app_colors.dart';

import '../widgets/current_date_widget.dart';
import '../widgets/current_user_card.dart';
import '../widgets/home_page_lessons_n_tasks_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //top part
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.topBackgroundColor.withOpacity(0.3),
                AppColors.lightTextColor,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.2, 0.8],
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(
            children: const [
              CurrentDate(),
              SizedBox(height: 15),
              CurrentUserCard(),
            ],
          ),
        ),
        Positioned(
          top: 185,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
            height: MediaQuery.of(context).size.height - 230,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: AppColors.lightTextColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
            ),
            child: const LessonsAndTasks(),
          ),
        ),
      ],
    );
  }
}
