import 'package:timetable/feature/domain/entities/lesson_entity.dart';

class LessonModel extends LessonEntity {
  const LessonModel(
      {required super.uid,
      required super.name,
      required super.description,
      required super.iconIndex,
      required super.googleKey,
      required super.teacherName,
      required super.teacherAvatar});

  factory LessonModel.emptyLesson() => const LessonModel(
        uid: '',
        name: '',
        description: '',
        iconIndex: -1,
        googleKey: '',
        teacherName: '',
        teacherAvatar: '',
      );

  Map<String, dynamic> toMap() {
    return {
      'uid': super.uid,
      'name': super.name,
      'description': super.description,
      'icon_index': super.iconIndex,
      'google_key': super.googleKey,
      'teacher_name': super.teacherName,
      'teacher_avatar': super.teacherAvatar,
    };
  }

  factory LessonModel.fromMap(Map<String, dynamic> map) {
    return LessonModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      iconIndex: map['icon_index'] as int,
      googleKey: map['google_key'] as String,
      teacherName: map['teacher_name'] as String,
      teacherAvatar: map['teacher_avatar'] as String,
    );
  }

  LessonModel copyWith({
    String? uid,
    String? name,
    String? description,
    int? iconIndex,
    String? googleKey,
    String? teacherName,
    String? teacherAvatar,
  }) {
    return LessonModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      description: description ?? this.description,
      iconIndex: iconIndex ?? this.iconIndex,
      googleKey: googleKey ?? this.googleKey,
      teacherName: teacherName ?? this.teacherName,
      teacherAvatar: teacherAvatar ?? this.teacherAvatar,
    );
  }
}
