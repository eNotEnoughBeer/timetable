import 'package:shared_preferences/shared_preferences.dart';
import 'package:timetable/core/error/constants.dart';

abstract class LocalDataSource {
  String fromCache();
  Future<bool> toCache(String password);
}

class LocalDataSourceImpl implements LocalDataSource {
  final SharedPreferences storage;
  LocalDataSourceImpl({required this.storage});

  /* @override
  Future<bool> clearCache() => storage.remove(userCacheField);*/

  @override
  String fromCache() => storage.getString(userCacheField) ?? '';

  @override
  Future<bool> toCache(String data) => storage.setString(userCacheField, data);
}
