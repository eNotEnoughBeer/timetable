part of 'lessons_cubit.dart';

abstract class LessonState extends Equatable {
  const LessonState();

  @override
  List<Object?> get props => [];
}

class InitialState extends LessonState {
  const InitialState();

  @override
  List<Object?> get props => [];
}

class InProgress extends LessonState {
  const InProgress();

  @override
  List<Object?> get props => [];
}

class Succeed extends LessonState {
  final List<LessonEntity>? data;
  const Succeed({this.data});

  @override
  List<Object?> get props => [data];
}

class Failed extends LessonState {
  final String? message;
  const Failed({this.message});

  @override
  List<Object?> get props => [message];
}
