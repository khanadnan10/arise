import 'dart:io';

import 'package:test/test.dart';

import 'package:arise/src/services/template_loader.dart';
import 'package:arise/src/services/template_merger.dart';
import 'package:arise/src/services/template_service.dart';
import 'package:arise/src/utils/arise_paths.dart';

void main() {
  final combinations = [
    (
      name: 'clean + riverpod + go_router + dio',
      architecture: 'clean',
      stateManagement: 'riverpod',
      routing: 'go_router',
      networking: 'dio',
    ),
    (
      name: 'mvvm + provider + go_router + dio',
      architecture: 'mvvm',
      stateManagement: 'provider',
      routing: 'go_router',
      networking: 'dio',
    ),
    (
      name: 'mvc + bloc + auto_route + dio',
      architecture: 'mvc',
      stateManagement: 'bloc',
      routing: 'auto_route',
      networking: 'dio',
    ),
    (
      name: 'mvp + getx + go_router + dio',
      architecture: 'mvp',
      stateManagement: 'getx',
      routing: 'go_router',
      networking: 'dio',
    ),
  ];

  for (final combination in combinations) {
    test(
      combination.name,
      () async {
        final tempDirectory = await Directory.systemTemp.createTemp(
          'arise_modules_',
        );

        final projectName = '${combination.architecture}_module_test';
        final projectPath = '${tempDirectory.path}/$projectName';

        try {
          // 1. Create a real Flutter project.
          final createResult = await Process.run(
            'flutter',
            ['create', projectName],
            workingDirectory: tempDirectory.path,
          );

          expect(
            createResult.exitCode,
            0,
            reason: '${createResult.stdout}\n${createResult.stderr}',
          );

          // 2. Load all four modules and merge them.
          final loader = TemplateLoader();

          final modules = await Future.wait([
            loader.load(
              ArisePaths.architectureTemplate(combination.architecture),
            ),
            loader.load(
              ArisePaths.stateManagementTemplate(combination.stateManagement),
            ),
            loader.load(
              ArisePaths.routingTemplate(combination.routing),
            ),
            loader.load(
              ArisePaths.networkingTemplate(combination.networking),
            ),
          ]);

          final merged = TemplateMerger().merge(modules);

          // 3. Apply the merged template to the project.
          await TemplateService().generate(
            projectPath: projectPath,
            template: merged,
          );

          // 4. Install packages declared by the modules.
          final pubGet = await Process.run(
            'flutter',
            ['pub', 'get'],
            workingDirectory: projectPath,
          );

          expect(
            pubGet.exitCode,
            0,
            reason: '${pubGet.stdout}\n${pubGet.stderr}',
          );

          // 5. Verify the generated project is clean.
          final analyze = await Process.run(
            'flutter',
            ['analyze'],
            workingDirectory: projectPath,
          );

          expect(
            analyze.exitCode,
            0,
            reason: '${analyze.stdout}\n${analyze.stderr}',
          );

          // 6. Verify all tests pass.
          final flutterTest = await Process.run(
            'flutter',
            ['test'],
            workingDirectory: projectPath,
          );

          expect(
            flutterTest.exitCode,
            0,
            reason: '${flutterTest.stdout}\n${flutterTest.stderr}',
          );
        } finally {
          if (await tempDirectory.exists()) {
            await tempDirectory.delete(recursive: true);
          }
        }
      },
      timeout: const Timeout(Duration(minutes: 5)),
    );
  }
}
