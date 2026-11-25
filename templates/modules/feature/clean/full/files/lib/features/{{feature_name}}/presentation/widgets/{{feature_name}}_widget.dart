import 'package:flutter/material.dart';

/// Reusable widget for the {{feature_name_title}} feature.
class {{feature_name_pascal}}Widget extends StatelessWidget {
  const {{feature_name_pascal}}Widget({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(title),
      ),
    );
  }
}
