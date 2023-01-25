import 'package:path_provider/path_provider.dart';

String temDirPath = '';

Future<void> getTempDir() async {
  final dir = await getTemporaryDirectory();
  temDirPath = dir.path;
}
