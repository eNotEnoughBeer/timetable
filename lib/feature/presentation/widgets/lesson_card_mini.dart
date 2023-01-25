import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timetable/core/app_colors.dart';
import 'package:timetable/feature/domain/entities/lesson_entity.dart';

class LessonCardMini extends StatelessWidget {
  final LessonEntity data;
  const LessonCardMini({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: lessonsBackground[data.iconIndex].withOpacity(0.7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Text(
                data.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: AppColors.lightTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width / 27),
              ),
            ),
          ),
          SizedBox(
            height: 70,
            width: 70,
            child: SvgPicture.asset(
              'assets/svg/${data.iconIndex + 1}.svg',
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
