import 'package:args/command_runner.dart';
import 'package:arise/src/command/create/create_command.dart';

class AriseCommandRunner extends CommandRunner<int> {
  AriseCommandRunner()
    : super('arise', 'A CLI to bootstrap and manage Flutter projects.') {
    addCommand(CreateCommand());
  }
}
