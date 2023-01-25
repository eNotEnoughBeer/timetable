import 'package:timetable/feature/domain/entities/school_bell_entity.dart';

class SchoolBellModel extends SchoolBellEntity {
  const SchoolBellModel(
      {required super.uid,
      required super.lessonNumber,
      required super.fromTime,
      required super.toTime});

  factory SchoolBellModel.emptyBell() => const SchoolBellModel(
        uid: '',
        lessonNumber: 1,
        fromTime: '08:00',
        toTime: '08:45',
      );

  Map<String, dynamic> toMap() {
    return {
      'uid': super.uid,
      'lesson_number': super.lessonNumber,
      'from_time': super.fromTime,
      'to_time': super.toTime,
    };
  }

  factory SchoolBellModel.fromMap(Map<String, dynamic> map) {
    return SchoolBellModel(
      uid: map['uid'] as String,
      lessonNumber: map['lesson_number'] as int,
      fromTime: map['from_time'] as String,
      toTime: map['to_time'] as String,
    );
  }

  SchoolBellModel copyWith({
    String? uid,
    int? lessonNumber,
    String? fromTime,
    String? toTime,
  }) {
    return SchoolBellModel(
      uid: uid ?? this.uid,
      lessonNumber: lessonNumber ?? this.lessonNumber,
      fromTime: fromTime ?? this.fromTime,
      toTime: toTime ?? this.toTime,
    );
  }
}
