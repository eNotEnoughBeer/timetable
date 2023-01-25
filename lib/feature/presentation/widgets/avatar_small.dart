import 'package:flutter/material.dart';

class SmallAvatar extends StatelessWidget {
  final double diameter;
  final double borderSize;
  const SmallAvatar(
      {Key? key, required this.diameter, required this.borderSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        border: Border.all(width: borderSize, color: Colors.white),
        boxShadow: [
          BoxShadow(
            spreadRadius: 2,
            blurRadius: 4,
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 1),
          ),
        ],
        shape: BoxShape.circle,
        image: const DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/avatar.jpg'),
        ),
      ),
    );
  }
}
