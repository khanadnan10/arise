import 'dart:io';

Future<void> copyDirectory(
  Directory source,
  Directory destination, {
  Future<String> Function(String content)? render,
}) async {
  if (!await destination.exists()) {
    await destination.create(recursive: true);
  }

  await for (final entity in source.list(recursive: false)) {
    final name = entity.uri.pathSegments.where((s) => s.isNotEmpty).last;
    final destinationPath = '${destination.path}/$name';

    if (entity is Directory) {
      await copyDirectory(
        entity,
        Directory(destinationPath),
        render: render,
      );
    } else if (entity is File) {
      if (render != null && _isTextFile(name)) {
        final content = await entity.readAsString();
        final renderedContent = await render(content);
        final destFile = File(destinationPath);
        await destFile.parent.create(recursive: true);
        await destFile.writeAsString(renderedContent);
      } else {
        await entity.copy(destinationPath);
      }
    }
  }
}

bool _isTextFile(String fileName) {
  final ext = fileName.toLowerCase();
  return ext.endsWith('.dart') ||
      ext.endsWith('.yaml') ||
      ext.endsWith('.yml') ||
      ext.endsWith('.md') ||
      ext.endsWith('.json') ||
      ext.endsWith('.txt') ||
      ext.endsWith('.gitkeep') ||
      ext.endsWith('.env') ||
      ext.startsWith('.');
}
