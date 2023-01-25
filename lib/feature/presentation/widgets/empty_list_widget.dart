import 'package:flutter/material.dart';
import 'package:timetable/core/app_colors.dart';

class EmptyList extends StatelessWidget {
  final String labelText;
  const EmptyList({Key? key, required this.labelText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
            child: Image.asset(
              AppAssets.empty,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            labelText,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
