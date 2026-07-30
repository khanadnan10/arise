import 'dart:io';

import 'package:yaml/yaml.dart';

class ManifestService {
  Future<void> save({
    required String projectPath,
    required String architecture,
    required List<String> modules,
  }) async {
    final file = File('$projectPath/.arise.yaml');
    final buffer = StringBuffer()
      ..writeln('architecture: $architecture')
      ..writeln('modules:');

    for (final module in modules) {
      buffer.writeln('  - $module');
    }

    await file.writeAsString(buffer.toString());
  }

  Future<Map<String, dynamic>?> read(String projectPath) async {
    final file = File('$projectPath/.arise.yaml');
    if (!await file.exists()) return null;

    final content = await file.readAsString();
    final yaml = loadYaml(content);
    if (yaml is! YamlMap) return null;

    return {
      'architecture': yaml['architecture'] as String?,
      'modules': List<String>.from(yaml['modules'] ?? []),
    };
  }
}
