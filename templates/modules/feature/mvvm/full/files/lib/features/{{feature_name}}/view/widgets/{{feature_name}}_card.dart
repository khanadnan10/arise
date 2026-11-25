import 'package:flutter/material.dart';

/// Card widget for displaying {{feature_name_title}} details.
class {{feature_name_pascal}}Card extends StatelessWidget {
  const {{feature_name_pascal}}Card({
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
