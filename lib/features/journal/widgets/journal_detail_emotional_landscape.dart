import 'package:flutter/material.dart';

const Color _labelText = Color(0xFF6666AA);
const Color _cardBg = Color(0xFF131325);
const Color _borderColor = Color(0xFF252545);
const Color _white = Colors.white;
const Color _subtleText = Color(0xFF8888AA);

class JournalDetailEmotionalLandscape extends StatelessWidget {
  final List<Map<String, dynamic>> emotions;

  const JournalDetailEmotionalLandscape({super.key, required this.emotions});

  @override
  Widget build(BuildContext context) {
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
            children: List.generate(emotions.length, (index) {
              final item = emotions[index];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index < emotions.length - 1 ? 18 : 0,
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
