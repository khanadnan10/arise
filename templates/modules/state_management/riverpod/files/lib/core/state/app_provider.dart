import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the application title across the widget tree.
final appTitleProvider = Provider<String>((ref) => '{{app_name}}');
