import 'package:equatable/equatable.dart';

class LessonEntity extends Equatable {
  final String uid;
  final String name;
  final String description;
  final int iconIndex;
  final String googleKey;
  final String teacherName;
  final String teacherAvatar;

  const LessonEntity({
    required this.uid,
    required this.name,
    required this.description,
    required this.iconIndex,
    required this.googleKey,
    required this.teacherName,
    required this.teacherAvatar,
  });

  @override
  String toString() {
    return 'LessonEntity {$uid,$name,$description,$iconIndex,$googleKey,$teacherName,$teacherAvatar}';
  }

  @override
  List<Object?> get props => [
        uid,
        name,
        description,
        iconIndex,
        googleKey,
        teacherName,
        teacherAvatar
      ];
}
