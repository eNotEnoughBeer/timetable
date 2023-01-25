import 'package:timetable/feature/domain/entities/person_entity.dart';

class PersonModel extends PersonEntity {
  const PersonModel(
      {required super.uid,
      required super.name,
      required super.email,
      required super.role,
      required super.avatar});

  factory PersonModel.emptyPerson() => const PersonModel(
        uid: '',
        email: '',
        name: '',
        role: 'student',
        avatar: '',
      );

  // методи класу, які будуть збільшувіти функциіонал PersonEntity
  Map<String, dynamic> toMap() {
    return {
      'uid': super.uid,
      'name': super.name,
      'email': super.email,
      'role': super.role,
      'avatar': super.avatar,
    };
  }

  factory PersonModel.fromMap(Map<String, dynamic> map) {
    return PersonModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      role: map['role'] as String,
      avatar: map['avatar'] as String,
    );
  }

  PersonModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? role,
    String? avatar,
  }) {
    return PersonModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      avatar: avatar ?? this.avatar,
    );
  }
}
