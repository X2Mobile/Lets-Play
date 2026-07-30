import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/lp_colors.dart';
import '../../core/theme/lp_text_styles.dart';
import '../../core/widgets/brick_widget.dart';
import '../../data/content/ui_strings.dart';
import '../home/main_shell.dart';

/// Sky-blue "Finishing up your custom plan" screen with a gently bouncing
/// LEGO brick; auto-advances to the home shell after ~2.5 s.
class PlanLoadingScreen extends StatefulWidget {
  const PlanLoadingScreen({super.key});

  @override
  State<PlanLoadingScreen> createState() => _PlanLoadingScreenState();
}

class _PlanLoadingScreenState extends State<PlanLoadingScreen>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  late final AnimationController _bounce = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat();

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const MainShell()),
        (route) => false,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _bounce.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LpColors.skyBlue,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 70),
            // White rounded brand chip.
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              decoration: BoxDecoration(
                color: LpColors.bgWhite,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: <Widget>[
                  Text(
                    UiStrings.appName,
                    style: LpTextStyles.h2.copyWith(
                      color: LpColors.royalBlue,
                      letterSpacing: 1.2,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    UiStrings.appNameArabic,
                    textDirection: TextDirection.rtl,
                    style: LpTextStyles.body.copyWith(
                      fontFamily: LpTextStyles.arabicFontFamily,
                      color: LpColors.royalBlue,
                      fontSize: 13,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 56),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                UiStrings.planLoadingMessage,
                textAlign: TextAlign.center,
                style: LpTextStyles.h1.copyWith(color: LpColors.bgWhite),
              ),
            ),
            const Spacer(),
            AnimatedBuilder(
              animation: _bounce,
              builder: (context, child) {
                // Gentle |sin| hop with a squash shadow.
                final t = _bounce.value;
                final lift = math.sin(t * math.pi).abs() * 26;
                return Column(
                  children: <Widget>[
                    Transform.translate(offset: Offset(0, -lift), child: child),
                    const SizedBox(height: 10),
                    Container(
                      width: 70 - lift * 0.8,
                      height: 10,
                      decoration: BoxDecoration(
                        color: LpColors.ink.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                );
              },
              child: const _StackedBrick(),
            ),
            const SizedBox(height: 110),
          ],
        ),
      ),
    );
  }
}

/// Yellow 2×2 brick sitting on a royal-blue block (per the prototype frame).
class _StackedBrick extends StatelessWidget {
  const _StackedBrick();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const BrickWidget(
          color: LpColors.brandYellow,
          columns: 2,
          rows: 2,
          unit: 31,
          outlined: false,
        ),
        Container(
          width: 62,
          height: 52,
          decoration: BoxDecoration(
            color: LpColors.royalBlue,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(4),
            ),
            border: Border(
              top: BorderSide(
                color: LpColors.darken(LpColors.royalBlue, 0.25),
                width: 3,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
