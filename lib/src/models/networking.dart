enum Networking {
  none('None', 'none'),
  dio('Dio', 'dio');

  const Networking(this.label, this.templateName);

  final String label;
  final String templateName;
}
