import 'package:equatable/equatable.dart';

class LessonGridEntity extends Equatable {
  final int dayIndex;
  final int lessonIndex;
  final String lessonUid;

  const LessonGridEntity(
      {required this.dayIndex,
      required this.lessonIndex,
      required this.lessonUid});

  @override
  String toString() {
    return 'LessonGridEntity {dayIndex: $dayIndex, lessonIndex: $lessonIndex, lessonUid: $lessonUid}';
  }

  @override
  // TODO: implement props
  List<Object?> get props => [dayIndex, lessonIndex, lessonUid];
}
