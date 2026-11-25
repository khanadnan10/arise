import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:arise/src/models/architecture.dart';
import 'package:arise/src/models/create_config.dart';
import 'package:arise/src/models/dependency_injection.dart';
import 'package:arise/src/models/lint.dart';
import 'package:arise/src/models/networking.dart';
import 'package:arise/src/models/project_manifest.dart';
import 'package:arise/src/models/routing.dart';
import 'package:arise/src/models/state_management.dart';
import 'package:arise/src/models/storage.dart';
import 'package:arise/src/models/template_hook.dart';
import 'package:arise/src/services/hook_service.dart';
import 'package:arise/src/services/manifest_service.dart';
import 'package:arise/src/services/package_service.dart';
import '../../services/template_merger.dart';
import '../../services/template_registry.dart';
import '../../services/template_service.dart';
import '../../utils/arise_paths.dart';
import '../../utils/feature_name.dart';
import '../../wizards/create_wizard.dart';

class CreateCommand extends Command<int> {
  CreateCommand() {
    argParser
      ..addFlag(
        'skip',
        abbr: 's',
        help: 'Skip the interactive setup (defaults omitted options to none).',
        negatable: false,
      )
      ..addOption(
        'arch',
        abbr: 'a',
        help: 'Project architecture.',
        allowed: Architecture.values.map((e) => e.name).toList(),
      )
      ..addOption(
        'state',
        help: 'State management solution.',
        allowed: StateManagement.values.map((e) => e.name).toList(),
      )
      ..addOption(
        'route',
        abbr: 'r',
        help: 'Routing solution.',
        allowed: Routing.values.map((e) => e.templateName).toList(),
      )
      ..addOption(
        'network',
        abbr: 'n',
        help: 'Networking client.',
        allowed: Networking.values.map((e) => e.templateName).toList(),
      )
      ..addOption(
        'di',
        help: 'Dependency injection solution.',
        allowed: DependencyInjection.values.map((e) => e.templateName).toList(),
      )
      ..addOption(
        'storage',
        help: 'Local storage solution.',
        allowed: Storage.values.map((e) => e.templateName).toList(),
      )
      ..addOption(
        'lint',
        help: 'Linting ruleset.',
        allowed: Lint.values.map((e) => e.templateName).toList(),
      );
  }

  @override
  String get name => 'create';

  @override
  String get invocation =>
      '${runner?.executableName ?? 'arise'} $name [project_name]';

  @override
  String get description => 'Create a new Flutter project.\n'
      '\n'
      'Examples:\n'
      '  arise create\n'
      '  arise create my_app --skip\n'
      '  arise create my_app --arch clean --state riverpod --route go_router --network dio';

  @override
  Future<int> run() async {
    final skip = argResults?['skip'] == true;
    final rest = argResults?.rest ?? [];
    if (rest.length > 1) {
      usageException('Unexpected argument(s): ${rest.skip(1).join(' ')}.');
    }
    final rawProjectName = rest.firstOrNull;

    if (skip && (rawProjectName == null || rawProjectName.trim().isEmpty)) {
      usageException('A project name is required when using --skip.');
    }

    stdout.writeln('> Welcome to Arise');
    stdout.writeln();

    final archOption = argResults?['arch'] as String?;
    final stateOption = argResults?['state'] as String?;
    final routeOption = argResults?['route'] as String?;
    final networkOption = argResults?['network'] as String?;
    final diOption = argResults?['di'] as String?;
    final storageOption = argResults?['storage'] as String?;
    final lintOption = argResults?['lint'] as String?;

    final config = await CreateWizard().run(
      skip: skip,
      projectName: rawProjectName?.trim(),
      architecture:
          archOption != null ? Architecture.fromName(archOption) : null,
      stateManagement:
          stateOption != null ? StateManagement.fromName(stateOption) : null,
      routing: routeOption != null ? Routing.fromName(routeOption) : null,
      networking:
          networkOption != null ? Networking.fromName(networkOption) : null,
      dependencyInjection:
          diOption != null ? DependencyInjection.fromName(diOption) : null,
      storage: storageOption != null ? Storage.fromName(storageOption) : null,
      lint: lintOption != null ? Lint.fromName(lintOption) : null,
    );

    final projectName = config.projectName.trim();

    if (!FeatureName.isValid(projectName)) {
      stderr.writeln(
        'Invalid project name "$projectName". '
        'Use a valid Dart package name (lowercase letters, digits, underscores, starting with a letter).',
      );
      return 64;
    }

    if (_projectExists(projectName)) {
      stderr.writeln('❌ Project "$projectName" already exists.');
      return 1;
    }

    stdout.writeln();
    if (!await _isFlutterInstalled()) {
      stderr.writeln('❌ Flutter SDK not found.');
      stderr.writeln('Please install Flutter and add it to your PATH.');
      return 1;
    }

    stdout.writeln('Creating Flutter project...');
    stdout.writeln('Architecture: ${config.architecture.label}');
    stdout.writeln('State Management: ${config.stateManagement.label}');
    stdout.writeln('Routing: ${config.routing.label}');
    stdout.writeln('Networking: ${config.networking.label}');
    stdout.writeln('Dependency Injection: ${config.dependencyInjection.label}');
    stdout.writeln('Storage: ${config.storage.label}');
    stdout.writeln('Lint: ${config.lint.label}');

    final createExitCode = await _createFlutterProject(projectName);
    if (createExitCode != 0) {
      stderr.writeln('❌ Failed to create Flutter project "$projectName".');
      return createExitCode;
    }

    final paths = _resolveTemplatePaths(config);

    final registry = TemplateRegistry();
    final modules = await registry.loadModules(paths: paths);

    final merger = TemplateMerger();
    final merged = merger.merge(modules);

    final hookService = HookService();

    // 1. preGenerate hooks
    await hookService.runHooks(
      projectPath: projectName,
      hooks: merged.hooks,
      phase: HookPhase.preGenerate,
    );

    // 2. Generate template structure & files
    final templateService = TemplateService();
    await templateService.generate(
      projectPath: projectName,
      template: merged,
      customVariables: {'project_name': projectName, 'app_name': projectName},
    );

    // 3. postGenerate hooks
    await hookService.runHooks(
      projectPath: projectName,
      hooks: merged.hooks,
      phase: HookPhase.postGenerate,
    );

    // 4. Install packages
    final packageService = PackageService();
    await packageService.install(projectName, merged.packages);

    // 5. postPubGet hooks
    await hookService.runHooks(
      projectPath: projectName,
      hooks: merged.hooks,
      phase: HookPhase.postPubGet,
    );

    // 6. Save manifest
    final manifestService = ManifestService();
    await manifestService.save(
      projectPath: projectName,
      manifest: ProjectManifest(
        version: 1,
        projectName: projectName,
        architecture: config.architecture.name,
        stateManagement: config.stateManagement.name,
        routing: config.routing.templateName,
        networking: config.networking.templateName,
        dependencyInjection: config.dependencyInjection.templateName,
        storage: config.storage.templateName,
        lint: config.lint.templateName,
      ),
    );

    stdout.writeln();
    stdout.writeln('✅ Project "$projectName" generated successfully!');
    stdout.writeln();
    stdout.writeln('💡 Next: cd $projectName');
    stdout.writeln(
      '   Then run: arise gen feature <name>  '
      'to scaffold your first feature.',
    );

    return 0;
  }

  List<String> _resolveTemplatePaths(CreateConfig config) {
    return [
      ArisePaths.architectureTemplate(config.architecture.name),
      if (config.stateManagement.name != 'none')
        ArisePaths.stateManagementTemplate(config.stateManagement.name),
      if (config.routing.templateName != 'none')
        ArisePaths.routingTemplate(config.routing.templateName),
      if (config.networking.templateName != 'none')
        ArisePaths.networkingTemplate(config.networking.templateName),
      if (config.dependencyInjection.templateName != 'none')
        ArisePaths.dependencyInjectionTemplate(
          config.dependencyInjection.templateName,
        ),
      if (config.storage.templateName != 'none')
        ArisePaths.storageTemplate(config.storage.templateName),
      if (config.lint.templateName != 'none')
        ArisePaths.lintTemplate(config.lint.templateName),
    ];
  }

  Future<bool> _isFlutterInstalled() async {
    final result = await Process.run('flutter', ['--version']);
    return result.exitCode == 0;
  }

  bool _projectExists(String projectName) {
    return Directory(projectName).existsSync();
  }

  Future<int> _createFlutterProject(String projectName) async {
    final result = await Process.run('flutter', ['create', projectName]);

    stdout.write(result.stdout);
    stderr.write(result.stderr);

    return result.exitCode;
  }
}
