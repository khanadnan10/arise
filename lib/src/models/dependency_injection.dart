enum DependencyInjection {
  none('None', 'none'),
  getIt('GetIt', 'get_it'),
  injectable('Injectable', 'injectable');

  const DependencyInjection(this.label, this.templateName);

  final String label;
  final String templateName;

  static DependencyInjection fromName(String name) {
    return DependencyInjection.values.firstWhere(
      (d) => d.templateName == name || d.name == name,
      orElse: () => throw ArgumentError('Unknown dependency injection: $name'),
    );
  }
}
