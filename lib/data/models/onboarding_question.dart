import 'package:flutter/material.dart';

/// One answer of an [OnboardingQuestion] — plain text, optionally with an
/// icon from the design drop (the "Why … study Arabic?" grid) or a secondary
/// label ("Casual" next to "10 min/day").
@immutable
class OnboardingOption {
  const OnboardingOption(this.label, {this.iconAsset, this.detail});

  final String label;

  /// Path under `assets/images/`, e.g. `icons/motivation_trips.svg`.
  final String? iconAsset;
  final String? detail;
}

/// One step of the "Tell us about yourself" flow. Each step's banner has
/// its own color per the design (blue → orange → azure → yellow).
@immutable
class OnboardingQuestion {
  const OnboardingQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.bannerColor,
    this.darkBannerText = false,
    this.twoColumns = false,
  });

  final String id;
  final String question;
  final List<OnboardingOption> options;

  /// Question banner fill.
  final Color bannerColor;

  /// Yellow banner uses dark text (design LOG IN/10).
  final bool darkBannerText;

  /// Renders options as a 2-column card grid (design LOG IN/7).
  final bool twoColumns;
}
