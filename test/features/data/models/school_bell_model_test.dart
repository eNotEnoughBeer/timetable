import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetable/feature/data/models/school_bell_model.dart';
import 'package:timetable/feature/domain/entities/school_bell_entity.dart';

import '../../../json_data/json_reader.dart';

void main() {
  const tModel = SchoolBellModel(
    uid: "test uid",
    fromTime: "test from_time",
    toTime: "test to_time",
    lessonNumber: 1,
  );
  test('should be a subclass of SchoolBellEntity', () async {
    //
    expect(tModel, isA<SchoolBellEntity>());
  });

  group('fromMap', () {
    test('should return a valid model', () {
      final Map<String, dynamic> jsonMap =
          json.decode(jsonReader('school_bell_data.json'));
      final result = SchoolBellModel.fromMap(jsonMap);
      expect(result, tModel);
    });
  });

  group('toMap', () {
    test('should return a json map from the class variables data', () {
      final Map<String, dynamic> jsonMap =
          json.decode(jsonReader('school_bell_data.json'));
      final result = tModel.toMap();
      expect(result, jsonMap);
    });
  });
}
