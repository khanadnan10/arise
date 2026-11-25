enum Storage {
  none('None', 'none'),
  sharedPreferences('SharedPreferences', 'shared_preferences');

  const Storage(this.label, this.templateName);

  final String label;
  final String templateName;

  static Storage fromName(String name) {
    return Storage.values.firstWhere(
      (s) => s.templateName == name || s.name == name,
      orElse: () => throw ArgumentError('Unknown storage: $name'),
    );
  }
}
