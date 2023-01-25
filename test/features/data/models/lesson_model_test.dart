import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetable/feature/data/models/lesson_model.dart';
import 'package:timetable/feature/domain/entities/lesson_entity.dart';

import '../../../json_data/json_reader.dart';

void main() {
  const tModel = LessonModel(
    uid: "test uid",
    name: "test name",
    description: "test description",
    googleKey: "test key",
    iconIndex: 1,
    teacherName: "test teacher name",
    teacherAvatar: "test avatar url",
  );
  test('should be a subclass of LessonEntity', () async {
    //
    expect(tModel, isA<LessonEntity>());
  });

  group('fromMap', () {
    test('should return a valid model', () {
      final Map<String, dynamic> jsonMap =
          json.decode(jsonReader('lesson_data.json'));
      final result = LessonModel.fromMap(jsonMap);
      expect(result, tModel);
    });
  });

  group('toMap', () {
    test('should return a json map from the class variables data', () {
      final Map<String, dynamic> jsonMap =
          json.decode(jsonReader('lesson_data.json'));
      final result = tModel.toMap();
      expect(result, jsonMap);
    });
  });
}
