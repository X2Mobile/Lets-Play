import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/services/analytics_service.dart';
import 'state/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AnalyticsService.instance.init();
  runApp(
    ChangeNotifierProvider<AppState>(
      create: (_) => AppState(),
      child: const LetsPlayApp(),
    ),
  );
}
