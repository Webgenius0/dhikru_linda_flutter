import 'package:flutter/material.dart';
import 'package:dhikru_linda_flutter/features/journal/model/new_journal_entry_model.dart';

const Color _accentPurple = Color(0xFF7B6EF6);
const Color _white = Colors.white;
const Color _subtleText = Color(0xFF8888AA);

class InterpretationHeroHeader extends StatelessWidget {
  final Data? dreamData;

  const InterpretationHeroHeader({super.key, this.dreamData});

  @override
  Widget build(BuildContext context) {
    final title = dreamData?.title ?? 'The Endless Ocean';
    final dateAndMoods = dreamData != null
        ? '${dreamData!.formattedDate ?? ''}${dreamData!.moodDisplay != null ? ' • ${dreamData!.moodDisplay}' : ''}'
        : 'Oct 25 • Anxiety, Overwhelm';

    return Column(
      children: [
        // Purple circle icon
        Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            color: _accentPurple,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Text(
              '✦',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Dream title
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: _white,
            fontSize: 26,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        // Date + tags
        Text(
          dateAndMoods,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: _subtleText,
            fontSize: 13,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }
}
