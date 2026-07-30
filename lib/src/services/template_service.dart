import 'dart:io';

import '../models/architecture.dart';
import '../templates/main_template.dart';

class TemplateService {
  Future<void> generate({
    required String projectPath,
    required Architecture architecture,
  }) async {
    await _generateMainFile(projectPath);

    switch (architecture) {
      case Architecture.clean:
        await _generateClean(projectPath);
        break;

      case Architecture.mvvm:
        await _generateMvvm(projectPath);
        break;

      case Architecture.mvc:
        await _generateMvc(projectPath);
        break;

      case Architecture.none:
        break;
    }
  }

  Future<void> _generateClean(String path) async {
    final directories = [
      '$path/lib/core',
      '$path/lib/core/constants',
      '$path/lib/core/network',
      '$path/lib/core/theme',
      '$path/lib/core/utils',

      '$path/lib/features',

      '$path/lib/shared',
      '$path/lib/shared/widgets',
    ];

    await _createDirectories(directories);
  }

  Future<void> _generateMvvm(String path) async {
    final directories = [
      '$path/lib/core',
      '$path/lib/features',
      '$path/lib/shared',
    ];

    await _createDirectories(directories);
  }

  Future<void> _generateMvc(String path) async {
    final directories = [
      '$path/lib/controllers',
      '$path/lib/models',
      '$path/lib/views',
    ];

    await _createDirectories(directories);
  }

  Future<void> _createDirectories(List<String> directories) async {
    for (final directory in directories) {
      await Directory(directory).create(recursive: true);
    }
  }
  Future<void> _generateMainFile(String projectPath) async {
    final file = File('$projectPath/lib/main.dart');

    await file.writeAsString(
      MainTemplate.build(),
    );
  }
}
