import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetable/feature/data/models/lesson_grid_model.dart';
import 'package:timetable/feature/domain/entities/lesson_grid_entity.dart';

import '../../../json_data/json_reader.dart';

void main() {
  const tModel = LessonGridModel(
    lessonUid: 'test uid',
    lessonIndex: 1,
    dayIndex: 1,
  );
  test('should be a subclass of LessonGridEntity', () async {
    //
    expect(tModel, isA<LessonGridEntity>());
  });

  group('fromMap', () {
    test('should return a valid model', () {
      final Map<String, dynamic> jsonMap =
          json.decode(jsonReader('lesson_in_grid.json'));
      final result = LessonGridModel.fromMap(jsonMap);
      expect(result, tModel);
    });
  });

  group('toMap', () {
    test('should return a json map from the class variables data', () {
      final Map<String, dynamic> jsonMap =
          json.decode(jsonReader('lesson_in_grid.json'));
      final result = tModel.toMap();
      expect(result, jsonMap);
    });
  });
}
