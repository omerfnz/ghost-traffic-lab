import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghost_traffic_lab/core/router/app_router.dart';
import 'package:ghost_traffic_lab/core/theme/app_theme.dart';

void main() {
  runApp(
    ProviderScope(child: GhostTrafficApp()),
  );
}

class GhostTrafficApp extends StatelessWidget {
  GhostTrafficApp({super.key});

  final _router = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GhostTraffic Lab',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: _router.config(),
    );
  }
}
