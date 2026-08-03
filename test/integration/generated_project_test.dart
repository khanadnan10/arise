import 'dart:io';

import 'package:test/test.dart';

import 'package:arise/src/services/template_loader.dart';
import 'package:arise/src/services/template_merger.dart';
import 'package:arise/src/services/template_service.dart';

void main() {
  test(
    'generated Flutter project passes analyze and test',
    () async {
      final tempDirectory = await Directory.systemTemp.createTemp(
        'arise_integration_',
      );

      final projectPath = '${tempDirectory.path}/test_app';

      try {
        // 1. Create a real Flutter project.
        final createResult = await Process.run(
          'flutter',
          ['create', 'test_app'],
          workingDirectory: tempDirectory.path,
        );

        expect(
          createResult.exitCode,
          0,
          reason: createResult.stderr.toString(),
        );

        // 2. Apply the Arise template engine.
        final module = await TemplateLoader().load(
          'templates/modules/architecture/clean/config.yaml',
        );

        final merged = TemplateMerger().merge([module]);

        await TemplateService().generate(
          projectPath: projectPath,
          template: merged,
        );

        // 3. Verify the generated project is clean.
        final analyzeResult = await Process.run(
          'flutter',
          ['analyze'],
          workingDirectory: projectPath,
        );

        expect(
          analyzeResult.exitCode,
          0,
          reason: '''
flutter analyze failed:

${analyzeResult.stdout}
${analyzeResult.stderr}
''',
        );

        // 4. Verify all tests pass.
        final testResult = await Process.run(
          'flutter',
          ['test'],
          workingDirectory: projectPath,
        );

        expect(
          testResult.exitCode,
          0,
          reason: '''
flutter test failed:

${testResult.stdout}
${testResult.stderr}
''',
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
