import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '{{app_name}}',
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      home: const Scaffold(body: Center(child: Text('Welcome to Arise 🚀'))),
    );
  }
}
