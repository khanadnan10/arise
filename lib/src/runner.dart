import 'package:args/command_runner.dart';
import 'package:arise/src/command/add/add_command.dart';
import 'package:arise/src/command/create/create_command.dart';
import 'package:arise/src/command/doctor/doctor_command.dart';
import 'package:arise/src/command/generate/generate_command.dart';
import 'package:arise/src/command/info/info_command.dart';

class AriseCommandRunner extends CommandRunner<int> {
  AriseCommandRunner()
      : super('arise', 'A CLI to bootstrap and manage Flutter projects.') {
    addCommand(CreateCommand());
    addCommand(GenerateCommand());
    addCommand(AddCommand());
    addCommand(InfoCommand());
    addCommand(DoctorCommand());
  }
}
