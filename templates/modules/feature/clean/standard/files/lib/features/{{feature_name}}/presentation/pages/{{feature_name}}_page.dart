import 'package:flutter/material.dart';

/// Main screen for the {{feature_name_title}} feature.
class {{feature_name_pascal}}Page extends StatelessWidget {
  const {{feature_name_pascal}}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('{{feature_name_title}}')),
      body: const Center(
        child: Text('{{feature_name_title}} Feature'),
      ),
    );
  }
}
