import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:timetable/core/app_colors.dart';
import 'package:timetable/feature/domain/entities/lesson_entity.dart';
import 'package:timetable/feature/presentation/widgets/avatar_small.dart';

class LessonCard extends StatelessWidget {
  final LessonEntity data;
  const LessonCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double lessonNameFontSize =
        min(MediaQuery.of(context).size.width / 20, 30);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: lessonsBackground[data.iconIndex].withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            // загогулька темнішого кольору
            Positioned(
              bottom: 0,
              right: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: SvgPicture.asset(
                  'assets/svg/back.svg',
                  color: lessonsBackground[data.iconIndex],
                ),
              ),
            ),
            // гарненька піктограмка
            Positioned(
              bottom: 20,
              right: 0,
              width: 110,
              height: 110,
              child: SvgPicture.asset(
                'assets/svg/${data.iconIndex + 1}.svg',
                color: Colors.white,
              ),
            ),
            //google key
            Positioned(
              bottom: 5,
              right: 15,
              child: Row(
                children: [
                  const Icon(FontAwesome.key, color: Colors.white, size: 20),
                  const SizedBox(width: 5),
                  Text(
                    data.googleKey,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // вчитель
            Positioned(
              bottom: 5,
              left: 5,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Row(
                  children: [
                    const SmallAvatar(diameter: 30, borderSize: 1),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        data.teacherName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          color: AppColors.lightTextColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // назва предмету
            Positioned(
              top: 10,
              left: 10,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Text(
                  data.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                      color: AppColors.lightTextColor,
                      fontSize: lessonNameFontSize,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // коротенький опис предмету
            Positioned(
              top: 50,
              left: 10,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(
                  data.description,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                      color: AppColors.lightTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
