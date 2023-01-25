import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:timetable/core/app_colors.dart';
import 'package:timetable/feature/domain/entities/school_bell_entity.dart';
import 'package:timetable/feature/presentation/bloc/bells/bells_cubit.dart';
import 'package:timetable/navigation.dart';

class BellDetailsScreen extends StatefulWidget {
  final SchoolBellEntity data;
  const BellDetailsScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<BellDetailsScreen> createState() => _BellDetailsScreenState();
}

class _BellDetailsScreenState extends State<BellDetailsScreen> {
  int curLesson = 0;
  int startHour = 0;
  int startMinute = 0;
  int endHour = 0;
  int endMinute = 0;

  @override
  void initState() {
    super.initState();
    curLesson = widget.data.lessonNumber;
    if (widget.data.fromTime.isNotEmpty) {
      final res = widget.data.fromTime.split(':');
      startHour = int.tryParse(res[0]) ?? 0;
      startMinute = int.tryParse(res[1]) ?? 0;
    }
    if (widget.data.toTime.isNotEmpty) {
      final res = widget.data.toTime.split(':');
      endHour = int.tryParse(res[0]) ?? 0;
      endMinute = int.tryParse(res[1]) ?? 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bottomBackgroundColor,
      appBar: AppBar(
        actions: [
          IconButton(
            splashRadius: 20,
            onPressed: () async {
              final resEnt = SchoolBellEntity(
                uid: widget.data.uid,
                lessonNumber: curLesson,
                fromTime:
                    '${startHour.toString().padLeft(2, '0')}:${startMinute.toString().padLeft(2, '0')}',
                toTime:
                    '${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}',
              );

              if (widget.data.uid.isEmpty) {
                context.read<BellsCubit>().addBell(resEnt).then((res) {
                  if (res) {
                    context.read<BellsCubit>().getBells().then((value) =>
                        NavigationActions.instance.returnToPreviousPage());
                  }
                });
              } else {
                context.read<BellsCubit>().updateBell(resEnt).then((_) =>
                    context.read<BellsCubit>().getBells().then((_) =>
                        NavigationActions.instance.returnToPreviousPage()));
              }
            },
            icon:
                const Icon(FontAwesome.floppy, color: AppColors.darkTextColor),
          )
        ],
        backgroundColor: AppColors.bottomBackgroundColor,
        elevation: 0,
        title: Text(
          widget.data.uid.isEmpty ? 'Новий урок' : 'Редагування часу',
          style: const TextStyle(
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
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.bottomBackgroundColor.withAlpha(155),
                      AppColors.greyTextColor.withOpacity(0.2),
                    ],
                    stops: const [0.0, 1],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(width: 2, color: AppColors.greyTextColor),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Номер уроку',
                        style: TextStyle(
                          color: AppColors.buttonColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: widget.data.uid.isEmpty
                          ? NumberPicker(
                              value: curLesson,
                              zeroPad: true,
                              minValue: 1,
                              maxValue: 10,
                              step: 1,
                              itemHeight: 50,
                              textStyle: const TextStyle(
                                  color: AppColors.greyTextColor, fontSize: 16),
                              selectedTextStyle: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                              axis: Axis.vertical,
                              onChanged: (value) =>
                                  setState(() => curLesson = value),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    width: 2, color: AppColors.buttonColor),
                              ),
                            )
                          : Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.lightTextColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      width: 2, color: AppColors.buttonColor),
                                ),
                                width: 40,
                                height: 40,
                                child: Center(
                                  child: Text(
                                    '${widget.data.lessonNumber}',
                                    style: const TextStyle(
                                        color: AppColors.greyTextColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // початок уроку
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.bottomBackgroundColor.withAlpha(155),
                      AppColors.greyTextColor.withOpacity(0.2),
                    ],
                    stops: const [0.0, 1],
                  ),
                  //color: AppColors.greyTextColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(width: 2, color: AppColors.greyTextColor),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Text(
                        'Початок уроку',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.buttonColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 50,
                          child: NumberPicker(
                            value: startHour,
                            zeroPad: true,
                            minValue: 0,
                            maxValue: 23,
                            step: 1,
                            itemHeight: 50,
                            textStyle: const TextStyle(
                                color: AppColors.greyTextColor, fontSize: 16),
                            selectedTextStyle: const TextStyle(
                                color: Colors.blue,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                            axis: Axis.vertical,
                            onChanged: (value) =>
                                setState(() => startHour = value),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  width: 2, color: AppColors.buttonColor),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            ':',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 50,
                          child: NumberPicker(
                            value: startMinute,
                            zeroPad: true,
                            minValue: 0,
                            maxValue: 59,
                            step: 5,
                            itemHeight: 50,
                            axis: Axis.vertical,
                            textStyle: const TextStyle(
                                color: AppColors.greyTextColor, fontSize: 16),
                            selectedTextStyle: const TextStyle(
                                color: Colors.blue,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                            onChanged: (value) =>
                                setState(() => startMinute = value),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  width: 2, color: AppColors.buttonColor),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // закінення уроку
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.bottomBackgroundColor.withAlpha(155),
                      AppColors.greyTextColor.withOpacity(0.2),
                    ],
                    stops: const [0.0, 1],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(width: 2, color: AppColors.greyTextColor),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Text(
                        'Закінчення уроку',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.buttonColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 50,
                          child: NumberPicker(
                            value: endHour,
                            zeroPad: true,
                            minValue: 0,
                            maxValue: 23,
                            step: 1,
                            itemHeight: 50,
                            textStyle: const TextStyle(
                                color: AppColors.greyTextColor, fontSize: 16),
                            selectedTextStyle: const TextStyle(
                                color: Colors.blue,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                            axis: Axis.vertical,
                            onChanged: (value) =>
                                setState(() => endHour = value),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  width: 2, color: AppColors.buttonColor),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            ':',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 50,
                          child: NumberPicker(
                            value: endMinute,
                            zeroPad: true,
                            minValue: 0,
                            maxValue: 59,
                            step: 5,
                            itemHeight: 50,
                            axis: Axis.vertical,
                            textStyle: const TextStyle(
                                color: AppColors.greyTextColor, fontSize: 16),
                            selectedTextStyle: const TextStyle(
                                color: Colors.blue,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                            onChanged: (value) =>
                                setState(() => endMinute = value),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  width: 2, color: AppColors.buttonColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
