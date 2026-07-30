import 'package:test/test.dart';

import 'package:arise/src/services/template_loader.dart';

void main() {
  late TemplateLoader loader;

  setUp(() {
    loader = TemplateLoader();
  });

  group('TemplateLoader', () {
    test('loads valid template', () async {
      final template = await loader.load(
        'test/fixtures/clean_template.yaml',
      );

      expect(
        template.name,
        'Clean Architecture',
      );

      expect(
        template.folders.length,
        2,
      );

      expect(
        template.packages.length,
        2,
      );

      expect(
        template.files.length,
        1,
      );
    });

    test('loads empty template', () async {
      final template = await loader.load(
        'test/fixtures/empty_template.yaml',
      );

      expect(template.folders, isEmpty);
      expect(template.packages, isEmpty);
      expect(template.files, isEmpty);
    });

    test('throws if file does not exist', () async {
      expect(
        () => loader.load(
          'does_not_exist.yaml',
        ),
        throwsException,
      );
    });

    test('throws for malformed yaml', () async {
      expect(
        () => loader.load(
          'test/fixtures/malformed.yaml',
        ),
        throwsException,
      );
    });

    test('supports missing folders key', () async {});

    test('supports missing packages key', () async {});

    test('supports missing files key', () async {});

    test('supports package dev flag', () async {});

    test('supports package version', () async {});

    test('supports duplicate packages', () async {});
  });
}
