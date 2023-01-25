import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:timetable/core/app_colors.dart';
import 'package:timetable/feature/domain/entities/school_bell_entity.dart';

class BellCard extends StatelessWidget {
  final SchoolBellEntity data;
  const BellCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: Container(
        height: 100,
        width: double.infinity,
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
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 2, color: AppColors.greyTextColor),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Text(
                  data.lessonNumber.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 65,
                      color: AppColors.buttonColor),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      const Icon(
                        FontAwesome.bell_alt,
                        color: AppColors.greyTextColor,
                        size: 25,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        data.fromTime,
                        style: const TextStyle(
                            fontSize: 25, color: AppColors.greyTextColor),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        FontAwesome.bell_off,
                        color: AppColors.greyTextColor,
                        size: 25,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        data.toTime,
                        style: const TextStyle(
                            fontSize: 25, color: AppColors.greyTextColor),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
