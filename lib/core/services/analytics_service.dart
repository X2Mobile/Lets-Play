import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';

/// Thin wrapper around Firebase Analytics.
///
/// [init] runs once from `main()`; if Firebase is unavailable (an
/// unregistered platform such as web, or a missing native config) the service
/// stays disabled and every log call becomes a no-op — analytics must never
/// crash the demo.
class AnalyticsService {
  AnalyticsService._();

  static final AnalyticsService instance = AnalyticsService._();

  FirebaseAnalytics? _analytics;

  /// Whether Firebase came up and events are actually being sent.
  bool get isEnabled => _analytics != null;

  Future<void> init() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _analytics = FirebaseAnalytics.instance;
    } catch (error) {
      debugPrint('Analytics disabled — Firebase init failed: $error');
    }
  }

  /// A learner reached the level-up screen at the end of a lesson.
  Future<void> logLevelFinished({
    required String lessonId,
    required String lessonName,
    required int levelNumber,
    required int lessonNumber,
    required int xpEarned,
  }) async {
    await _log('level_finished', <String, Object>{
      'lesson_id': lessonId,
      'lesson_name': lessonName,
      'level_number': levelNumber,
      'lesson_number': lessonNumber,
      'xp_earned': xpEarned,
    });
  }

  Future<void> _log(String name, Map<String, Object> parameters) async {
    final analytics = _analytics;
    if (analytics == null) return;
    try {
      await analytics.logEvent(name: name, parameters: parameters);
    } catch (error) {
      debugPrint('Analytics event "$name" failed: $error');
    }
  }
}
