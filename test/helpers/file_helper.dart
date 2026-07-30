import 'dart:io';

Future<File> createFile(
  String path,
  String content,
) async {
  final file = File(path);

  await file.parent.create(recursive: true);

  return file.writeAsString(content);
}
