import 'dart:io';

import '../models/merged_template.dart';
import '../utils/directory_copy.dart';

class TemplateService {
  Future<void> generate({
    required String projectPath,
    required MergedTemplate template,
    Map<String, String> customVariables = const {},
  }) async {
    final projectName = Directory(
      projectPath,
    ).uri.pathSegments.where((s) => s.isNotEmpty).last;

    final allVariables = {
      'project_name': projectName,
      'app_name': projectName,
      ...template.variables,
      ...customVariables,
    };

    await _createFolders(projectPath, template.folders);

    for (final templateDir in template.templateDirectories) {
      await _copyTemplateDirectory(projectPath, templateDir, allVariables);
    }
  }

  Future<void> _createFolders(String projectPath, List<String> folders) async {
    for (final folder in folders) {
      await Directory('$projectPath/$folder').create(recursive: true);
    }
  }

  Future<void> _copyTemplateDirectory(
    String projectPath,
    String templateDir,
    Map<String, String> variables,
  ) async {
    final source = Directory('$templateDir/files');

    if (!await source.exists()) {
      return;
    }

    await copyDirectory(source, Directory(projectPath), variables: variables);
  }
}
