class MainTemplate {
  static String build() {
    return '''
import 'package:flutter/material.dart';

import 'app.dart';

void main() {
  runApp(const App());
}
''';
  }
}
