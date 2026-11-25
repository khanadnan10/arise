enum StateManagement {
  none('None'),
  provider('Provider'),
  riverpod('Riverpod'),
  bloc('Bloc'),
  getx('GetX');

  const StateManagement(this.label);

  final String label;

  static StateManagement fromName(String name) {
    return StateManagement.values.firstWhere(
      (s) => s.name == name,
      orElse: () => throw ArgumentError('Unknown state management: $name'),
    );
  }
}
