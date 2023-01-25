part of 'schedule_cubit.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object?> get props => [];
}

class InitialState extends ScheduleState {
  const InitialState();

  @override
  List<Object?> get props => [];
}

class InProgress extends ScheduleState {
  const InProgress();

  @override
  List<Object?> get props => [];
}

class Succeed extends ScheduleState {
  final List<List<LessonGridEntity>>? data;
  const Succeed({this.data});

  @override
  List<Object?> get props => [data];
}

class Failed extends ScheduleState {
  final String? message;
  const Failed({this.message});

  @override
  List<Object?> get props => [message];
}
