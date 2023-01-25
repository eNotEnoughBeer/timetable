import 'package:flutter/material.dart';
import 'package:timetable/core/app_colors.dart';

SnackBar errorSnackBar({required String message, int? durationInSeconds}) {
  return SnackBar(
    duration: Duration(seconds: durationInSeconds ?? 2),
    padding: const EdgeInsets.all(15.0),
    content: Text(
      message,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        fontFamily: 'Comfortaa',
        color: AppColors.darkTextColor,
      ),
    ),
    backgroundColor: AppColors.accentColor,
  );
}
