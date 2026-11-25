import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:arise/src/models/project_manifest.dart';
import 'package:arise/src/models/template_hook.dart';
import 'package:arise/src/services/hook_service.dart';
import 'package:arise/src/services/manifest_service.dart';
import 'package:arise/src/services/package_service.dart';
import 'package:arise/src/services/template_merger.dart';
import 'package:arise/src/services/template_registry.dart';
import 'package:arise/src/services/template_service.dart';
import 'package:arise/src/utils/arise_paths.dart';

class AddCommand extends Command<int> {
  AddCommand() {
    argParser
      ..addFlag(
        'list',
        abbr: 'l',
        help: 'List available built-in Arise modules.',
        negatable: false,
      )
      ..addFlag(
        'dev',
        abbr: 'd',
        help:
            'Add pub.dev package(s) as dev_dependencies (when not an Arise module).',
        negatable: false,
      );
  }

  @override
  String get name => 'add';

  @override
  String get invocation =>
      '${runner?.executableName ?? 'arise'} $name <module|package>';

  @override
  String get description =>
      'Add a built-in Arise module or a pub.dev package to the current project.\n'
      '\n'
      'Examples:\n'
      '  arise add dio\n'
      '  arise add get_it\n'
      '  arise add intl\n'
      '  arise add --dev mockito\n'
      '  arise add --list';

  @override
  Future<int> run() async {
    if (argResults?['list'] == true) {
      return _runList();
    }

    final args = argResults?.rest ?? [];
    if (args.isEmpty) {
      usageException('A module or package name is required.');
    }

    final projectPath = Directory.current.path;
    final firstArg = args.first.trim().toLowerCase();
    final resolved = args.length == 1 ? ArisePaths.findModule(firstArg) : null;

    if (resolved == null) {
      return _addFromPub(
        projectPath: projectPath,
        packages: args,
        dev: argResults?['dev'] == true,
      );
    }

    final moduleName = firstArg;
    final manifestService = ManifestService();
    final manifest = await manifestService.read(projectPath);

    if (manifest == null) {
      stderr.writeln('No Arise project found.');
      stderr.writeln(
        'Run this command from the root of a project created with Arise.',
      );
      return 1;
    }

    final existingPaths = _existingModulePaths(manifest);
    final registry = TemplateRegistry();
    final existingModules = await registry.loadModules(paths: existingPaths);
    final newModule =
        (await registry.loadModules(paths: [resolved.configPath])).first;

    try {
      // Validate conflicts & requirements against existing project modules.
      TemplateMerger().merge([...existingModules, newModule]);
    } on StateError catch (error) {
      stderr.writeln('❌ ${error.message}');
      return 1;
    }

    final merged = TemplateMerger().merge([newModule]);

    stdout.writeln('Adding "$moduleName" (${resolved.category})...');

    final hookService = HookService();
    await hookService.runHooks(
      projectPath: projectPath,
      hooks: merged.hooks,
      phase: HookPhase.preGenerate,
    );

    await TemplateService().generate(
      projectPath: projectPath,
      template: merged,
      customVariables: {
        if (manifest.projectName.isNotEmpty)
          'project_name': manifest.projectName,
        if (manifest.projectName.isNotEmpty) 'app_name': manifest.projectName,
      },
    );

    await hookService.runHooks(
      projectPath: projectPath,
      hooks: merged.hooks,
      phase: HookPhase.postGenerate,
    );

    await PackageService().install(projectPath, merged.packages);

    await hookService.runHooks(
      projectPath: projectPath,
      hooks: merged.hooks,
      phase: HookPhase.postPubGet,
    );

    final updated = _withModule(manifest, resolved.category, moduleName);
    await manifestService.save(projectPath: projectPath, manifest: updated);

    stdout.writeln('✅ Module "$moduleName" added.');
    return 0;
  }

  Future<int> _addFromPub({
    required String projectPath,
    required List<String> packages,
    required bool dev,
  }) async {
    if (!File('$projectPath/pubspec.yaml').existsSync()) {
      stderr.writeln('No pubspec.yaml found in the current directory.');
      stderr
          .writeln('Run this command from the root of a Flutter/Dart project.');
      return 1;
    }

    stdout.writeln(
      'Installing ${packages.join(', ')} via flutter pub add'
      '${dev ? ' (--dev)' : ''}...',
    );

    final exitCode = await PackageService().addPackages(
      projectPath,
      packages,
      dev: dev,
    );

    if (exitCode == 0) {
      stdout.writeln(
        '✅ Added ${packages.join(', ')} to pubspec.yaml (.arise.yaml unchanged).',
      );
    }
    return exitCode;
  }

  int _runList() {
    final modules = ArisePaths.availableModulesByCategory();
    stdout.writeln('Available modules:\n');
    for (final entry in modules.entries) {
      stdout.writeln('  ${entry.key}');
      for (final name in entry.value) {
        stdout.writeln('    • $name');
      }
    }
    return 0;
  }

  List<String> _existingModulePaths(ProjectManifest manifest) {
    return [
      if (manifest.stateManagement != 'none')
        ArisePaths.stateManagementTemplate(manifest.stateManagement),
      if (manifest.routing != 'none')
        ArisePaths.routingTemplate(manifest.routing),
      if (manifest.networking != 'none')
        ArisePaths.networkingTemplate(manifest.networking),
      if (manifest.dependencyInjection != 'none')
        ArisePaths.dependencyInjectionTemplate(manifest.dependencyInjection),
      if (manifest.storage != 'none')
        ArisePaths.storageTemplate(manifest.storage),
      if (manifest.lint != 'none') ArisePaths.lintTemplate(manifest.lint),
    ];
  }

  ProjectManifest _withModule(
    ProjectManifest manifest,
    String category,
    String moduleName,
  ) {
    return switch (category) {
      'state_management' => manifest.copyWith(stateManagement: moduleName),
      'routing' => manifest.copyWith(routing: moduleName),
      'networking' => manifest.copyWith(networking: moduleName),
      'dependency_injection' =>
        manifest.copyWith(dependencyInjection: moduleName),
      'storage' => manifest.copyWith(storage: moduleName),
      'lint' => manifest.copyWith(lint: moduleName),
      _ => manifest,
    };
  }
}
