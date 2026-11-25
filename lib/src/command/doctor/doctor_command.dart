import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:arise/src/services/manifest_service.dart';
import 'package:arise/src/utils/arise_paths.dart';

class DoctorCommand extends Command<int> {
  @override
  String get name => 'doctor';

  @override
  String get description =>
      'Check Dart/Flutter tooling, Arise templates, and project manifest health.';

  @override
  Future<int> run() async {
    stdout.writeln('Arise Doctor');
    stdout.writeln('────────────');

    var hasErrors = false;

    // 1. Dart SDK
    final dartVersion = Platform.version.split(' ').first;
    stdout.writeln('[✓] Dart SDK: $dartVersion');

    // 2. Flutter SDK
    final flutterCheck = await _checkFlutter();
    if (flutterCheck != null) {
      stdout.writeln('[✓] $flutterCheck');
    } else {
      stdout.writeln('[✗] Flutter SDK not found in PATH');
      hasErrors = true;
    }

    // 3. Arise Templates
    final templatesRoot =
        Directory('${ArisePaths.packageRoot}/templates/modules');
    final featureArchs = ArisePaths.featureArchitectures();
    if (templatesRoot.existsSync() && featureArchs.isNotEmpty) {
      stdout.writeln(
        '[✓] Templates loaded (${featureArchs.length} feature architectures: '
        '${featureArchs.join(', ')})',
      );
    } else {
      stdout.writeln('[✗] Arise templates directory is missing or incomplete');
      hasErrors = true;
    }

    // 4. Current project manifest (optional)
    final projectPath = Directory.current.path;
    final manifestFile = File('$projectPath/.arise.yaml');
    if (manifestFile.existsSync()) {
      final manifest = await ManifestService().read(projectPath);
      if (manifest == null) {
        stdout.writeln('[✗] .arise.yaml exists but could not be parsed');
        hasErrors = true;
      } else {
        final archConfig = File(
          ArisePaths.architectureTemplate(manifest.architecture),
        );
        if (!archConfig.existsSync()) {
          stdout.writeln(
            '[!] .arise.yaml references unknown architecture '
            '"${manifest.architecture}"',
          );
          hasErrors = true;
        } else {
          stdout.writeln(
            '[✓] Arise project "${manifest.projectName}" '
            '(${manifest.architecture}, ${manifest.stateManagement}, '
            '${manifest.routing}, ${manifest.networking})',
          );
        }
      }
    } else {
      stdout.writeln('[•] Not inside an Arise project directory');
    }

    return hasErrors ? 1 : 0;
  }

  Future<String?> _checkFlutter() async {
    try {
      final result = await Process.run('flutter', ['--version']);
      if (result.exitCode != 0) return null;
      final firstLine = result.stdout
          .toString()
          .split('\n')
          .map((l) => l.trim())
          .firstWhere((l) => l.isNotEmpty, orElse: () => 'Flutter SDK');
      return firstLine;
    } on ProcessException {
      return null;
    }
  }
}
