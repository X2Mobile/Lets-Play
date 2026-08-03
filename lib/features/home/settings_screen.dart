import 'package:flutter/material.dart';

import '../../core/theme/lp_colors.dart';
import '../../core/theme/lp_text_styles.dart';
import '../../core/widgets/lp_button.dart';
import '../../core/widgets/lp_icons.dart';
import '../../data/content/placeholders_content.dart';

/// Settings per the design (`PROFILE /2`): avatar + change photo, account
/// rows, legal rows, sound-effects toggle, help/feedback and Sign Out.
/// Everything is visual-only (concept demo).
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEffects = true;

  void _showSnack() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text(profileComingSoonSnack)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LpColors.bgWhite,
      appBar: AppBar(
        backgroundColor: LpColors.bgWhite,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 22,
            color: LpColors.ink,
          ),
        ),
        title: const Text(settingsTitle, style: LpTextStyles.h2),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: <Widget>[
          Center(
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: LpColors.ink, width: 3),
                boxShadow: const <BoxShadow>[
                  BoxShadow(color: LpColors.ink, offset: Offset(0, 4)),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/illustrations/avatar.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const Center(
                    child: SmileyIcon(size: 60),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: GestureDetector(
              onTap: _showSnack,
              child: Text(
                settingsChangePhoto,
                style: LpTextStyles.body.copyWith(
                  color: LpColors.royalBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 22),
          _ValueRow(
            label: settingsUsernameLabel,
            value: settingsUsernameValue,
            onTap: _showSnack,
          ),
          _ValueRow(
            label: settingsPasswordLabel,
            value: settingsPasswordValue,
            onTap: _showSnack,
          ),
          _ValueRow(
            label: settingsEmailLabel,
            value: settingsEmailValue,
            onTap: _showSnack,
          ),
          const SizedBox(height: 16),
          _PlainRow(label: settingsTerms, onTap: _showSnack),
          _PlainRow(label: settingsPrivacy, onTap: _showSnack),
          _PlainRow(
            label: settingsDeleteAccount,
            onTap: _showSnack,
            labelColor: LpColors.brickRed,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: _rowDecoration,
            child: Row(
              children: <Widget>[
                Text(
                  settingsSoundEffects,
                  style: LpTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Switch(
                  value: _soundEffects,
                  activeTrackColor: LpColors.legoGreen,
                  onChanged: (value) =>
                      setState(() => _soundEffects = value),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _PlainRow(label: settingsHelpCenter, onTap: _showSnack),
          _PlainRow(label: settingsFeedback, onTap: _showSnack),
          const SizedBox(height: 22),
          LpButton(
            label: settingsSignOut,
            style: LpButtonStyle.neutral,
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
          ),
        ],
      ),
    );
  }
}

BoxDecoration get _rowDecoration => BoxDecoration(
  color: LpColors.tileGray,
  borderRadius: BorderRadius.circular(10),
  border: Border.all(color: LpColors.borderGray),
);

/// Quiet row with a label and current value (Username / Password / Email).
class _ValueRow extends StatelessWidget {
  const _ValueRow({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: _rowDecoration,
          child: Row(
            children: <Widget>[
              Text(
                label,
                style: LpTextStyles.body.copyWith(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Text(
                value,
                style: LpTextStyles.body.copyWith(color: LpColors.textGray),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Quiet row with just a label and a chevron.
class _PlainRow extends StatelessWidget {
  const _PlainRow({
    required this.label,
    required this.onTap,
    this.labelColor = LpColors.ink,
  });

  final String label;
  final VoidCallback onTap;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: _rowDecoration,
          child: Row(
            children: <Widget>[
              Text(
                label,
                style: LpTextStyles.body.copyWith(
                  fontWeight: FontWeight.w700,
                  color: labelColor,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.chevron_right_rounded,
                size: 22,
                color: LpColors.textGray,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
