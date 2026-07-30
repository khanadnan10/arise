import 'dart:io';

import 'package:args/command_runner.dart';

class CreateCommand extends Command<int> {
  CreateCommand() {
    argParser.addFlag(
      'skip',
      abbr: 's',
      help: 'Skip the interactive setup.',
      negatable: false,
    );
  }
  @override
  String get name => 'create';

  @override
  String get description => 'Create a new Flutter project.';

  @override
  Future<int> run() async {
    stdout.writeln('🚀 Welcome to Arise');
    stdout.writeln();

    String? projectName;

    if (argResults?['skip'] == true) {
      projectName = argResults?.rest.firstOrNull;
    } else {
      stdout.write('Project name: ');
      projectName = stdin.readLineSync()?.trim();
    }

    if (projectName == null || projectName.isEmpty) {
      stderr.writeln('❌ Project name cannot be empty.');
      return 1;
    }

    final projectDirectory = Directory(projectName);

    if (projectDirectory.existsSync()) {
      stderr.writeln('❌ Project "$projectName" already exists.');
      return 1;
    }

    stdout.writeln();
    stdout.writeln('Creating Flutter project...');

    final result = await Process.run('flutter', ['create', projectName]);

    stdout.write(result.stdout);
    stderr.write(result.stderr);

    return result.exitCode;
  }
}
