import 'package:flutter/material.dart';

import 'core/theme/lp_theme.dart';
import 'data/content/ui_strings.dart';
import 'features/splash/splash_screen.dart';

/// Root MaterialApp. Chrome is LTR English; Arabic strings set their own
/// text direction where rendered.
class LetsPlayApp extends StatelessWidget {
  const LetsPlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: UiStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: LpTheme.light,
      home: const SplashScreen(),
    );
  }
}
