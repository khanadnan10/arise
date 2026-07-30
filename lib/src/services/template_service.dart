import 'dart:io';

import '../models/template_config.dart';
import 'template_loader.dart';

class TemplateService {
  final _loader = TemplateLoader();

  Future<void> generate({
    required String projectPath,
    required String templatePath,
  }) async {
    final config = await _loader.load(templatePath);

    await _createFolders(
      projectPath,
      config.folders,
    );

    await _copyFiles(
      projectPath,
      templatePath,
      config.files,
    );
  }

  Future<void> _createFolders(
    String projectPath,
    List<String> folders,
  ) async {
    for (final folder in folders) {
      await Directory('$projectPath/$folder').create(
        recursive: true,
      );
    }
  }

  Future<void> _copyFiles(
    String projectPath,
    String templatePath,
    List<TemplateFile> files,
  ) async {
    final templateDirectory = File(templatePath).parent.path;

    for (final file in files) {
      final source = File('$templateDirectory/${file.from}');
      final destination = File('$projectPath/${file.to}');

      await destination.parent.create(recursive: true);
      await destination.writeAsString(await source.readAsString());
    }
  }
}
