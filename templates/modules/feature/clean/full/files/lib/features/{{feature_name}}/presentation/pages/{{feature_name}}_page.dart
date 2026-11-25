import 'package:flutter/material.dart';

import '../widgets/{{feature_name}}_widget.dart';

/// Main screen for the {{feature_name_title}} feature.
class {{feature_name_pascal}}Page extends StatelessWidget {
  const {{feature_name_pascal}}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('{{feature_name_title}}')),
      body: const Center(
        child: {{feature_name_pascal}}Widget(title: '{{feature_name_title}}'),
      ),
    );
  }
}
