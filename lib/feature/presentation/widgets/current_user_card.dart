import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/app_colors.dart';
import '../../../core/platform/cache_folder_path.dart';
import '../../domain/entities/person_entity.dart';
import '../bloc/user_credentials/user_credentials_cubit.dart';

class CurrentUserCard extends StatelessWidget {
  const CurrentUserCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCredentialsCubit, UserCredentialsState>(
      builder: (context, state) {
        if (state is Succeed) {
          return _bodyWidget(context, state.personData);
        } else {
          return _loadingModeWidget(context);
        }
      },
    );
  }

  Widget _loadingModeWidget(BuildContext context) {
    final maxWidth = min(
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height,
        ) -
        100;
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.grey.shade200,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: AppColors.loadingWidgetColor,
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: maxWidth / 2,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.loadingWidgetColor,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: maxWidth * 0.8,
                height: 15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.loadingWidgetColor,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: maxWidth * 0.7,
                height: 15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.loadingWidgetColor,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _bodyWidget(BuildContext context, PersonEntity data) {
    final picturePath = '$temDirPath/avatar.jpg';
    var pictureExists = false;
    // перевірка чи наша це аватарка.
    // якщо data.avatar порожня, аватарка належить попередньому користувачу
    if (data.avatar.isNotEmpty) {
      if (File(picturePath).existsSync()) {
        pictureExists = true;
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(width: 2, color: Colors.white),
            boxShadow: [
              BoxShadow(
                  color: Colors.blueGrey.withOpacity(0.2),
                  blurRadius: 12,
                  spreadRadius: 8),
            ],
            image: DecorationImage(
              fit: BoxFit.cover,
              image: pictureExists
                  ? FileImage(File(picturePath)) as ImageProvider
                  : const AssetImage(AppAssets.defaultAvatar),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Привіт ${data.name}',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(
                color: AppColors.darkTextColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Ось твій розклад на сьогодні,',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                color: AppColors.buttonColor,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'якого слід дотримуватись...',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                color: AppColors.buttonColor,
                fontSize: 13,
              ),
            ),
          ],
        )
      ],
    );
  }
}
