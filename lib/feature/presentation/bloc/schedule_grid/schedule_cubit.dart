import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/constants.dart';
import '../../../../core/error/failure.dart';
import '../../../domain/entities/lesson_entity.dart';
import '../../../domain/entities/lesson_grid_entity.dart';
import '../../../domain/entities/school_bell_entity.dart';
import '../../../domain/usecases/week_get_lessons_grid.dart';
import '../../../domain/usecases/week_set_lessons_grid.dart';
import '../bells/bells_cubit.dart' as bells;
import '../lessons/lessons_cubit.dart' as lessons;

part 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  static const key = '5V';
  final WeekGridLessonsGet lessonsGet;
  final WeekGridLessonsSet lessonsSet;

  final lessons.LessonsCubit lessonsCubit;
  final bells.BellsCubit bellsCubit;
  late StreamSubscription lessonsSubscription;
  late StreamSubscription bellsSubscription;

  List<LessonEntity>? lessonsData;
  List<SchoolBellEntity>? bellsData;

  ScheduleCubit(
      {required this.lessonsCubit,
      required this.bellsCubit,
      required this.lessonsGet,
      required this.lessonsSet})
      : super(const InitialState()) {
    lessonsSubscription = lessonsCubit.stream.listen((state) {
      if (state is lessons.Succeed) {
        lessonsData = state.data;
        if (bellsData != null) {
          getSchedule();
        }
      }
    });

    bellsSubscription = bellsCubit.stream.listen((state) {
      if (state is bells.Succeed) {
        bellsData = state.data;
        if (lessonsData != null) {
          getSchedule();
        }
      }
    });
  }

  @override
  Future<void> close() {
    lessonsSubscription.cancel();
    bellsSubscription.cancel();
    return super.close();
  }

  Future<void> getSchedule() async {
    emit(const InProgress());
    final failureOrData = await lessonsGet(key);
    failureOrData.fold((error) {
      if (error is CacheFailure) {
        final List<List<LessonGridEntity>> emptySchedule = List.generate(
            5,
            (index) => List.generate(
                bellsData!.length,
                (i) => LessonGridEntity(
                      dayIndex: index + 1,
                      lessonIndex: i + 1,
                      lessonUid: '',
                    )));
        emit(Succeed(data: emptySchedule));
      } else {
        emit(Failed(
            message: (error is ServerFailure) ? error.message : cUnknownError));
      }
    }, (data) {
      emit(Succeed(data: data));
    });
  }

  Future<void> saveSchedule(List<List<LessonGridEntity>> newData) async {
    emit(const InProgress());
    final failureOrData = await lessonsSet(key, newData);
    failureOrData.fold((error) {
      emit(Failed(
          message: (error is ServerFailure) ? error.message : cUnknownError));
    }, (data) {
      emit(Succeed(data: newData));
    });
  }
}
