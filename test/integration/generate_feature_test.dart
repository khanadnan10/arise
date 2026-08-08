import 'dart:io';

import 'package:test/test.dart';

import 'package:arise/src/models/project_manifest.dart';
import 'package:arise/src/services/manifest_service.dart';
import 'package:arise/src/services/template_loader.dart';
import 'package:arise/src/services/template_merger.dart';
import 'package:arise/src/services/template_service.dart';
import 'package:arise/src/utils/arise_paths.dart';

void main() {
  group('generate feature (clean architecture)', () {
    late Directory tempDir;
    late String projectPath;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('arise_gen_feature_');
      projectPath = tempDir.path;

      // Seed a minimal .arise.yaml so FeatureCommand sees an Arise project.
      await ManifestService().save(
        projectPath: projectPath,
        manifest: const ProjectManifest(
          version: 1,
          projectName: 'test_app',
          architecture: 'clean',
          stateManagement: 'none',
          routing: 'none',
          networking: 'none',
        ),
      );
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('creates expected directory structure for auth feature', () async {
      final module = await TemplateLoader().load(
        ArisePaths.featureTemplate('clean', 'minimal'),
      );
      final merged = TemplateMerger().merge([module]);

      await TemplateService().generate(
        projectPath: projectPath,
        template: merged,
        customVariables: {'feature_name': 'auth'},
      );

      final featureRoot = '$projectPath/lib/features/auth';
      expect(Directory(featureRoot).existsSync(), isTrue);
      expect(Directory('$featureRoot/data').existsSync(), isTrue);
      expect(Directory('$featureRoot/domain').existsSync(), isTrue);
      expect(Directory('$featureRoot/presentation').existsSync(), isTrue);
    });

    test('feature_name variable substitutes correctly in path', () async {
      final module = await TemplateLoader().load(
        ArisePaths.featureTemplate('clean', 'minimal'),
      );
      final merged = TemplateMerger().merge([module]);

      await TemplateService().generate(
        projectPath: projectPath,
        template: merged,
        customVariables: {'feature_name': 'user_profile'},
      );

      expect(
        Directory('$projectPath/lib/features/user_profile').existsSync(),
        isTrue,
      );
    });

    test('multiple features coexist without collision', () async {
      final loader = TemplateLoader();
      final merger = TemplateMerger();
      final service = TemplateService();

      for (final feature in ['auth', 'home', 'settings']) {
        final module = await loader.load(
          ArisePaths.featureTemplate('clean', 'minimal'),
        );
        final merged = merger.merge([module]);
        await service.generate(
          projectPath: projectPath,
          template: merged,
          customVariables: {'feature_name': feature},
        );
      }

      expect(Directory('$projectPath/lib/features/auth').existsSync(), isTrue);
      expect(Directory('$projectPath/lib/features/home').existsSync(), isTrue);
      expect(
        Directory('$projectPath/lib/features/settings').existsSync(),
        isTrue,
      );
    });

    test('duplicate feature generation is idempotent', () async {
      final loader = TemplateLoader();
      final merger = TemplateMerger();
      final service = TemplateService();

      // Generate the same feature twice — second run must not throw.
      for (var i = 0; i < 2; i++) {
        final module = await loader.load(
          ArisePaths.featureTemplate('clean', 'minimal'),
        );
        final merged = merger.merge([module]);
        await service.generate(
          projectPath: projectPath,
          template: merged,
          customVariables: {'feature_name': 'auth'},
        );
      }

      // Directories must still exist after both runs.
      final featureRoot = '$projectPath/lib/features/auth';
      expect(Directory('$featureRoot/data').existsSync(), isTrue);
      expect(Directory('$featureRoot/domain').existsSync(), isTrue);
      expect(Directory('$featureRoot/presentation').existsSync(), isTrue);
    });

    test('no .arise.yaml returns null from ManifestService', () async {
      final emptyDir = await Directory.systemTemp.createTemp(
        'arise_no_manifest_',
      );
      addTearDown(() => emptyDir.delete(recursive: true));

      final manifest = await ManifestService().read(emptyDir.path);

      expect(manifest, isNull);
    });

    test('missing template throws for unsupported architecture', () async {
      expect(
        () => TemplateLoader().load(
          ArisePaths.featureTemplate('viper', 'minimal'),
        ),
        throwsException,
      );
    });

    test('missing template variant throws for unknown template name', () async {
      expect(
        () =>
            TemplateLoader().load(ArisePaths.featureTemplate('clean', 'full')),
        throwsException,
      );
    });
  });

  group('generate feature — per architecture', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('arise_arch_feature_');
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    for (final arch in ['mvvm', 'mvc', 'mvp']) {
      test('$arch minimal template generates expected layers', () async {
        final module = await TemplateLoader().load(
          ArisePaths.featureTemplate(arch, 'minimal'),
        );
        final merged = TemplateMerger().merge([module]);

        await TemplateService().generate(
          projectPath: tempDir.path,
          template: merged,
          customVariables: {'feature_name': 'auth'},
        );

        final featureRoot = '${tempDir.path}/lib/features/auth';
        expect(Directory(featureRoot).existsSync(), isTrue);

        final expectedLayers = switch (arch) {
          'mvvm' => ['model', 'view', 'viewmodel'],
          'mvc' => ['model', 'view', 'controller'],
          'mvp' => ['model', 'view', 'presenter'],
          _ => <String>[],
        };

        for (final layer in expectedLayers) {
          expect(
            Directory('$featureRoot/$layer').existsSync(),
            isTrue,
            reason: '$arch feature missing $layer/',
          );
        }
      });
    }
  });
}
