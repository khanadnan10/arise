import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:{{project_name}}/app.dart';

void main() {
  testWidgets('app renders successfully', (tester) async {
    await tester.pumpWidget(const App());

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
