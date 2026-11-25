import 'dart:io';

import 'package:test/test.dart';

import 'package:arise/src/models/template_hook.dart';
import 'package:arise/src/services/hook_service.dart';
import 'package:arise/src/services/package_service.dart';
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
    test(combination.name, () async {
      final tempDirectory = await Directory.systemTemp.createTemp(
        'arise_modules_',
      );

      final projectName = '${combination.architecture}_module_test';
      final projectPath = '${tempDirectory.path}/$projectName';

      try {
        // 1. Create a real Flutter project.
        final createResult = await Process.run(
            'flutter',
            [
              'create',
              projectName,
            ],
            workingDirectory: tempDirectory.path);

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
          loader.load(ArisePaths.routingTemplate(combination.routing)),
          loader.load(ArisePaths.networkingTemplate(combination.networking)),
        ]);

        final merged = TemplateMerger().merge(modules);

        // 3. Apply the merged template to the project.
        await TemplateService().generate(
          projectPath: projectPath,
          template: merged,
        );

        // 4. Install packages declared by the modules.
        await PackageService().install(projectPath, merged.packages);

        // 5. Run postPubGet hooks (e.g., build_runner for AutoRoute).
        await HookService().runHooks(
          projectPath: projectPath,
          hooks: merged.hooks,
          phase: HookPhase.postPubGet,
        );

        // 6. Generate a full state-aware feature into the project.
        final stateLayer = switch (combination.architecture) {
          'mvvm' => 'viewmodel',
          'mvc' => 'controller',
          'mvp' => 'presenter',
          _ => 'presentation',
        };
        final featureModule = await loader.load(
          ArisePaths.featureTemplate(combination.architecture, 'full'),
        );
        final stateOverlay = await loader.load(
          ArisePaths.featureStateTemplate(combination.stateManagement),
        );
        final featureMerged = TemplateMerger().merge([
          featureModule,
          stateOverlay,
        ]);
        await TemplateService().generate(
          projectPath: projectPath,
          template: featureMerged,
          customVariables: {
            'project_name': projectName,
            'feature_name': 'user_profile',
            'state_layer': stateLayer,
          },
        );

        // 7. Verify the generated project is clean.
        final analyze = await Process.run(
            'flutter',
            [
              'analyze',
            ],
            workingDirectory: projectPath);

        expect(
          analyze.exitCode,
          0,
          reason: '${analyze.stdout}\n${analyze.stderr}',
        );

        // 6. Verify all tests pass.
        final flutterTest = await Process.run(
            'flutter',
            [
              'test',
            ],
            workingDirectory: projectPath);

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
    }, timeout: const Timeout(Duration(minutes: 5)));
  }
}
