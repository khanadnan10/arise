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
        final module = await loader.load(ArisePaths.featureTemplate('clean', 'minimal'));
        final merged = merger.merge([module]);
        await service.generate(
          projectPath: projectPath,
          template: merged,
          customVariables: {'feature_name': feature},
        );
      }

      expect(
        Directory('$projectPath/lib/features/auth').existsSync(),
        isTrue,
      );
      expect(
        Directory('$projectPath/lib/features/home').existsSync(),
        isTrue,
      );
      expect(
        Directory('$projectPath/lib/features/settings').existsSync(),
        isTrue,
      );
    });
  });
}
