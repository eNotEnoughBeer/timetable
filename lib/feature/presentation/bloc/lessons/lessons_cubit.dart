import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../domain/entities/lesson_entity.dart';
import '../../../domain/usecases/lesson_add_usecase.dart';
import '../../../domain/usecases/lesson_delete_usecase.dart';
import '../../../domain/usecases/lesson_get_all_usecase.dart';
import '../../../domain/usecases/lesson_update_usecase.dart';

part 'lessons_state.dart';

class LessonsCubit extends Cubit<LessonState> {
  final AddLessonUsecase addLessonUsecase;
  final DeleteLessonUsecase deleteLessonUsecase;
  final UpdateLessonUsecase updateLessonUsecase;
  final GetLessonsUsecase getLessonsUsecase;

  LessonsCubit(
      {required this.addLessonUsecase,
      required this.deleteLessonUsecase,
      required this.updateLessonUsecase,
      required this.getLessonsUsecase})
      : super(const InitialState());

  Future<void> addLesson(LessonEntity lesson) async {
    emit(const InProgress());
    final failureOrData = await addLessonUsecase(lesson);
    failureOrData.fold((error) {
      emit(Failed(message: (error is ServerFailure) ? error.message : ''));
    }, (_) async {
      await getLessons();
    });
  }

  Future<void> delLesson(LessonEntity lesson) async {
    emit(const InProgress());
    final failureOrData = await deleteLessonUsecase(lesson);
    failureOrData.fold((error) {
      emit(Failed(message: (error is ServerFailure) ? error.message : ''));
    }, (_) async {
      await getLessons();
    });
  }

  Future<void> updateLesson(LessonEntity lesson) async {
    emit(const InProgress());
    final failureOrData = await updateLessonUsecase(lesson);
    failureOrData.fold((error) {
      emit(Failed(message: (error is ServerFailure) ? error.message : ''));
    }, (_) async {
      await getLessons();
    });
  }

  Future<void> getLessons() async {
    emit(const InProgress());
    final failureOrData = await getLessonsUsecase();
    failureOrData.fold((error) {
      emit(Failed(message: (error is ServerFailure) ? error.message : ''));
    }, (data) {
      emit(Succeed(data: data));
    });
  }
}
