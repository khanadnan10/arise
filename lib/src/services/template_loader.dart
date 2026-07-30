import 'dart:io';

import 'package:yaml/yaml.dart';

import '../models/template_file.dart';
import '../models/template_hook.dart';
import '../models/template_module.dart';
import '../models/template_package.dart';

class TemplateLoader {
  Future<TemplateModule> load(String configPath) async {
    final file = File(configPath);

    if (!await file.exists()) {
      throw Exception('Template not found: $configPath');
    }

    final yaml = loadYaml(await file.readAsString());
    final templateDir = file.parent.path;

    return TemplateModule(
      name: yaml['name'] as String,
      category: yaml['category'] as String? ?? '',
      description: yaml['description'] as String?,
      version: yaml['version'] as String?,
      author: yaml['author'] as String?,
      folders: List<String>.from(yaml['folders'] ?? []),
      packages: _parsePackages(yaml['packages']),
      files: _parseFiles(yaml['files'], templateDir),
      requires: List<String>.from(yaml['requires'] ?? []),
      conflicts: List<String>.from(yaml['conflicts'] ?? []),
      variables: _parseVariables(yaml['variables']),
      hooks: _parseHooks(yaml['hooks']),
    );
  }

  List<TemplatePackage> _parsePackages(dynamic value) {
    if (value == null) return [];
    return (value as YamlList).map((e) {
      return TemplatePackage(
        name: e['name'] as String,
        dev: e['dev'] as bool? ?? false,
        version: e['version'] as String?,
      );
    }).toList();
  }

  List<TemplateFile> _parseFiles(dynamic value, String templateDir) {
    if (value == null) return [];
    return (value as YamlList).map((e) {
      return TemplateFile(
        sourcePath: '$templateDir/${e['from']}',
        to: e['to'] as String,
      );
    }).toList();
  }

  Map<String, String> _parseVariables(dynamic value) {
    if (value == null) return {};
    final map = value as YamlMap;
    return {
      for (final entry in map.entries)
        entry.key.toString(): entry.value.toString(),
    };
  }

  List<TemplateHook> _parseHooks(dynamic value) {
    if (value == null) return [];
    return (value as YamlList).map((e) {
      final phaseStr = e['phase'] as String;
      final phase = HookPhase.values.firstWhere(
        (p) => p.name == phaseStr,
        orElse: () => HookPhase.postGenerate,
      );
      final command = e['command'] as String;
      final args = List<String>.from(e['args'] ?? []);
      return TemplateHook(
        phase: phase,
        command: command,
        args: args,
      );
    }).toList();
  }
}
