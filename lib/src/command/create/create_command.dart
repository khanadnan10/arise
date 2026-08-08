import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:arise/src/models/create_config.dart';
import 'package:arise/src/models/project_manifest.dart';
import 'package:arise/src/models/template_hook.dart';
import 'package:arise/src/services/hook_service.dart';
import 'package:arise/src/services/manifest_service.dart';
import 'package:arise/src/services/package_service.dart';
import '../../services/template_merger.dart';
import '../../services/template_registry.dart';
import '../../services/template_service.dart';
import '../../utils/arise_paths.dart';
import '../../wizards/create_wizard.dart';

class CreateCommand extends Command<int> {
  CreateCommand() {
    argParser.addFlag(
      'skip',
      abbr: 's',
      help: 'Skip the interactive setup.',
      negatable: false,
    );
  }

  @override
  String get name => 'create';

  @override
  String get description => 'Create a new Flutter project.';

  @override
  Future<int> run() async {
    stdout.writeln('> Welcome to Arise');
    stdout.writeln();

    final config = await CreateWizard().run(
      skip: argResults?['skip'] == true,
      projectName: argResults?.rest.firstOrNull,
    );

    final projectName = config.projectName;

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

    await _createFlutterProject(projectName);

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
      ),
    );

    stdout.writeln();
    stdout.writeln('✅ Project "$projectName" generated successfully!');

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
