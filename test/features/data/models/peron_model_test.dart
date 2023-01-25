import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetable/feature/data/models/peron_model.dart';
import 'package:timetable/feature/domain/entities/person_entity.dart';

import '../../../json_data/json_reader.dart';

void main() {
  const tModel = PersonModel(
    uid: "test uid",
    name: "test name",
    email: "test email",
    role: "test role",
    avatar: "test avatar url",
  );
  test('should be a subclass of PersonEntity', () async {
    //
    expect(tModel, isA<PersonEntity>());
  });

  group('fromMap', () {
    test('should return a valid model', () {
      final Map<String, dynamic> jsonMap =
          json.decode(jsonReader('person_data.json'));
      final result = PersonModel.fromMap(jsonMap);
      expect(result, tModel);
    });
  });

  group('toMap', () {
    test('should return a json map from the class variables data', () {
      final Map<String, dynamic> jsonMap =
          json.decode(jsonReader('person_data.json'));
      final result = tModel.toMap();
      expect(result, jsonMap);
    });
  });
}
