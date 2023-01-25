import 'package:timetable/feature/domain/entities/lesson_grid_entity.dart';

class LessonGridModel extends LessonGridEntity {
  const LessonGridModel(
      {required super.dayIndex,
      required super.lessonIndex,
      required super.lessonUid});

  factory LessonGridModel.emptyElement() => const LessonGridModel(
        dayIndex: 0,
        lessonIndex: 0,
        lessonUid: '',
      );

  Map<String, dynamic> toMap() {
    return {
      'day_index': super.dayIndex,
      'lesson_index': super.lessonIndex,
      'lesson_uid': super.lessonUid,
    };
  }

  factory LessonGridModel.fromMap(Map<String, dynamic> map) {
    return LessonGridModel(
      dayIndex: map['day_index'] as int,
      lessonIndex: map['lesson_index'] as int,
      lessonUid: map['lesson_uid'] as String,
    );
  }

  LessonGridModel copyWith({
    int? dayIndex,
    int? lessonIndex,
    String? lessonUid,
  }) {
    return LessonGridModel(
      dayIndex: dayIndex ?? this.dayIndex,
      lessonIndex: lessonIndex ?? this.lessonIndex,
      lessonUid: lessonUid ?? this.lessonUid,
    );
  }
}
