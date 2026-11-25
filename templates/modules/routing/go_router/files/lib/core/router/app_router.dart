import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Application route paths.
abstract final class AppRoutes {
  static const home = '/';
}

/// Central GoRouter configuration for {{app_name}}.
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const _HomePlaceholder(),
    ),
  ],
);

class _HomePlaceholder extends StatelessWidget {
  const _HomePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Welcome to {{app_name}}')),
    );
  }
}
