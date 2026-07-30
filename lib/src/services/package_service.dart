import 'dart:io';

class PackageService {
  Future<void> add(List<String> packages) async {
    if (packages.isEmpty) return;

    await Process.run('flutter', ['pub', 'add', ...packages]);
  }
}
