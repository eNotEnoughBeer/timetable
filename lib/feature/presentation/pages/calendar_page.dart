import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetable/core/app_colors.dart';

import '../../../core/calendar_abbr.dart';
import '../../domain/entities/lesson_entity.dart';
import '../../domain/entities/lesson_grid_entity.dart';
import '../../domain/entities/school_bell_entity.dart';
import '../bloc/schedule_grid/schedule_cubit.dart';
import '../widgets/empty_list_widget.dart';
import '../widgets/lesson_card.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  var listItems = <Widget>[];

  final today = DateTime.now();
  var selectedDay = 0;
  var weekDays = <int>[];

  @override
  void initState() {
    super.initState();
    selectedDay = today.day;
    for (int i = 1; i < 8; i++) {
      weekDays.add(today.add(Duration(days: i - today.weekday)).day);
    }
  }

  _loadData() {
    _clearAnimatedList();

    final fetchedList = _buildSelectedDayLessons(
        (context.read<ScheduleCubit>().state as Succeed).data!,
        context.read<ScheduleCubit>().bellsData!,
        context.read<ScheduleCubit>().lessonsData!);

    var future = Future(() {});
    for (var i = 0; i < fetchedList.length; i++) {
      future = future.then((_) {
        return Future.delayed(const Duration(milliseconds: 100), () {
          listItems.add(fetchedList[i]);
          _listKey.currentState?.insertItem(listItems.length - 1);
        });
      });
    }
  }

  void _clearAnimatedList() {
    for (var i = listItems.length - 1; i >= 0; i--) {
      final deletedItem = listItems.removeAt(0);
      _listKey.currentState
          ?.removeItem(0, duration: const Duration(milliseconds: 10),
              (BuildContext context, Animation<double> animation) {
        return SlideTransition(
          position: CurvedAnimation(
            curve: Curves.easeOut,
            parent: animation,
          ).drive((Tween<Offset>(
            begin: const Offset(1, 0),
            end: const Offset(0, 0),
          ))),
          child: deletedItem,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleCubit, ScheduleState>(builder: (context, state) {
      if (state is Succeed) {
        _loadData();
        return _bodyWidget();
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    });
  }

  Widget _bodyWidget() {
    return Stack(
      children: [
        // appbar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.topBackgroundColor.withOpacity(0.3),
                AppColors.lightTextColor,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.8],
            ),
          ),
          height: MediaQuery.of(context).size.height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: AppColors.buttonColor,
                  ),
                  const SizedBox(width: 15),
                  RichText(
                    text: TextSpan(
                      text: AppCalendar.month[today.month - 1],
                      style: const TextStyle(
                        color: AppColors.darkTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                      children: [
                        TextSpan(
                          text: ' ${today.year}',
                          style: const TextStyle(
                            color: AppColors.darkTextColor,
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDay = today.day;
                  });
                },
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.only(left: 10, bottom: 5, top: 5),
                  child: const Text(
                    'Сьогодні',
                    style: TextStyle(
                        color: AppColors.accentColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 100,
          child: Container(
            height: MediaQuery.of(context).size.height - 160,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: AppColors.lightTextColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 15, bottom: 15),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _buildWeekButtons(),
                  ),
                ),
                Expanded(
                  child: AnimatedList(
                    key: _listKey,
                    physics: const BouncingScrollPhysics(),
                    initialItemCount: listItems.length,
                    itemBuilder: (context, index, animation) {
                      return SlideTransition(
                        position: CurvedAnimation(
                          curve: Curves.easeOut,
                          parent: animation,
                        ).drive((Tween<Offset>(
                          begin: const Offset(1, 0),
                          end: const Offset(0, 0),
                        ))),
                        child: listItems[index],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildWeekButtons() => List<Widget>.generate(
      7,
      (index) => _buildDateColumn(AppCalendar.dayOfWeek[index], weekDays[index],
          weekDays[index] == selectedDay));

  List<Widget> _buildSelectedDayLessons(
    List<List<LessonGridEntity>> weekSchedule,
    List<SchoolBellEntity> bells,
    List<LessonEntity> lessons,
  ) {
    if (weekDays.indexOf(selectedDay) > 4) {
      // вихідні
      return List<Widget>.generate(
          1,
          (index) => SizedBox(
                height: MediaQuery.of(context).size.height - 250,
                child: const Center(
                  child: EmptyList(
                    labelText: 'Немає уроків',
                  ),
                ),
              ));
    }
    var result = <Widget>[];
    final curDay = weekSchedule[weekDays.indexOf(selectedDay)];
    for (int i = 0; i < curDay.length; i++) {
      if (curDay[i].lessonUid.isEmpty) continue;
      final st = bells[curDay[i].lessonIndex - 1].fromTime.split(':');
      final end = bells[curDay[i].lessonIndex - 1].toTime.split(':');

      final endT = DateTime(
          2000, 1, 1, int.tryParse(end[0]) ?? 0, int.tryParse(end[1]) ?? 10);
      final stT = DateTime(
          2000, 1, 1, int.tryParse(st[0]) ?? 0, int.tryParse(st[1]) ?? 0);

      final curLesson =
          lessons.firstWhere((element) => element.uid == curDay[i].lessonUid);

      result.add(LessonDataEx(
        startTime: bells[curDay[i].lessonIndex - 1].fromTime,
        durationTime: '${endT.difference(stT).inMinutes} хв',
        lessonEntity: curLesson,
      ));
    }
    return result;
  }

  Widget _buildDateColumn(String weekDay, int date, bool isActive) {
    final itemWidth = MediaQuery.of(context).size.width / 8;
    return GestureDetector(
      onTap: () {
        if (selectedDay == date) return;
        setState(() {
          selectedDay = date;
        });
      },
      child: Container(
        height: 60,
        width: itemWidth,
        decoration: isActive
            ? BoxDecoration(
                color: AppColors.buttonColor,
                borderRadius: BorderRadius.circular(10),
              )
            : const BoxDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              weekDay,
              style: TextStyle(
                color: isActive
                    ? AppColors.lightTextColor
                    : AppColors.greyTextColor,
                fontSize: 14,
              ),
            ),
            Text(
              '$date',
              style: TextStyle(
                color: isActive
                    ? AppColors.lightTextColor
                    : AppColors.darkTextColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LessonDataEx extends StatelessWidget {
  const LessonDataEx({
    Key? key,
    required this.startTime,
    required this.durationTime,
    required this.lessonEntity,
  }) : super(key: key);
  final String startTime;
  final String durationTime;
  final LessonEntity lessonEntity;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 15,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppColors.accentColor,
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(5),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              SizedBox(
                width: MediaQuery.of(context).size.width - 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      startTime,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.darkTextColor,
                      ),
                    ),
                    Text(
                      durationTime,
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: AppColors.greyTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 30, right: 10),
            child: LessonCard(data: lessonEntity),
          ),
        ],
      ),
    );
  }
}
