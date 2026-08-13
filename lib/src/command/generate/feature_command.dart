import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:arise/src/services/manifest_service.dart';
import 'package:arise/src/services/template_merger.dart';
import 'package:arise/src/services/template_registry.dart';
import 'package:arise/src/services/template_service.dart';
import 'package:arise/src/utils/arise_paths.dart';
import 'package:arise/src/utils/feature_name.dart';

class FeatureCommand extends Command<int> {
  FeatureCommand() {
    argParser.addOption(
      'template',
      abbr: 't',
      help: 'Feature template to use.',
      defaultsTo: 'minimal',
    );
    argParser.addFlag(
      'force',
      abbr: 'f',
      help: 'Overwrite existing feature directory.',
      negatable: false,
    );
    argParser.addFlag(
      'list',
      abbr: 'l',
      help: 'List available architectures and templates.',
      negatable: false,
    );
  }

  @override
  String get name => 'feature';

  @override
  String get description => 'Generate a feature.';

  @override
  Future<int> run() async {
    final list = argResults!['list'] as bool;

    if (list) {
      return _runList();
    }

    final arguments = argResults?.rest ?? [];

    if (arguments.isEmpty) {
      usageException('A feature name is required.');
    }

    final featureName = FeatureName.normalize(arguments.first);

    if (!FeatureName.isValid(featureName)) {
      stderr.writeln(
        'Invalid feature name "${arguments.first}". '
        'Use lowercase letters, numbers, underscores, or hyphens.',
      );
      return 64;
    }

    final templateName = argResults!['template'] as String;
    final force = argResults!['force'] as bool;
    final projectPath = Directory.current.path;

    final manifest = await ManifestService().read(projectPath);

    if (manifest == null) {
      stderr.writeln('No Arise project found.');
      stderr.writeln(
        'Run this command from the root of a project created with Arise.',
      );
      return 1;
    }

    final featureDir = Directory('$projectPath/lib/features/$featureName');
    if (!force && featureDir.existsSync()) {
      stderr.writeln(
        'Feature "$featureName" already exists at lib/features/$featureName.',
      );
      stderr.writeln('Use --force to overwrite.');
      return 1;
    }

    final templatePath = ArisePaths.featureTemplate(
      manifest.architecture,
      templateName,
    );

    if (!File(templatePath).existsSync()) {
      final available = ArisePaths.featureTemplates(manifest.architecture);
      stderr.writeln(
        'Template "$templateName" not found for ${manifest.architecture} architecture.',
      );
      stderr.writeln(
        available.isEmpty
            ? 'No templates available for this architecture.'
            : 'Available: ${available.join(', ')}',
      );
      return 1;
    }

    stdout.writeln(
      'Generating feature "$featureName" '
      'using ${manifest.architecture}/$templateName...',
    );

    final registry = TemplateRegistry();
    final modules = await registry.loadModules(paths: [templatePath]);

    final merged = TemplateMerger().merge(modules);

    await TemplateService().generate(
      projectPath: projectPath,
      template: merged,
      customVariables: {'feature_name': featureName},
    );

    stdout.writeln('✅ Feature "$featureName" generated.');

    return 0;
  }

  Future<int> _runList() async {
    final architectures = ArisePaths.featureArchitectures();

    if (architectures.isEmpty) {
      stdout.writeln('No feature templates found.');
      return 0;
    }

    final manifest = await ManifestService().read(Directory.current.path);

    stdout.writeln('Available feature templates:\n');

    for (final arch in architectures) {
      final templates = ArisePaths.featureTemplates(arch);
      final isCurrent = manifest?.architecture == arch;
      final marker = isCurrent ? '  ← current project' : '';
      stdout.writeln('  $arch$marker');
      for (final tmpl in templates) {
        stdout.writeln('    • $tmpl');
      }
    }

    if (manifest == null) {
      stdout.writeln(
        '\nRun from an Arise project root to see which architecture is active.',
      );
    }

    return 0;
  }
}
