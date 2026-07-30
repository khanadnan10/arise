import 'dart:io';

import 'package:arise/src/models/package_info.dart';

class PackageService {
  Future<void> add(String projectPath, List<PackageInfo> packages) async {
    for (final package in packages) {
      final result = await Process.run('flutter', [
        'pub',
        'add',
        if (package.isDevDependency) '--dev',
        package.name,
      ], workingDirectory: projectPath);

      stdout.write(result.stdout);
      stderr.write(result.stderr);
    }
  }
}
