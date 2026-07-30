class TemplatePackage {
  const TemplatePackage({required this.name, this.version, this.dev = false});

  final String name;
  final String? version;
  final bool dev;
}
