import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timetable/core/error/constants.dart';
import 'package:timetable/feature/data/datasources/local_datasource.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockSharedPreferences;
  late LocalDataSourceImpl localDataSourceImpl;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    localDataSourceImpl = LocalDataSourceImpl(storage: mockSharedPreferences);
  });

  test('fromCache', () {
    const tSharedPrefsReturnString = 'test string from shared preferences';
    when(() => mockSharedPreferences.getString(any()))
        .thenReturn(tSharedPrefsReturnString);

    final result = localDataSourceImpl.fromCache();
    verify(() => mockSharedPreferences.getString(userCacheField));
    expect(result, tSharedPrefsReturnString);
  });

  test('toCache', () async {
    const tString = 'test string';
    final tResultFuture = Future.value(true);
    when(() => mockSharedPreferences.setString(any(), any()))
        .thenAnswer((_) => tResultFuture);

    final result = localDataSourceImpl.toCache(tString);
    verify(() => mockSharedPreferences.setString(userCacheField, tString));
    expect(result, tResultFuture);
  });
}
