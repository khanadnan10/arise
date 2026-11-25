import 'package:flutter/material.dart';

/// View for the {{feature_name_title}} feature.
class {{feature_name_pascal}}View extends StatelessWidget {
  const {{feature_name_pascal}}View({super.key});

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
