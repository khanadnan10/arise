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
    final rawName =
        entity.uri.pathSegments.where((segment) => segment.isNotEmpty).last;

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
  for (var pass = 0; pass < 3; pass++) {
    var changed = false;
    for (final entry in variables.entries) {
      final token = '{{${entry.key}}}';
      if (result.contains(token)) {
        result = result.replaceAll(token, entry.value);
        changed = true;
      }
    }
    if (!changed) break;
  }
  return result;
}

Future<void> _copyFile(
  File source,
  File destination,
  Map<String, String> variables,
) async {
  final content = _renderString(await source.readAsString(), variables);

  await destination.parent.create(recursive: true);
  await destination.writeAsString(content);
}
