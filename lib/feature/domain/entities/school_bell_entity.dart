import 'package:equatable/equatable.dart';

class SchoolBellEntity extends Equatable {
  final String uid;
  final int lessonNumber;
  final String fromTime;
  final String toTime;

  const SchoolBellEntity({
    required this.uid,
    required this.lessonNumber,
    required this.fromTime,
    required this.toTime,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [uid, lessonNumber, fromTime, toTime];

  @override
  String toString() {
    return 'SchoolBellEntity {iud: $uid, lesson: $lessonNumber, from: $fromTime, to: $toTime}';
  }
}
