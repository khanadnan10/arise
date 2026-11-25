import 'dart:io';

import '../models/template_package.dart';

class PackageService {
  Future<void> install(
    String projectPath,
    List<TemplatePackage> packages,
  ) async {
    for (final package in packages) {
      final result = await Process.run(
          'flutter',
          [
            'pub',
            'add',
            if (package.dev) '--dev',
            if (package.version != null)
              '${package.name}:${package.version}'
            else
              package.name,
          ],
          workingDirectory: projectPath);

      stdout.write(result.stdout);
      stderr.write(result.stderr);
    }
  }

  /// Runs `flutter pub add` for arbitrary pub.dev packages without touching `.arise.yaml`.
  Future<int> addPackages(
    String projectPath,
    List<String> packages, {
    bool dev = false,
  }) async {
    final result = await Process.run(
      'flutter',
      [
        'pub',
        'add',
        if (dev) '--dev',
        ...packages,
      ],
      workingDirectory: projectPath,
    );

    stdout.write(result.stdout);
    stderr.write(result.stderr);
    return result.exitCode;
  }
}
