enum Networking {
  none('None', 'none'),
  dio('Dio', 'dio');

  const Networking(this.label, this.templateName);

  final String label;
  final String templateName;

  static Networking fromName(String name) {
    return Networking.values.firstWhere(
      (n) => n.templateName == name || n.name == name,
      orElse: () => throw ArgumentError('Unknown networking: $name'),
    );
  }
}
