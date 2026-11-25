import 'package:flutter/material.dart';

import 'widgets/{{feature_name}}_card.dart';

/// View for the {{feature_name_title}} feature.
class {{feature_name_pascal}}View extends StatelessWidget {
  const {{feature_name_pascal}}View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('{{feature_name_title}}')),
      body: const Center(
        child: {{feature_name_pascal}}Card(title: '{{feature_name_title}}'),
      ),
    );
  }
}
