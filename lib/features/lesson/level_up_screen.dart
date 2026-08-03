import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/lp_colors.dart';
import '../../core/theme/lp_text_styles.dart';
import '../../core/widgets/lp_button.dart';
import '../../core/widgets/lp_card.dart';
import '../../core/widgets/lp_icons.dart';
import '../../core/widgets/mascot_image.dart';
import '../../data/models/lesson.dart';
import '../../state/app_state.dart';
import 'lesson_strings.dart';
import 'widgets/lesson_ui.dart';

/// Level-up celebration per the design (`LEVEL N/last`): gradient
/// level-color background, "N pt" plaque, "Congratulations Malak! You've
/// just leveled up!", celebrating mascot, Accuracy / Speed / Share cards
/// and CONTINUE (grants rewards and pops back home).
class LevelUpScreen extends StatefulWidget {
  const LevelUpScreen({super.key, required this.lesson});

  final Lesson lesson;

  @override
  State<LevelUpScreen> createState() => _LevelUpScreenState();
}

class _LevelUpScreenState extends State<LevelUpScreen> {
  bool _canContinue = false;
  Timer? _continueTimer;

  Color get _color => widget.lesson.levelColor ?? LpColors.brandYellow;

  bool get _lightForeground => widget.lesson.levelNumber != 1;

  @override
  void initState() {
    super.initState();
    _continueTimer = Timer(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _canContinue = true);
    });
  }

  @override
  void dispose() {
    _continueTimer?.cancel();
    super.dispose();
  }

  void _finish() {
    context.read<AppState>().completeLesson(
      widget.lesson.id,
      widget.lesson.xpReward,
      earnedEnergy: widget.lesson.energyReward,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
    final onColor = _lightForeground ? LpColors.bgWhite : LpColors.ink;
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[_color, Color.lerp(_color, Colors.white, 0.5)!],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 18),
                PopIn(
                  child: LpCard(
                    borderWidth: 3,
                    radius: 14,
                    shadowOffset: const Offset(0, 5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 26,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const SparkleIcon(size: 30),
                        const SizedBox(width: 10),
                        Text(
                          '${lesson.pointsReward} ${LessonStrings.pointsSuffix}',
                          style: LpTextStyles.display.copyWith(fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  '${LessonStrings.congratsPrefix}${LessonStrings.learnerName}!',
                  textAlign: TextAlign.center,
                  style: LpTextStyles.h1.copyWith(color: onColor),
                ),
                Text(
                  LessonStrings.leveledUp,
                  textAlign: TextAlign.center,
                  style: LpTextStyles.title.copyWith(color: onColor),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: MascotImage(
                      asset: 'characters/celebrate.png',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: _StatCard(
                          label: LessonStrings.accuracyLabel,
                          value: lesson.accuracyLabel,
                          icon: Icon(
                            Icons.done_all_rounded,
                            size: 22,
                            color: LpColors.brandYellow,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _StatCard(
                          label: LessonStrings.speedLabel,
                          value: lesson.speedLabel,
                          icon: const LessonStopwatchIcon(size: 22),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _StatCard(
                          label: LessonStrings.shareLabel,
                          value: '',
                          icon: Icon(
                            Icons.ios_share_rounded,
                            size: 24,
                            color: LpColors.ink,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                  child: LpButton(
                    label: 'Continue',
                    style: LpButtonStyle.neutral,
                    onPressed: _canContinue ? _finish : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// White bordered stat card (Accuracy 82% / Speed 1:50 / Share).
class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return LpCard(
      borderWidth: 2.5,
      radius: 12,
      shadowOffset: const Offset(0, 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Column(
        children: <Widget>[
          Text(label, style: LpTextStyles.caption.copyWith(color: LpColors.ink)),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              icon,
              if (value.isNotEmpty) ...<Widget>[
                const SizedBox(width: 6),
                Text(value, style: LpTextStyles.title),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
