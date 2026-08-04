import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:arise/src/services/manifest_service.dart';
import 'package:arise/src/utils/feature_name.dart';

class FeatureCommand extends Command<int> {
  @override
  String get name => 'feature';

  @override
  String get description => 'Generate a feature.';

  @override
  Future<int> run() async {
    final arguments = argResults?.rest ?? [];

    if (arguments.isEmpty) {
      usageException('A feature name is required.');
    }

    final featureName = FeatureName.normalize(arguments.first);

    if (!FeatureName.isValid(featureName)) {
      stderr.writeln(
        'Invalid feature name "${arguments.first}". '
        'Use lowercase letters, numbers, underscores, or hyphens.',
      );
      return 64;
    }

    final projectPath = Directory.current.path;

    final manifest = await ManifestService().read(projectPath);

    if (manifest == null) {
      stderr.writeln('No Arise project found.');
      stderr.writeln(
        'Run this command from the root of a project created with Arise.',
      );
      return 1;
    }

    stdout.writeln(
      'Generating feature "$featureName" using ${manifest.architecture} architecture...',
    );

    return 0;
  }
}
