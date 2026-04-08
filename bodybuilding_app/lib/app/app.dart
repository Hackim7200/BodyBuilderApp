import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bodybuilding_app/app/themes/app_theme.dart';

// import 'package:amplify_authenticator/amplify_authenticator.dart';

class OverloadTrackerApp extends StatelessWidget {
  const OverloadTrackerApp({super.key, required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    // Wrap with [Authenticator] when Amplify is enabled in [main.dart].
    // return Authenticator(
    //   child: MaterialApp.router(
    return MaterialApp.router(
      title: 'KINETIC',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
    //   ),
    // );
  }
}
