import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/lp_colors.dart';
import '../../core/theme/lp_text_styles.dart';
import '../../core/widgets/lp_card.dart';
import '../../core/widgets/option_tile.dart';
import '../../core/widgets/stud_progress_bar.dart';
import '../../core/widgets/svg_icon.dart';
import '../../data/content/onboarding_content.dart';
import '../../data/models/onboarding_question.dart';
import '../../state/app_state.dart';
import 'onboarding_extras.dart';

/// "Tell us about yourself" (design LOG IN/7–10) — colored question banner
/// per step + option tiles (2-column illustrated grid for the motivation
/// step); picking an option flashes it and advances after ~350 ms. After
/// the last question → LetsPlay+ upsell → accomplish → placement.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 0;
  int? _selectedOption;
  bool _advancing = false;

  void _onOptionTap(int index) {
    if (_advancing) return;
    final question = onboardingContent[_step];
    setState(() {
      _selectedOption = index;
      _advancing = true;
    });
    context.read<AppState>().answerOnboarding(
      question.id,
      question.options[index].label,
    );
    Future<void>.delayed(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      if (_step >= onboardingContent.length - 1) {
        // Pushed, not replaced, so the back chevron on the following steps
        // has somewhere to return to.
        Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const UpsellScreen()),
        );
        return;
      }
      setState(() {
        _step++;
        _selectedOption = null;
        _advancing = false;
      });
    });
  }

  void _onBack() {
    if (_step > 0) {
      setState(() {
        _step--;
        _selectedOption = null;
        _advancing = false;
      });
    } else {
      Navigator.of(context).maybePop();
    }
  }

  OptionTileStatus _statusFor(int index) => _selectedOption == index
      ? OptionTileStatus.selected
      : OptionTileStatus.idle;

  @override
  Widget build(BuildContext context) {
    final question = onboardingContent[_step];
    final progress =
        (_step + (_selectedOption != null ? 1 : 0)) / onboardingContent.length;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: _onBack,
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
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.08, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
                child: SingleChildScrollView(
                  key: ValueKey<int>(_step),
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      LpCard(
                        color: question.bannerColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 22,
                        ),
                        child: Text(
                          question.question,
                          style: LpTextStyles.h2.copyWith(
                            color: question.darkBannerText
                                ? LpColors.ink
                                : LpColors.bgWhite,
                          ),
                        ),
                      ),
                      const SizedBox(height: 26),
                      if (question.twoColumns)
                        _IllustratedGrid(
                          question: question,
                          statusFor: _statusFor,
                          onTap: _onOptionTap,
                        )
                      else
                        for (
                          var i = 0;
                          i < question.options.length;
                          i++
                        ) ...<Widget>[
                          OptionTile(
                            status: _statusFor(i),
                            onTap: () => _onOptionTap(i),
                            child: _OptionRow(option: question.options[i]),
                          ),
                          const SizedBox(height: 14),
                        ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "min/day — intensity" row (design LOG IN/9) or a plain label.
class _OptionRow extends StatelessWidget {
  const _OptionRow({required this.option});

  final OnboardingOption option;

  @override
  Widget build(BuildContext context) {
    final label = Text(
      option.label,
      style: LpTextStyles.body.copyWith(fontWeight: FontWeight.w700),
    );
    if (option.detail == null) return label;
    return Row(
      children: <Widget>[
        label,
        const Spacer(),
        Text(
          option.detail!,
          style: LpTextStyles.body.copyWith(color: LpColors.textGray),
        ),
      ],
    );
  }
}

/// 2-column illustrated option grid (design LOG IN/7).
class _IllustratedGrid extends StatelessWidget {
  const _IllustratedGrid({
    required this.question,
    required this.statusFor,
    required this.onTap,
  });

  final OnboardingQuestion question;
  final OptionTileStatus Function(int) statusFor;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 14.0;
        final width = (constraints.maxWidth - gap) / 2;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: <Widget>[
            for (var i = 0; i < question.options.length; i++)
              SizedBox(
                width: width,
                height: 118,
                child: OptionTile(
                  status: statusFor(i),
                  onTap: () => onTap(i),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if (question.options[i].iconAsset case final String icon)
                        SvgIcon(asset: icon, size: 46),
                      const SizedBox(height: 8),
                      Text(
                        question.options[i].label,
                        textAlign: TextAlign.center,
                        style: LpTextStyles.caption.copyWith(
                          color: LpColors.ink,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
