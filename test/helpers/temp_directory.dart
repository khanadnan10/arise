import 'dart:io';

Future<Directory> createTempDirectory() {
  return Directory.systemTemp.createTemp('arise_test_');
}
