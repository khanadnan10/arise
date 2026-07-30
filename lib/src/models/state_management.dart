enum StateManagement {
  none('None'),
  provider('Provider'),
  riverpod('Riverpod'),
  bloc('Bloc'),
  getx('GetX');

  const StateManagement(this.label);

  final String label;
}
