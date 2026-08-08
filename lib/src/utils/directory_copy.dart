import 'dart:io';

Future<void> copyDirectory(
  Directory source,
  Directory destination, {
  Map<String, String> variables = const {},
}) async {
  if (!await destination.exists()) {
    await destination.create(recursive: true);
  }

  await for (final entity in source.list()) {
    final rawName = entity.uri.pathSegments
        .where((segment) => segment.isNotEmpty)
        .last;

    // Render variables in the file/directory name itself.
    final name = _renderString(rawName, variables);
    final destinationPath = '${destination.path}/$name';

    if (entity is Directory) {
      await copyDirectory(
        entity,
        Directory(destinationPath),
        variables: variables,
      );
    } else if (entity is File) {
      await _copyFile(entity, File(destinationPath), variables);
    }
  }
}

String _renderString(String input, Map<String, String> variables) {
  var result = input;
  for (final entry in variables.entries) {
    result = result.replaceAll('{{${entry.key}}}', entry.value);
  }
  return result;
}

Future<void> _copyFile(
  File source,
  File destination,
  Map<String, String> variables,
) async {
  var content = await source.readAsString();

  for (final entry in variables.entries) {
    content = content.replaceAll('{{${entry.key}}}', entry.value);
  }

  await destination.parent.create(recursive: true);
  await destination.writeAsString(content);
}
