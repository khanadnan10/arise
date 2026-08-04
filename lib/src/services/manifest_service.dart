import 'dart:io';

import 'package:arise/src/models/project_manifest.dart';
import 'package:yaml/yaml.dart';

class ManifestService {
  Future<void> save({
    required String projectPath,
    required ProjectManifest manifest,
  }) async {
    final file = File('$projectPath/.arise.yaml');

    final buffer = StringBuffer()
      ..writeln('version: ${manifest.version}')
      ..writeln()
      ..writeln('project:')
      ..writeln('  name: ${manifest.projectName}')
      ..writeln()
      ..writeln('architecture: ${manifest.architecture}')
      ..writeln('state_management: ${manifest.stateManagement}')
      ..writeln('routing: ${manifest.routing}')
      ..writeln('networking: ${manifest.networking}');

    await file.writeAsString(buffer.toString());
  }

  Future<ProjectManifest?> read(String projectPath) async {
    final file = File('$projectPath/.arise.yaml');

    if (!await file.exists()) {
      return null;
    }

    final content = await file.readAsString();
    final yaml = loadYaml(content);

    if (yaml is! YamlMap) {
      return null;
    }

    final project = yaml['project'];

    if (project is! YamlMap) {
      return null;
    }

    return ProjectManifest(
      version: yaml['version'] as int? ?? 1,
      projectName: project['name'] as String? ?? '',
      architecture: yaml['architecture'] as String? ?? 'none',
      stateManagement: yaml['state_management'] as String? ?? 'none',
      routing: yaml['routing'] as String? ?? 'none',
      networking: yaml['networking'] as String? ?? 'none',
    );
  }
}
