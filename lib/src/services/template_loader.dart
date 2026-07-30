import 'dart:io';

import 'package:yaml/yaml.dart';

import '../models/template_config.dart';

class TemplateLoader {
  Future<TemplateConfig> load(String path) async {
    final file = File(path);

    if (!await file.exists()) {
      throw Exception('Template not found: $path');
    }

    final yaml = loadYaml(await file.readAsString());

    return TemplateConfig(
      name: yaml['name'] as String,
      folders: List<String>.from(yaml['folders'] ?? []),
      dependencies: List<String>.from(yaml['dependencies'] ?? []),
      devDependencies: List<String>.from(yaml['dev_dependencies'] ?? []),
      files: (yaml['files'] as YamlList? ?? YamlList())
          .map(
            (e) => TemplateFile(
              from: e['from'] as String,
              to: e['to'] as String,
            ),
          )
          .toList(),
    );
  }
}
