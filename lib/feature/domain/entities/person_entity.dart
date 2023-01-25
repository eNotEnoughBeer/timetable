import 'package:equatable/equatable.dart';

class PersonEntity extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String role;
  final String avatar;

  const PersonEntity(
      {required this.uid,
      required this.name,
      required this.email,
      required this.role,
      required this.avatar});

  @override
  List<Object?> get props => [uid, name, email, role, avatar];

  @override
  String toString() {
    return 'PersonEntity {$uid,$name,$email,$role,$avatar}';
  }
}
