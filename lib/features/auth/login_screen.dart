import 'package:flutter/material.dart';

import '../../core/theme/lp_colors.dart';
import '../../core/theme/lp_text_styles.dart';
import '../../core/widgets/lp_button.dart';
import '../../data/content/ui_strings.dart';
import '../onboarding/onboarding_screen.dart';

/// Visual-only login (spec 5.2). Every action simply advances to onboarding.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;

  void _advance() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const OnboardingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LpColors.royalBlue,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 90),
              Text(
                UiStrings.loginTitle,
                textAlign: TextAlign.center,
                style: LpTextStyles.display.copyWith(color: LpColors.bgWhite),
              ),
              const SizedBox(height: 8),
              Text(
                UiStrings.loginSubtitle,
                textAlign: TextAlign.center,
                style: LpTextStyles.body.copyWith(
                  color: LpColors.bgWhite,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 32),
              const _LoginField(
                hint: UiStrings.emailHint,
                icon: Icons.person_outline_rounded,
              ),
              const SizedBox(height: 14),
              const _LoginField(
                hint: UiStrings.passwordHint,
                icon: Icons.lock_outline_rounded,
                obscure: true,
              ),
              const SizedBox(height: 18),
              Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () => setState(() => _rememberMe = !_rememberMe),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: LpColors.bgWhite,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: LpColors.ink, width: 2),
                          ),
                          child: _rememberMe
                              ? const Icon(
                                  Icons.check_rounded,
                                  size: 16,
                                  color: LpColors.ink,
                                )
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          UiStrings.rememberMe,
                          style: LpTextStyles.body.copyWith(
                            color: LpColors.bgWhite,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _advance,
                    child: Text(
                      UiStrings.forgotPassword,
                      style: LpTextStyles.body.copyWith(
                        color: LpColors.brandYellow,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              LpButton(
                label: UiStrings.signIn,
                style: LpButtonStyle.neutral,
                uppercase: false,
                onPressed: _advance,
              ),
              const SizedBox(height: 14),
              LpButton(
                label: UiStrings.loginWithFacebook,
                style: LpButtonStyle.neutral,
                uppercase: false,
                onPressed: _advance,
                leading: Container(
                  width: 26,
                  height: 26,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: LpColors.royalBlue,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    'f',
                    style: LpTextStyles.title.copyWith(
                      color: LpColors.bgWhite,
                      height: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 44),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _SocialCircle(
                    onTap: _advance,
                    child: const Text('🐦', style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(width: 14),
                  _SocialCircle(
                    onTap: _advance,
                    child: Text(
                      'G+',
                      style: LpTextStyles.body.copyWith(
                        color: LpColors.royalBlue,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: _advance,
                child: Text.rich(
                  TextSpan(
                    text: UiStrings.noAccount,
                    style: LpTextStyles.body.copyWith(
                      color: LpColors.bgWhite,
                      fontSize: 14,
                    ),
                    children: <InlineSpan>[
                      TextSpan(
                        text: UiStrings.signUp,
                        style: LpTextStyles.body.copyWith(
                          color: LpColors.brandYellow,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginField extends StatelessWidget {
  const _LoginField({
    required this.hint,
    required this.icon,
    this.obscure = false,
  });

  final String hint;
  final IconData icon;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: LpColors.bgWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: LpColors.ink, width: 2),
      ),
      child: Row(
        children: <Widget>[
          Icon(icon, color: LpColors.textGray, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              obscureText: obscure,
              style: LpTextStyles.body,
              cursorColor: LpColors.ink,
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: hint,
                hintStyle: LpTextStyles.body.copyWith(color: LpColors.textGray),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialCircle extends StatelessWidget {
  const _SocialCircle({required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: LpColors.bgWhite,
          shape: BoxShape.circle,
        ),
        child: child,
      ),
    );
  }
}
