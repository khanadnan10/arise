enum Routing {
  none('None'),
  goRouter('GoRouter'),
  autoRoute('AutoRoute');

  const Routing(this.label);

  final String label;

  String get templateName => switch (this) {
    Routing.goRouter => 'go_router',
    Routing.autoRoute => 'auto_route',
    Routing.none => 'none',
  };
}
