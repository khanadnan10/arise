import 'dart:io';

class PackageService {
  Future<void> add(String projectPath, List<String> packages) async {
    if (packages.isEmpty) return;

    final result = await Process.run('flutter', [
      'pub',
      'add',
      ...packages,
    ], workingDirectory: projectPath);

    stdout.write(result.stdout);
    stderr.write(result.stderr);
  }
}
