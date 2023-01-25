import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:timetable/core/app_colors.dart';
import 'package:timetable/feature/data/models/lesson_model.dart';
import 'package:timetable/feature/domain/entities/lesson_entity.dart';
import 'package:timetable/feature/presentation/bloc/lessons/lessons_cubit.dart';
import 'package:timetable/feature/presentation/widgets/empty_list_widget.dart';
import 'package:timetable/feature/presentation/widgets/error_snackbar.dart';
import 'package:timetable/feature/presentation/widgets/lesson_card.dart';
import 'package:timetable/navigation.dart';

class LessonsScreen extends StatelessWidget {
  const LessonsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bottomBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.bottomBackgroundColor,
        elevation: 0,
        title: const Text(
          'Перелік уроків',
          style: TextStyle(
              color: AppColors.darkTextColor, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          splashRadius: 20,
          onPressed: NavigationActions.instance.returnToPreviousPage,
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.darkTextColor,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'lessons_add',
        backgroundColor: AppColors.buttonColor,
        onPressed: () {
          NavigationActions.instance
              .showLessonDetailsScreen(LessonModel.emptyLesson());
        },
        child: const Icon(Icons.add, color: AppColors.lightTextColor),
      ),
      body: BlocConsumer<LessonsCubit, LessonState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) {
          if (state is Failed) {
            if (state.message != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                errorSnackBar(message: state.message!),
              );
            }
          }
        },
        builder: ((context, state) {
          if (state is Succeed) {
            return _bodyWidget(context, state.data);
          }

          return const Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }

  Widget _bodyWidget(BuildContext context, List<LessonEntity>? data) {
    if (data == null || data.isEmpty) {
      return const EmptyList(
        labelText: 'Немає уроків',
      );
    } else {
      return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: Key(data[index].uid),
              onDismissed: (direction) async {
                await context.read<LessonsCubit>().delLesson(data[index]);
              },
              background: Container(
                color: Colors.red,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                alignment: Alignment.centerRight,
                child: const Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: Icon(
                    FontAwesome.trash,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
              ),
              direction: DismissDirection.endToStart,
              child: GestureDetector(
                onTap: () {
                  NavigationActions.instance
                      .showLessonDetailsScreen(data[index]);
                },
                child: LessonCard(data: data[index]),
              ),
            );
          });
    }
  }
}
