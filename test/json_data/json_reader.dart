import 'dart:io';

String jsonReader(String fileName) =>
    File('test/json_data/$fileName').readAsStringSync();
