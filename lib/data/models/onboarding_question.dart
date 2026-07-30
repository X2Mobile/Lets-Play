import 'package:flutter/foundation.dart';

/// One step of the "Tell us about yourself" flow.
@immutable
class OnboardingQuestion {
  const OnboardingQuestion({
    required this.id,
    required this.question,
    required this.options,
  });

  final String id;
  final String question;
  final List<String> options;
}
