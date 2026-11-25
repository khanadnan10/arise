class ProjectManifest {
  const ProjectManifest({
    required this.version,
    required this.projectName,
    required this.architecture,
    required this.stateManagement,
    required this.routing,
    required this.networking,
    this.dependencyInjection = 'none',
    this.storage = 'none',
    this.lint = 'none',
  });

  final int version;
  final String projectName;
  final String architecture;
  final String stateManagement;
  final String routing;
  final String networking;
  final String dependencyInjection;
  final String storage;
  final String lint;

  ProjectManifest copyWith({
    int? version,
    String? projectName,
    String? architecture,
    String? stateManagement,
    String? routing,
    String? networking,
    String? dependencyInjection,
    String? storage,
    String? lint,
  }) {
    return ProjectManifest(
      version: version ?? this.version,
      projectName: projectName ?? this.projectName,
      architecture: architecture ?? this.architecture,
      stateManagement: stateManagement ?? this.stateManagement,
      routing: routing ?? this.routing,
      networking: networking ?? this.networking,
      dependencyInjection: dependencyInjection ?? this.dependencyInjection,
      storage: storage ?? this.storage,
      lint: lint ?? this.lint,
    );
  }
}
