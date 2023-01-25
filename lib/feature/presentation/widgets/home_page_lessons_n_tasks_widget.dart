import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/app_colors.dart';
import '../bloc/schedule_grid/schedule_cubit.dart';
import 'empty_list_widget.dart';
import 'lesson_widget.dart';

class LessonsAndTasks extends StatefulWidget {
  const LessonsAndTasks({Key? key}) : super(key: key);

  @override
  State<LessonsAndTasks> createState() => _LessonsAndTasksState();
}

class _LessonsAndTasksState extends State<LessonsAndTasks> {
  var listItems = <Widget>[];
  var lessonsLeftForToday = 0;
  var showAllLessonsLeft = false;
  void showAll() {
    setState(() {
      showAllLessonsLeft = !showAllLessonsLeft;
      _updateData();
    });
  }

  void _updateData() {
    // заповнити listItems віджетами LessonWidget
    // - від поточного часу до кінця дня, якщо showAllLessonsLeft == true
    // - від поточного часу максимум 2 шт, якщо showAllLessonsLeft == false
    // - якщо listItems лишається порожнім, всунути у нього EmptyList
    final schedule = (context.read<ScheduleCubit>().state as Succeed).data!;
    final bells = context.read<ScheduleCubit>().bellsData!;
    final lessons = context.read<ScheduleCubit>().lessonsData!;

    listItems.clear();
    lessonsLeftForToday = 0;
    final curDateTime = DateTime.now();
    final double curTimeInDEX = curDateTime.hour + curDateTime.minute / 60;

    if (curDateTime.weekday < 6) {
      final curDay = schedule[curDateTime.weekday - 1];
      for (int i = 0; i < curDay.length; i++) {
        if (curDay[i].lessonUid.isEmpty) continue; // дірка в розкладі

        final end = bells[curDay[i].lessonIndex - 1].toTime.split(':');
        final double lessonEndTime = (int.tryParse(end[0]) ?? 0) * 1.0 +
            ((int.tryParse(end[1]) ?? 1) / 60.0);
        // урок вже закінчився
        if (curTimeInDEX > lessonEndTime) continue;

        // якщо згорнутий режим, треба лише дві позиції
        lessonsLeftForToday++;
        if (listItems.length == 2 && !showAllLessonsLeft) continue;

        final curLesson =
            lessons.firstWhere((element) => element.uid == curDay[i].lessonUid);
        listItems.add(
          LessonWidget(
            startTime: bells[curDay[i].lessonIndex - 1].fromTime,
            endTime: bells[curDay[i].lessonIndex - 1].toTime,
            gCode: curLesson.googleKey,
            lessonName: curLesson.name,
            teacher: curLesson.teacherName,
            teacherURL: curLesson.teacherAvatar,
          ),
        );
      }
    }

    if (listItems.isEmpty) {
      listItems.add(const Center(child: EmptyList(labelText: 'Немає уроків')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleCubit, ScheduleState>(builder: (context, state) {
      if (state is Succeed) {
        _updateData();
        return _bodyWidget();
      } else {
        return _loadingModeWidget(context);
      }
    });
  }

  Widget _loadingModeWidget(context) {
    final maxWidth = min(
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height,
        ) -
        20;
    return SingleChildScrollView(
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade400,
        highlightColor: Colors.grey.shade200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: maxWidth / 2,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.loadingWidgetColor,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: maxWidth * 0.95,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.loadingWidgetColor,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: maxWidth * 0.95,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.loadingWidgetColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bodyWidget() {
    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        _buildTitleRow('РОЗКЛАД НА СЬОГОДНІ ', lessonsLeftForToday, true),
        const SizedBox(height: 10),
        SizedBox(
          child: Column(
            children: listItems,
          ),
        ),
        Visibility(
          visible: !showAllLessonsLeft,
          child: Column(
            children: [
              const SizedBox(height: 25),
              _buildTitleRow('ПОЗАКЛАСНЕ ЖИТТЯ ', 99, false),
              const SizedBox(height: 15),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      TasksWidget(
                        backgroundColor: Colors.pink,
                        daysLeft: 3,
                        taskTitle:
                            'Название предмета или какое-то другое задание',
                      ),
                      TasksWidget(
                        backgroundColor: Colors.green,
                        daysLeft: 10,
                        taskTitle: 'Вынести мусор',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row _buildTitleRow(String title, int numberClasses, bool showSeeAll) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            text: title,
            style: const TextStyle(
              color: AppColors.darkTextColor,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: '($numberClasses)',
                style: const TextStyle(
                  color: AppColors.greyTextColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: showSeeAll,
          child: GestureDetector(
            onTap: showAll,
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.only(left: 10, bottom: 10),
              child: Text(
                showAllLessonsLeft ? 'Згорнути' : 'Розгорнути',
                style: const TextStyle(
                  color: AppColors.accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TasksWidget extends StatelessWidget {
  const TasksWidget({
    Key? key,
    required this.daysLeft,
    required this.taskTitle,
    required this.backgroundColor,
  }) : super(key: key);

  final int daysLeft;
  final String taskTitle;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 5, left: 5),
      padding: const EdgeInsets.all(12),
      height: 140,
      width: 140,
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Срок сдачи',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 5),
              Text(
                '$daysLeft days left',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 100,
            child: Text(
              taskTitle,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
