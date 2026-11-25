import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:arise/src/services/manifest_service.dart';

class InfoCommand extends Command<int> {
  @override
  String get name => 'info';

  @override
  String get description => 'Show configuration for the current Arise project.';

  @override
  Future<int> run() async {
    final projectPath = Directory.current.path;
    final manifest = await ManifestService().read(projectPath);

    if (manifest == null) {
      stderr.writeln('No Arise project found.');
      stderr.writeln(
        'Run this command from the root of a project created with Arise.',
      );
      return 1;
    }

    final featuresDir = Directory('$projectPath/lib/features');
    final features = <String>[];
    if (featuresDir.existsSync()) {
      features.addAll(
        featuresDir
            .listSync()
            .whereType<Directory>()
            .map((d) => d.uri.pathSegments.where((s) => s.isNotEmpty).last),
      );
      features.sort();
    }

    stdout.writeln('Arise Project Info');
    stdout.writeln('──────────────────');
    stdout.writeln('Project:              ${manifest.projectName}');
    stdout.writeln('Manifest version:     ${manifest.version}');
    stdout.writeln('Architecture:         ${manifest.architecture}');
    stdout.writeln('State Management:     ${manifest.stateManagement}');
    stdout.writeln('Routing:              ${manifest.routing}');
    stdout.writeln('Networking:           ${manifest.networking}');
    stdout.writeln('Dependency Injection: ${manifest.dependencyInjection}');
    stdout.writeln('Storage:              ${manifest.storage}');
    stdout.writeln('Lint:                 ${manifest.lint}');
    stdout.writeln(
      'Features (${features.length}):         '
      '${features.isEmpty ? '(none)' : features.join(', ')}',
    );

    return 0;
  }
}
