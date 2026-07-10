import 'package:flutter/material.dart';
import 'package:dhikru_linda_flutter/features/journal/model/new_journal_entry_model.dart';

const Color _labelText = Color(0xFF6666AA);
const Color _cardBg = Color(0xFF131325);
const Color _borderColor = Color(0xFF252545);
const Color _white = Colors.white;
const Color _subtleText = Color(0xFF8888AA);

class InterpretationEmotionalLandscape extends StatelessWidget {
  final Data? dreamData;

  const InterpretationEmotionalLandscape({super.key, this.dreamData});

  static const List<Map<String, dynamic>> _defaultEmotions = [
    {
      'label': 'Anxiety',
      'percent': 75,
      'color': Color(0xFFEE4444),
      'trackColor': Color(0xFF3A1A1A),
    },
    {
      'label': 'Confusion',
      'percent': 45,
      'color': Color(0xFF4466EE),
      'trackColor': Color(0xFF1A1A3A),
    },
    {
      'label': 'Awe',
      'percent': 30,
      'color': Color(0xFF22CC88),
      'trackColor': Color(0xFF0A2A1A),
    },
  ];

  Color _getEmotionColor(String name) {
    final n = name.toLowerCase();
    if (n.contains('anxi') ||
        n.contains('fear') ||
        n.contains('stress') ||
        n.contains('overwhelm')) {
      return const Color(0xFFEE4444);
    }
    if (n.contains('confus') || n.contains('doubt') || n.contains('puzzl')) {
      return const Color(0xFF4466EE);
    }
    if (n.contains('awe') || n.contains('wonder') || n.contains('amaz')) {
      return const Color(0xFF22CC88);
    }
    return const Color(0xFF7B6EF6);
  }

  Color _getEmotionTrackColor(String name) {
    final n = name.toLowerCase();
    if (n.contains('anxi') ||
        n.contains('fear') ||
        n.contains('stress') ||
        n.contains('overwhelm')) {
      return const Color(0xFF3A1A1A);
    }
    if (n.contains('confus') || n.contains('doubt') || n.contains('puzzl')) {
      return const Color(0xFF1A1A3A);
    }
    if (n.contains('awe') || n.contains('wonder') || n.contains('amaz')) {
      return const Color(0xFF0A2A1A);
    }
    return const Color(0xFF1A1A30);
  }

  @override
  Widget build(BuildContext context) {
    final hasData =
        dreamData?.emotionalLandscape != null &&
        dreamData!.emotionalLandscape!.isNotEmpty;
    final List<Map<String, dynamic>> emotionsToShow = [];

    if (hasData) {
      for (var emotion in dreamData!.emotionalLandscape!) {
        final name = emotion.name ?? '';
        final percent = emotion.percentage ?? 0;
        if (name.isEmpty) continue;

        emotionsToShow.add({
          'label': name,
          'percent': percent,
          'color': _getEmotionColor(name),
          'trackColor': _getEmotionTrackColor(name),
        });
      }
    } else {
      emotionsToShow.addAll(_defaultEmotions);
    }

    if (emotionsToShow.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'EMOTIONAL LANDSCAPE',
          style: TextStyle(
            color: _labelText,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _borderColor, width: 1),
          ),
          child: Column(
            children: List.generate(emotionsToShow.length, (index) {
              final item = emotionsToShow[index];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index < emotionsToShow.length - 1 ? 18 : 0,
                ),
                child: _buildEmotionBar(item),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildEmotionBar(Map<String, dynamic> item) {
    final int percent = item['percent'] as int;
    final Color barColor = item['color'] as Color;
    final Color trackColor = item['trackColor'] as Color;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item['label'] as String,
              style: const TextStyle(
                color: _white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$percent%',
              style: const TextStyle(
                color: _subtleText,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Container(
                  height: 6,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: trackColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOut,
                  height: 6,
                  width: constraints.maxWidth * (percent / 100),
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
