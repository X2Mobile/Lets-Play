import 'package:flutter/material.dart';

import '../../core/theme/lp_colors.dart';
import '../../core/theme/lp_text_styles.dart';
import '../../core/widgets/lp_card.dart';
import '../../core/widgets/lp_icons.dart';
import '../../core/widgets/stud_progress_bar.dart';
import '../../data/content/placeholders_content.dart';

/// Polished on-brand Quests placeholder.
class QuestsScreen extends StatelessWidget {
  const QuestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        children: <Widget>[
          const Row(
            children: <Widget>[
              SparkleIcon(size: 32),
              SizedBox(width: 10),
              Text(questsTitle, style: LpTextStyles.h1),
            ],
          ),
          const SizedBox(height: 20),
          LpCard(
            color: LpColors.brandYellow,
            borderWidth: 3,
            shadowOffset: const Offset(0, 5),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(questsHeaderTitle, style: LpTextStyles.h2),
                const SizedBox(height: 2),
                Text(
                  questsHeaderBody,
                  style: LpTextStyles.body.copyWith(fontSize: 14.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          for (final quest in questsPlaceholder) ...<Widget>[
            _QuestTile(quest: quest),
            const SizedBox(height: 14),
          ],
          const SizedBox(height: 10),
          LpCard(
            color: LpColors.royalBlue,
            borderWidth: 3,
            shadowOffset: const Offset(0, 5),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: Text(
              questsFooter,
              textAlign: TextAlign.center,
              style: LpTextStyles.title.copyWith(color: LpColors.bgWhite),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestTile extends StatelessWidget {
  const _QuestTile({required this.quest});

  final QuestItem quest;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: LpColors.tileGray,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: LpColors.borderGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                quest.label,
                style: LpTextStyles.body.copyWith(fontWeight: FontWeight.w700),
              ),
              Text(quest.progressLabel, style: LpTextStyles.caption),
            ],
          ),
          const SizedBox(height: 10),
          StudProgressBar(progress: quest.progress, height: 16),
        ],
      ),
    );
  }
}
