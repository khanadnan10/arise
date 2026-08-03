import 'dart:io';

import 'package:test/test.dart';

import 'package:arise/src/services/template_loader.dart';
import 'package:arise/src/services/template_merger.dart';
import 'package:arise/src/services/template_service.dart';
import 'package:arise/src/utils/arise_paths.dart';

void main() {
  test(
    'clean + riverpod + go_router + dio generates valid project',
    () async {
      final tempDirectory = await Directory.systemTemp.createTemp(
        'arise_modules_',
      );

      const projectName = 'module_test_app';
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
          reason: createResult.stderr.toString(),
        );

        // 2. Load all four modules and merge them.
        final loader = TemplateLoader();

        final modules = await Future.wait([
          loader.load(ArisePaths.architectureTemplate('clean')),
          loader.load(ArisePaths.stateManagementTemplate('riverpod')),
          loader.load(ArisePaths.routingTemplate('go_router')),
          loader.load(ArisePaths.networkingTemplate('dio')),
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
        final tests = await Process.run(
          'flutter',
          ['test'],
          workingDirectory: projectPath,
        );

        expect(
          tests.exitCode,
          0,
          reason: '${tests.stdout}\n${tests.stderr}',
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
