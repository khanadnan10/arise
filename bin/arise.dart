import 'dart:io';

import 'package:arise/arise.dart';

Future<void> main(List<String> arguments) async {
  final exitCode = await AriseCommandRunner().run(arguments);

  if (exitCode != null) {
    exit(exitCode);
  }
}
