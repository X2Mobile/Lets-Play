import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/services/audio_service.dart';
import '../../core/theme/lp_colors.dart';
import '../../core/theme/lp_text_styles.dart';
import '../../core/widgets/audio_button.dart';
import '../../core/widgets/brick_widget.dart';
import '../../core/widgets/exercise_top_bar.dart';
import '../../core/widgets/lp_button.dart';
import '../../core/widgets/lp_card.dart';
import '../../data/content/levels_content.dart';
import '../../data/content/ui_strings.dart';
import '../../state/app_state.dart';

/// Fatha (ـَ) demo — matches the fat7a prototype frame: three orange bricks
/// climbing above a green "Ascender" baseline, an audio button, and the
/// orange `فتحه (FAT-HAH) Letter+a` card. CONTINUE enables after the sound
/// plays (gray → yellow, like the prototype).
class FathaInfoScreen extends StatefulWidget {
  const FathaInfoScreen({super.key});

  @override
  State<FathaInfoScreen> createState() => _FathaInfoScreenState();
}

class _FathaInfoScreenState extends State<FathaInfoScreen> {
  bool _canContinue = false;
  Timer? _autoplayTimer;
  Timer? _enableTimer;

  @override
  void initState() {
    super.initState();
    _autoplayTimer = Timer(const Duration(milliseconds: 400), () {
      AudioService.instance.playAsset(fathaAudioFile);
    });
    _enableTimer = Timer(const Duration(milliseconds: 1600), () {
      if (mounted) setState(() => _canContinue = true);
    });
  }

  @override
  void dispose() {
    _autoplayTimer?.cancel();
    _enableTimer?.cancel();
    super.dispose();
  }

  void _enableContinue() {
    if (!_canContinue) setState(() => _canContinue = true);
  }

  @override
  Widget build(BuildContext context) {
    final hearts = context.watch<AppState>().hearts;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            ExerciseTopBar(
              hearts: hearts,
              progress: 0.4,
              onClose: () => Navigator.of(context).pop(),
            ),
            const Spacer(),
            const _BrickStaircase(),
            const Spacer(),
            AudioButton(
              audioFile: fathaAudioFile,
              variant: AudioButtonVariant.small,
              onPlayed: _enableContinue,
            ),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: LpCard(
                color: LpColors.orange,
                borderWidth: 3,
                shadowOffset: const Offset(0, 5),
                padding: const EdgeInsets.symmetric(vertical: 18),
                width: double.infinity,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: <Widget>[
                    // Lighter stud peeking from the corner (prototype detail).
                    Positioned(
                      top: -6,
                      right: 10,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: LpColors.lighten(LpColors.orange, 0.35),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          fathaTitleArabic,
                          textDirection: TextDirection.rtl,
                          style: LpTextStyles.arabicLarge.copyWith(
                            fontSize: 38,
                            height: 1.15,
                          ),
                        ),
                        Text(
                          fathaTitleLatin,
                          style: LpTextStyles.h2.copyWith(
                            color: LpColors.bgWhite,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          fathaFormula,
                          style: LpTextStyles.title.copyWith(
                            color: LpColors.bgWhite,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 20),
              child: LpButton(
                label: UiStrings.continueLabel,
                onPressed: _canContinue
                    ? () => Navigator.of(context).pop()
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Three orange 2×2 bricks stepping up-right above the green Ascender line.
class _BrickStaircase extends StatelessWidget {
  const _BrickStaircase();

  static const double _unit = 23;
  static const double _brick = _unit * 2;
  static const double _step = _brick * 0.72;

  @override
  Widget build(BuildContext context) {
    const lineBottom = 26.0;
    return SizedBox(
      height: lineBottom + _brick + _step * 2 + 12,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          // Green "Ascender" baseline.
          Positioned(
            left: 24,
            right: 24,
            bottom: lineBottom,
            child: Container(height: 3, color: LpColors.legoGreen),
          ),
          Positioned(
            left: 24,
            bottom: lineBottom + 5,
            child: Text(
              fathaAscenderLabel,
              style: LpTextStyles.caption.copyWith(
                color: LpColors.ink,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          for (var i = 0; i < 3; i++)
            Positioned(
              bottom: lineBottom + 3 + _step * i,
              left: 0,
              right: 0,
              child: Center(
                child: Transform.translate(
                  offset: Offset((i - 1) * _step, 0),
                  child: const BrickWidget(
                    color: LpColors.orange,
                    unit: _unit,
                    outlined: false,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
