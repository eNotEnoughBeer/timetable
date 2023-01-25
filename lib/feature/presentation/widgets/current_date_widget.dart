import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/calendar_abbr.dart';

class CurrentDate extends StatelessWidget {
  const CurrentDate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    return Container(
      alignment: Alignment.centerRight,
      child: RichText(
        text: TextSpan(
          text: '${AppCalendar.dayOfWeek[today.weekday - 1]}, ',
          style: const TextStyle(
            color: AppColors.buttonColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          children: [
            TextSpan(
              text: '${today.day} ${AppCalendar.month[today.month - 1]}',
              style: const TextStyle(
                color: AppColors.buttonColor,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
