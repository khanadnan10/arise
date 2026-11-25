import 'package:flutter/material.dart';
{{state_imports}}{{di_imports}}import 'app.dart';

Future<void> main() async {
{{di_setup}}{{state_setup}}  runApp({{main_root}});
}
