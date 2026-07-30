import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:arise/src/models/create_config.dart';
import '../../wizards/create_wizard.dart';

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
    stdout.writeln('> Welcome to Arise');
    stdout.writeln();

    CreateConfig config;

    config = await CreateWizard().run(
      skip: argResults?['skip'] == true,
      projectName: argResults?.rest.firstOrNull,
    );

    final projectName = config.projectName;

    if (_projectExists(projectName)) {
      stderr.writeln('❌ Project "$projectName" already exists.');
      return 1;
    }

    stdout.writeln();
    if (!await _isFlutterInstalled()) {
      stderr.writeln('❌ Flutter SDK not found.');
      stderr.writeln('Please install Flutter and add it to your PATH.');
      return 1;
    }

    stdout.writeln('Creating Flutter project...');
    stdout.writeln('Architecture: ${config.architecture.label}');
    stdout.writeln('State Management: ${config.stateManagement.label}');
    stdout.writeln('Routing: ${config.routing.label}');
    return _createFlutterProject(projectName);
  }

  Future<bool> _isFlutterInstalled() async {
    final result = await Process.run('flutter', ['--version']);
    return result.exitCode == 0;
  }

  bool _projectExists(String projectName) {
    return Directory(projectName).existsSync();
  }

  Future<int> _createFlutterProject(String projectName) async {
    final result = await Process.run('flutter', ['create', projectName]);

    stdout.write(result.stdout);
    stderr.write(result.stderr);

    return result.exitCode;
  }
}
