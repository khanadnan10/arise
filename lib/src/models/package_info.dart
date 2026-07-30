class PackageInfo {
  const PackageInfo({required this.name, this.isDevDependency = false});

  final String name;
  final bool isDevDependency;
}
