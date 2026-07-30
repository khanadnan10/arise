import 'dart:io';

import '../models/merged_template.dart';
import '../models/template_file.dart';

class TemplateService {
  Future<void> generate({
    required String projectPath,
    required MergedTemplate template,
    Map<String, String> customVariables = const {},
  }) async {
    final allVariables = {
      ...template.variables,
      ...customVariables,
    };

    await _createFolders(projectPath, template.folders);
    await _copyFiles(projectPath, template.files, allVariables);
  }

  Future<void> _createFolders(
    String projectPath,
    List<String> folders,
  ) async {
    for (final folder in folders) {
      await Directory('$projectPath/$folder').create(recursive: true);
    }
  }

  Future<void> _copyFiles(
    String projectPath,
    List<TemplateFile> files,
    Map<String, String> variables,
  ) async {
    for (final file in files) {
      final source = File(file.sourcePath);
      final destination = File('$projectPath/${file.to}');

      await destination.parent.create(recursive: true);
      var content = await source.readAsString();

      variables.forEach((key, value) {
        content = content.replaceAll('{{$key}}', value);
      });

      await destination.writeAsString(content);
    }
  }
}
