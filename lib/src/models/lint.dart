enum Lint {
  none('None (Flutter Default)', 'none'),
  veryGoodAnalysis('Very Good Analysis', 'very_good_analysis');

  const Lint(this.label, this.templateName);

  final String label;
  final String templateName;

  static Lint fromName(String name) {
    return Lint.values.firstWhere(
      (l) => l.templateName == name || l.name == name,
      orElse: () => throw ArgumentError('Unknown lint: $name'),
    );
  }
}
