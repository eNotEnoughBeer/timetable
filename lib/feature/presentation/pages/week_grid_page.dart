import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttericon/font_awesome_icons.dart';

import '../../../core/app_colors.dart';
import '../../../core/calendar_abbr.dart';
import '../../../navigation.dart';
import '../../domain/entities/lesson_entity.dart';
import '../../domain/entities/lesson_grid_entity.dart';
import '../../domain/entities/school_bell_entity.dart';
import '../bloc/schedule_grid/schedule_cubit.dart';
import '../widgets/error_snackbar.dart';
import '../widgets/lesson_card_mini.dart';

class WeekGridPage extends StatefulWidget {
  const WeekGridPage({Key? key}) : super(key: key);

  @override
  State<WeekGridPage> createState() => _WeekGridPageState();
}

class _WeekGridPageState extends State<WeekGridPage> {
  List<List<LessonGridEntity>> gridData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bottomBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.bottomBackgroundColor,
        elevation: 0,
        title: const Text(
          'Розклад',
          style: TextStyle(
              color: AppColors.darkTextColor, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          splashRadius: 20,
          onPressed: NavigationActions.instance.returnToPreviousPage,
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.darkTextColor,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            splashRadius: 20,
            onPressed: () async {
              context.read<ScheduleCubit>().saveSchedule(gridData);
            },
            icon:
                const Icon(FontAwesome.floppy, color: AppColors.darkTextColor),
          )
        ],
      ),
      body: BlocConsumer<ScheduleCubit, ScheduleState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) {
          if (state is Failed) {
            if (state.message != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                errorSnackBar(message: state.message!),
              );
            }
          }
        },
        builder: ((context, state) {
          if (state is Succeed) {
            if (gridData.isEmpty) {
              gridData = state.data!;
            }
            return _bodyWidget(
              grid: gridData,
              bellsData: context.read<ScheduleCubit>().bellsData,
              lessonsData: context.read<ScheduleCubit>().lessonsData,
            );
          }

          return const Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }

  Widget _bodyWidget({
    List<List<LessonGridEntity>>? grid,
    List<SchoolBellEntity>? bellsData,
    List<LessonEntity>? lessonsData,
  }) {
    const pageHorizontalPadding = 10.0;
    final elementWidth =
        (MediaQuery.of(context).size.width - 2 * pageHorizontalPadding) / 6;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
          horizontal: pageHorizontalPadding, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ringCards(elementWidth, bellsData),
          _dayOfWeek(elementWidth, 1, lessonsData, grid![0]),
          _dayOfWeek(elementWidth, 2, lessonsData, grid[1]),
          _dayOfWeek(elementWidth, 3, lessonsData, grid[2]),
          _dayOfWeek(elementWidth, 4, lessonsData, grid[3]),
          _dayOfWeek(elementWidth, 5, lessonsData, grid[4]),
        ],
      ),
    );
  }

  Widget _ringCards(double elementWidth, List<SchoolBellEntity>? bellsList) {
    return Column(
      children: [
        Container(
          color: AppColors.bottomBackgroundColor,
          width: elementWidth,
          height: elementWidth / 2,
        ),
        ..._listBells(elementWidth, bellsList),
      ],
    );
  }

  List<Widget> _listBells(
      double elementWidth, List<SchoolBellEntity>? bellsList) {
    if (bellsList == null) return <Widget>[];
    final res = List<Widget>.generate(
        bellsList.length,
        (index) => SizedBox(
              width: elementWidth,
              height: elementWidth * 1.4,
              child: Container(
                margin: const EdgeInsets.only(left: 2, bottom: 2),
                color: AppColors.bottomBackgroundColor,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        bellsList[index].fromTime,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: elementWidth / 4,
                          color: AppColors.darkTextColor,
                        ),
                      ),
                      Text(
                        bellsList[index].lessonNumber.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: elementWidth / 2.5,
                          color: AppColors.darkTextColor,
                        ),
                      ),
                      Text(
                        bellsList[index].toTime,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: elementWidth / 4,
                          color: AppColors.darkTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
    return res;
  }

  Widget _dayOfWeek(double elementWidth, int i, List<LessonEntity>? lessonsList,
      List<LessonGridEntity> lessonsOfDay) {
    return Column(
      children: [
        SizedBox(
          width: elementWidth,
          height: elementWidth / 2,
          child: Container(
            margin: const EdgeInsets.only(left: 2, bottom: 2),
            decoration: BoxDecoration(
              color: AppColors.lightTextColor,
              borderRadius: i == 1
                  ? const BorderRadius.only(topLeft: Radius.circular(10))
                  : i == 5
                      ? const BorderRadius.only(topRight: Radius.circular(10))
                      : null,
            ),
            child: Center(
              child: Text(
                AppCalendar.dayOfWeek[i - 1],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: elementWidth / 3,
                  color: AppColors.darkTextColor,
                ),
              ),
            ),
          ),
        ),
        ..._listLessonsForDay(elementWidth, lessonsOfDay, lessonsList),
      ],
    );
  }

  List<Widget> _listLessonsForDay(
    double elementWidth,
    List<LessonGridEntity> lessonsForDay,
    List<LessonEntity>? lessonsListTotal,
  ) {
    final res = List<Widget>.generate(
      lessonsForDay.length,
      (index) => SizedBox(
        width: elementWidth,
        height: elementWidth * 1.4,
        child: Container(
          margin: const EdgeInsets.only(left: 2, bottom: 2),
          child: InkWell(
            onLongPress: () async {
              //TODO: диаложек с подтверждением удаление и сброс урока в пустой,
              // если в диаложке согласились
              setState(() {
                int d = 0;
                int l = 0;
                gridData = gridData.map((day) {
                  d++;
                  if (d == lessonsForDay[index].dayIndex) {
                    return day.map((lesson) {
                      l++;
                      if (l == lessonsForDay[index].lessonIndex) {
                        return LessonGridEntity(
                            dayIndex: lesson.dayIndex,
                            lessonIndex: lesson.lessonIndex,
                            lessonUid: '');
                      } else {
                        return lesson;
                      }
                    }).toList();
                  } else {
                    return day;
                  }
                }).toList();
              });
            },
            onTap: () async {
              final res = await _selectLesson(context, lessonsListTotal);
              if (res != null) {
                setState(() {
                  int d = 0;
                  int l = 0;
                  gridData = gridData.map((day) {
                    d++;
                    if (d == lessonsForDay[index].dayIndex) {
                      return day.map((lesson) {
                        l++;
                        if (l == lessonsForDay[index].lessonIndex) {
                          return LessonGridEntity(
                              dayIndex: lesson.dayIndex,
                              lessonIndex: lesson.lessonIndex,
                              lessonUid: res as String);
                        } else {
                          return lesson;
                        }
                      }).toList();
                    } else {
                      return day;
                    }
                  }).toList();
                });
              }
            },
            splashColor: AppColors.accentColor.withOpacity(0.7),
            child: Ink(
              color: AppColors.greyTextColor,
              child: Column(
                children: [
                  _drawLessonCard(elementWidth - 2,
                      lessonsForDay[index].lessonUid, lessonsListTotal),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    return res;
  }

  Widget _drawLessonCard(
    double cardWidth,
    String lessonUid,
    List<LessonEntity>? lessonsListTotal,
  ) {
    if (lessonUid.isEmpty) return const SizedBox.shrink();
    final lesson =
        lessonsListTotal?.firstWhere((element) => element.uid == lessonUid);
    if (lesson == null) return const SizedBox.shrink();
    return Container(
      width: cardWidth,
      height: cardWidth * 1.4,
      color: lessonsBackground[lesson.iconIndex].withOpacity(0.7),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Center(
              child: Text(
                lesson.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: cardWidth / 5, color: AppColors.lightTextColor),
              ),
            ),
          ),
          SizedBox(
            width: cardWidth - 6,
            height: cardWidth * 0.6,
            child: SvgPicture.asset(
              'assets/svg/${lesson.iconIndex + 1}.svg',
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> _selectLesson(
      BuildContext context, List<LessonEntity>? lessonsList) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Оберіть урок'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: lessonsList?.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context, lessonsList![index].uid);
                  },
                  child: LessonCardMini(data: lessonsList![index]),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
