class TemplateConfig {
  const TemplateConfig({
    required this.name,
    required this.folders,
    required this.dependencies,
    required this.devDependencies,
    required this.files,
  });

  final String name;
  final List<String> folders;
  final List<String> dependencies;
  final List<String> devDependencies;
  final List<TemplateFile> files;
}

class TemplateFile {
  const TemplateFile({
    required this.from,
    required this.to,
  });

  final String from;
  final String to;
}
