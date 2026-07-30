import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/lp_colors.dart';
import '../../core/theme/lp_text_styles.dart';
import '../../core/widgets/lp_card.dart';
import '../../core/widgets/option_tile.dart';
import '../../core/widgets/stud_progress_bar.dart';
import '../../data/content/onboarding_content.dart';
import '../../state/app_state.dart';
import 'plan_loading_screen.dart';

/// "Tell us about yourself" — yellow question card + gray option tiles;
/// picking an option flashes it yellow and advances after ~350 ms.
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
      question.options[index],
    );
    Future<void>.delayed(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      if (_step >= onboardingContent.length - 1) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (_) => const PlanLoadingScreen()),
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
                        color: LpColors.brandYellow,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 22,
                        ),
                        child: Text(question.question, style: LpTextStyles.h2),
                      ),
                      const SizedBox(height: 26),
                      for (
                        var i = 0;
                        i < question.options.length;
                        i++
                      ) ...<Widget>[
                        OptionTile(
                          status: _selectedOption == i
                              ? OptionTileStatus.selected
                              : OptionTileStatus.idle,
                          label: question.options[i],
                          onTap: () => _onOptionTap(i),
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
