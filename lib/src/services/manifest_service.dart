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
      ..writeln(
        '# Arise project configuration — used by `arise gen`, `arise add`, '
        '`arise info`, and `arise doctor`.',
      )
      ..writeln('# Supported values are listed above each field.')
      ..writeln('version: ${manifest.version}')
      ..writeln()
      ..writeln('project:')
      ..writeln('  name: ${manifest.projectName}')
      ..writeln()
      ..writeln('# clean | mvvm | mvc | mvp | none')
      ..writeln('architecture: ${manifest.architecture}')
      ..writeln('# riverpod | provider | bloc | getx | none')
      ..writeln('state_management: ${manifest.stateManagement}')
      ..writeln('# go_router | auto_route | none')
      ..writeln('routing: ${manifest.routing}')
      ..writeln('# dio | none')
      ..writeln('networking: ${manifest.networking}')
      ..writeln('# get_it | injectable | none')
      ..writeln('dependency_injection: ${manifest.dependencyInjection}')
      ..writeln('# shared_preferences | none')
      ..writeln('storage: ${manifest.storage}')
      ..writeln('# very_good_analysis | none')
      ..writeln('lint: ${manifest.lint}');

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
      dependencyInjection: yaml['dependency_injection'] as String? ?? 'none',
      storage: yaml['storage'] as String? ?? 'none',
      lint: yaml['lint'] as String? ?? 'none',
    );
  }
}
