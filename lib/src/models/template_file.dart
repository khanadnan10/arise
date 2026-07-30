class TemplateFile {
  const TemplateFile({required this.sourcePath, required this.to});

  /// Resolved path to the source file on disk.
  final String sourcePath;

  /// Destination path relative to the project root.
  final String to;
}
