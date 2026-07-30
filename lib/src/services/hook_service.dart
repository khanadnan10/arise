import 'dart:io';

import '../models/template_hook.dart';

class HookService {
  Future<void> runHooks({
    required String projectPath,
    required List<TemplateHook> hooks,
    required HookPhase phase,
  }) async {
    final phaseHooks = hooks.where((h) => h.phase == phase).toList();

    for (final hook in phaseHooks) {
      stdout.writeln('Running hook [${hook.phase.name}]: ${hook.command} ${hook.args.join(' ')}');
      final result = await Process.run(
        hook.command,
        hook.args,
        workingDirectory: projectPath,
      );

      stdout.write(result.stdout);
      stderr.write(result.stderr);
    }
  }
}
