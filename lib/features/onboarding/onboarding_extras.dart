/// The three screens between the questionnaire and plan loading (design
/// LOG IN/11–13): LetsPlay+ upsell, "Here's what you can accomplish!" and
/// the placement choice.
library;

import 'package:flutter/material.dart';

import '../../core/theme/lp_colors.dart';
import '../../core/theme/lp_text_styles.dart';
import '../../core/widgets/lp_button.dart';
import '../../core/widgets/lp_card.dart';
import '../../core/widgets/lp_logo.dart';
import '../../core/widgets/stud_progress_bar.dart';
import '../../data/content/onboarding_content.dart';
import 'plan_loading_screen.dart';

/// LetsPlay+ subscription promo (design LOG IN/11): royal-blue full screen,
/// logo + "Launching", three navy benefit cards, CONTINUE (X and CONTINUE
/// both just advance — visual only).
class UpsellScreen extends StatelessWidget {
  const UpsellScreen({super.key});

  void _advance(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const AccomplishScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LpColors.royalBlue,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: GestureDetector(
                  onTap: () => _advance(context),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 30,
                    color: LpColors.bgWhite,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(child: LpLogo(height: 110)),
            const SizedBox(height: 6),
            Text(
              upsellLaunching,
              textAlign: TextAlign.center,
              style: LpTextStyles.h1.copyWith(color: LpColors.bgWhite),
            ),
            const SizedBox(height: 22),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: <Widget>[
                  for (final benefit in upsellBenefits)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: LpCard(
                        color: LpColors.darken(LpColors.royalBlue, 0.45),
                        borderWidth: 2.5,
                        shadowOffset: const Offset(0, 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Row(
                          children: <Widget>[
                            Text(
                              benefit.emoji,
                              style: const TextStyle(fontSize: 34),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    benefit.title,
                                    style: LpTextStyles.title.copyWith(
                                      color: LpColors.bgWhite,
                                    ),
                                  ),
                                  Text(
                                    benefit.subtitle,
                                    style: LpTextStyles.caption.copyWith(
                                      color: LpColors.lighten(
                                        LpColors.royalBlue,
                                        0.6,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: LpButton(
                label: upsellContinue,
                style: LpButtonStyle.neutral,
                onPressed: () => _advance(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Here's what you can accomplish!" benefits pitch (design LOG IN/12),
/// inside the survey chrome with a nearly full stud bar.
class AccomplishScreen extends StatelessWidget {
  const AccomplishScreen({super.key});

  static const List<Color> _tileColors = <Color>[
    LpColors.levelBlue,
    LpColors.brickRed,
    LpColors.legoGreen,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const _SurveyChromeHeader(progress: 0.88),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 26, 20, 8),
                children: <Widget>[
                  LpCard(
                    color: LpColors.levelPurple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 22,
                    ),
                    child: Text(
                      accomplishTitle,
                      textAlign: TextAlign.center,
                      style: LpTextStyles.h2.copyWith(color: LpColors.bgWhite),
                    ),
                  ),
                  const SizedBox(height: 24),
                  for (final item in accomplishItems)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: LpCard(
                        borderWidth: 2.5,
                        shadowOffset: const Offset(0, 4),
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 74,
                              height: 74,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: _tileColors[item.tileColorIndex],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: LpColors.ink,
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                item.emoji,
                                style: const TextStyle(fontSize: 34),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(item.title, style: LpTextStyles.title),
                                  const SizedBox(height: 2),
                                  Text(
                                    item.subtitle,
                                    style: LpTextStyles.caption,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: LpButton(
                label: 'Continue',
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (_) => const PlacementScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Placement choice (design LOG IN/13): "Start from Scratch" or "Find my
/// starting place" — both lead to the plan-loading screen (concept demo).
class PlacementScreen extends StatelessWidget {
  const PlacementScreen({super.key});

  void _choose(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const PlanLoadingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const _SurveyChromeHeader(progress: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 26, 20, 0),
              child: LpCard(
                color: LpColors.crimson,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 22,
                ),
                child: Text(
                  placementTitle,
                  textAlign: TextAlign.center,
                  style: LpTextStyles.h2.copyWith(color: LpColors.bgWhite),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _PlacementCard(
              emoji: '🧱',
              tileColor: LpColors.brandYellow,
              title: placementScratchTitle,
              subtitle: placementScratchSubtitle,
              onTap: () => _choose(context),
            ),
            const SizedBox(height: 16),
            _PlacementCard(
              emoji: '🔍',
              tileColor: LpColors.levelOrange,
              title: placementFindTitle,
              subtitle: placementFindSubtitle,
              onTap: () => _choose(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlacementCard extends StatelessWidget {
  const _PlacementCard({
    required this.emoji,
    required this.tileColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String emoji;
  final Color tileColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: onTap,
        child: LpCard(
          borderWidth: 2.5,
          shadowOffset: const Offset(0, 4),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: <Widget>[
              Container(
                width: 74,
                height: 74,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: tileColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: LpColors.ink, width: 2),
                ),
                child: Text(emoji, style: const TextStyle(fontSize: 34)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title, style: LpTextStyles.title),
                    const SizedBox(height: 2),
                    Text(subtitle, style: LpTextStyles.caption),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Back chevron + "Tell us about yourself" + stud bar, shared by the
/// accomplish and placement steps.
class _SurveyChromeHeader extends StatelessWidget {
  const _SurveyChromeHeader({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 22,
                    color: LpColors.ink,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(onboardingTitle, style: LpTextStyles.h2),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
          child: StudProgressBar(progress: progress),
        ),
      ],
    );
  }
}
