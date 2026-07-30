import 'dart:io';

import 'package:arise/arise.dart' as arise;

Future<void> main(List<String> arguments) async {
  final exitCode = await arise.AriseCommandRunner().run(arguments);

  if (exitCode != null) {
    exit(exitCode);
  }
}
