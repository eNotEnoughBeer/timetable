import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';

class LessonWidget extends StatelessWidget {
  const LessonWidget({
    Key? key,
    required this.startTime,
    required this.endTime,
    required this.lessonName,
    required this.gCode,
    required this.teacher,
    required this.teacherURL,
  }) : super(key: key);

  final String startTime;
  final String endTime;
  final String lessonName;
  final String gCode;
  final String teacher;
  final String teacherURL;

  @override
  Widget build(BuildContext context) {
    final cardHeight =
        max((MediaQuery.of(context).size.height - 530) / 2, 100.0);
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      padding: const EdgeInsets.all(8),
      height: cardHeight,
      decoration: BoxDecoration(
        color: AppColors.bottomBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                startTime,
                style: TextStyle(
                  color: AppColors.buttonColor,
                  fontWeight: FontWeight.bold,
                  fontSize: cardHeight / 7.5,
                ),
              ),
              const Text(
                '|',
                style: TextStyle(
                  color: AppColors.buttonColor,
                  fontSize: 12,
                ),
              ),
              Text(
                endTime,
                style: TextStyle(
                  color: AppColors.buttonColor,
                  fontWeight: FontWeight.bold,
                  fontSize: cardHeight / 7.5,
                ),
              ),
            ],
          ),
          Container(
            height: 100,
            width: 1,
            color: AppColors.buttonColor,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lessonName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.darkTextColor,
                    fontSize: cardHeight / 7.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.key_outlined,
                      color: AppColors.greyTextColor,
                      size: cardHeight / 5,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      gCode,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.greyTextColor,
                        fontSize: cardHeight / 8.5,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: teacherURL.isEmpty
                          ? const AssetImage(AppAssets.defaultAvatar)
                          : AssetImage(teacherURL),
                      radius: cardHeight / 10,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        teacher,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.greyTextColor,
                          fontSize: cardHeight / 8.5,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
