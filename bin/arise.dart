import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:arise/arise.dart';

Future<void> main(List<String> arguments) async {
  try {
    final exitCode = await AriseCommandRunner().run(arguments);
    exit(exitCode ?? 0);
  } on UsageException catch (error) {
    stderr.writeln(error);
    exit(64);
  }
}
