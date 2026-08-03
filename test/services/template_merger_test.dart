import 'package:test/test.dart';

import 'package:arise/src/models/template_module.dart';
import 'package:arise/src/models/template_package.dart';
import 'package:arise/src/services/template_merger.dart';

void main() {
  late TemplateMerger merger;

  setUp(() {
    merger = TemplateMerger();
  });

  group('TemplateMerger', () {
    test('merges folders', () {
      final module = createModule(
        folders: [
          'lib/core',
          'lib/features',
        ],
      );

      final result = merger.merge([module]);

      expect(
        result.folders,
        containsAll([
          'lib/core',
          'lib/features',
        ]),
      );
    });

    test('removes duplicate folders', () {
      final module1 = createModule(
        folders: [
          'lib/core',
          'lib/features',
        ],
      );

      final module2 = createModule(
        folders: [
          'lib/core',
          'lib/shared',
        ],
      );

      final result = merger.merge([
        module1,
        module2,
      ]);

      expect(
        result.folders.length,
        3,
      );

      expect(
        result.folders,
        containsAll([
          'lib/core',
          'lib/features',
          'lib/shared',
        ]),
      );
    });

    test('merges packages', () {
      final module = createModule(
        packages: [
          pkg('dio'),
          pkg('flutter_riverpod'),
        ],
      );

      final result = merger.merge([module]);

      expect(
        result.packages.length,
        2,
      );
    });

    test('removes duplicate packages', () {
      final module1 = createModule(
        packages: [
          pkg('dio'),
          pkg('flutter_riverpod'),
        ],
      );

      final module2 = createModule(
        packages: [
          pkg('dio'),
          pkg('hive'),
        ],
      );

      final result = merger.merge([
        module1,
        module2,
      ]);

      expect(
        result.packages.length,
        3,
      );
    });

    test('merges template directories', () {
      final module = createModule(
        templateDir: 'templates/modules/architecture/clean',
      );

      final result = merger.merge([module]);

      expect(
        result.templateDirectories,
        contains('templates/modules/architecture/clean'),
      );
    });

    test('merges multiple modules', () {
      final module1 = createModule(
        folders: ['lib/core'],
        packages: [pkg('dio')],
        templateDir: 'templates/modules/architecture/clean',
      );

      final module2 = createModule(
        folders: ['lib/features'],
        packages: [pkg('flutter_riverpod')],
        templateDir: 'templates/modules/state_management/riverpod',
      );

      final result = merger.merge([module1, module2]);

      expect(result.folders.length, 2);
      expect(result.packages.length, 2);
      expect(result.templateDirectories.length, 2);
    });

    test('returns empty project when no modules provided', () {
      final result = merger.merge([]);

      expect(result.folders, isEmpty);
      expect(result.packages, isEmpty);
      expect(result.templateDirectories, isEmpty);
    });

    test('throws on conflicting modules', () async {});

    test('throws on duplicate output files', () async {});

    test('preserves package versions', () async {});

    test('preserves dev dependency flag', () async {});

    test('merges variables', () async {});

    test('merges hooks', () async {});
  });
}

TemplateModule createModule({
  String name = 'Module',
  String category = 'general',
  List<String> folders = const [],
  List<TemplatePackage> packages = const [],
  String? templateDir,
}) {
  return TemplateModule(
    name: name,
    category: category,
    folders: folders,
    packages: packages,
    templateDir: templateDir,
  );
}

TemplatePackage pkg(
  String name, {
  bool dev = false,
}) {
  return TemplatePackage(
    name: name,
    dev: dev,
  );
}
