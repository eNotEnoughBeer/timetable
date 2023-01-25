import 'package:flutter/material.dart';
import 'package:timetable/core/app_colors.dart';

class SubmitButton extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final String label;
  final VoidCallback pressFunction;
  const SubmitButton(
      {Key? key,
      required this.icon,
      required this.backgroundColor,
      required this.foregroundColor,
      required this.label,
      required this.pressFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: pressFunction,
      style: TextButton.styleFrom(
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        side: backgroundColor != AppColors.buttonColor
            ? BorderSide(width: 1, color: foregroundColor)
            : null,
        minimumSize: const Size(155.0, 40.0),
      ),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 5),
          Text(label, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
