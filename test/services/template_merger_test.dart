import 'package:test/test.dart';

import 'package:arise/src/models/template_file.dart';
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

    test('merges files', () {
      final module = createModule(
        files: [
          file(
            'files/main.dart',
            'lib/main.dart',
          ),
          file(
            'files/app.dart',
            'lib/app.dart',
          ),
        ],
      );

      final result = merger.merge([module]);

      expect(
        result.files.length,
        2,
      );
    });

    test('merges multiple modules', () {
      final module1 = createModule(
        folders: ['lib/core'],
        packages: [pkg('dio')],
      );

      final module2 = createModule(
        folders: ['lib/features'],
        packages: [pkg('flutter_riverpod')],
      );

      final result = merger.merge([module1, module2]);

      expect(result.folders.length, 2);
      expect(result.packages.length, 2);
    });

    test('returns empty project when no modules provided', () {
      final result = merger.merge([]);

      expect(result.folders, isEmpty);
      expect(result.packages, isEmpty);
      expect(result.files, isEmpty);
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
  List<TemplateFile> files = const [],
}) {
  return TemplateModule(
    name: name,
    category: category,
    folders: folders,
    packages: packages,
    files: files,
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

TemplateFile file(
  String from,
  String to,
) {
  return TemplateFile(
    sourcePath: from,
    to: to,
  );
}
