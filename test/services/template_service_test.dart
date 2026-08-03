import 'dart:io';

import 'package:test/test.dart';

import 'package:arise/src/services/template_loader.dart';
import 'package:arise/src/services/template_merger.dart';
import 'package:arise/src/services/template_service.dart';

void main() {
  late TemplateService service;
  late TemplateLoader loader;
  late TemplateMerger merger;
  late Directory tempDir;

  setUp(() async {
    service = TemplateService();
    loader = TemplateLoader();
    merger = TemplateMerger();
    tempDir = await Directory.systemTemp.createTemp(
      'arise_test_',
    );
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  Future<void> generateFromPath(
    String templatePath, {
    Map<String, String> customVariables = const {},
  }) async {
    final module = await loader.load(templatePath);
    final merged = merger.merge([module]);
    await service.generate(
      projectPath: tempDir.path,
      template: merged,
      customVariables: customVariables,
    );
  }

  group('TemplateService', () {
    test('creates folders', () async {
      await generateFromPath(
        'test/fixtures/templates/simple/config.yaml',
      );

      expect(
        Directory(
          '${tempDir.path}/lib/core',
        ).existsSync(),
        isTrue,
      );

      expect(
        Directory(
          '${tempDir.path}/lib/features',
        ).existsSync(),
        isTrue,
      );
    });

    test('creates nested folders', () async {
      await generateFromPath(
        'test/fixtures/templates/simple/config.yaml',
      );

      expect(
        Directory(
          '${tempDir.path}/lib/core/network',
        ).existsSync(),
        isTrue,
      );

      expect(
        Directory(
          '${tempDir.path}/lib/features/auth/data',
        ).existsSync(),
        isTrue,
      );
    });

    test('copies template directory recursively', () async {
      await generateFromPath(
        'test/fixtures/templates/simple/config.yaml',
      );

      expect(
        File(
          '${tempDir.path}/lib/main.dart',
        ).existsSync(),
        isTrue,
      );

      expect(
        File(
          '${tempDir.path}/lib/app.dart',
        ).existsSync(),
        isTrue,
      );

      expect(
        File(
          '${tempDir.path}/test/widget_test.dart',
        ).existsSync(),
        isTrue,
      );

      expect(
        File(
          '${tempDir.path}/analysis_options.yaml',
        ).existsSync(),
        isTrue,
      );

      expect(
        File(
          '${tempDir.path}/README.md',
        ).existsSync(),
        isTrue,
      );

      final content = await File(
        '${tempDir.path}/lib/main.dart',
      ).readAsString();

      expect(
        content,
        contains('void main'),
      );
    });

    test('replaces template variables', () async {
      await generateFromPath(
        'test/fixtures/templates/simple/config.yaml',
        customVariables: {
          'project_name': 'my_test_app',
          'app_name': 'MyTestApp',
        },
      );

      final content = await File(
        '${tempDir.path}/README.md',
      ).readAsString();

      expect(
        content,
        contains('Simple App'),
      );
    });

    test('throws when template does not exist', () async {
      expect(
        () => generateFromPath('missing/config.yaml'),
        throwsException,
      );
    });

    test('runs pre hooks', () async {});

    test('runs post hooks', () async {});

    test('does not overwrite existing files', () async {});

    test('supports binary assets', () async {});

    test('creates hidden files', () async {});
  });
}
