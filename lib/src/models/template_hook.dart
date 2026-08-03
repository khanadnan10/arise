enum HookPhase { preGenerate, postGenerate, postPubGet }

class TemplateHook {
  const TemplateHook({
    required this.phase,
    required this.command,
    this.args = const [],
  });

  final HookPhase phase;
  final String command;
  final List<String> args;
}
