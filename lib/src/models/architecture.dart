enum Architecture {
  none('None'),
  clean('Clean Architecture'),
  mvc('MVC'),
  mvvm('MVVM'),
  mvp('MVP');

  const Architecture(this.label);

  final String label;

  static Architecture fromName(String name) {
    return Architecture.values.firstWhere(
      (a) => a.name == name,
      orElse: () => throw ArgumentError('Unknown architecture: $name'),
    );
  }
}
