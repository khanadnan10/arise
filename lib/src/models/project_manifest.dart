class ProjectManifest {
  const ProjectManifest({
    required this.version,
    required this.projectName,
    required this.architecture,
    required this.stateManagement,
    required this.routing,
    required this.networking,
  });

  final int version;
  final String projectName;
  final String architecture;
  final String stateManagement;
  final String routing;
  final String networking;
}
