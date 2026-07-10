import 'package:flutter/material.dart';
import 'package:dhikru_linda_flutter/features/journal/model/new_journal_entry_model.dart';

const Color _labelText = Color(0xFF6666AA);
const Color _cardBg = Color(0xFF131325);
const Color _borderColor = Color(0xFF252545);
const Color _white = Colors.white;
const Color _subtleText = Color(0xFF8888AA);

class InterpretationCareReflection extends StatelessWidget {
  final Data? dreamData;

  const InterpretationCareReflection({super.key, this.dreamData});

  static const List<Map<String, dynamic>> _defaultCareItems = [
    {
      'icon': Icons.favorite_border_rounded,
      'iconColor': Color(0xFF9988FF),
      'iconBg': Color(0xFF1E1A3A),
      'title': 'Meditate',
      'subtitle': '5 min practice',
    },
    {
      'icon': Icons.directions_walk_rounded,
      'iconColor': Color(0xFF22CCAA),
      'iconBg': Color(0xFF0A2A22),
      'title': 'Walk',
      'subtitle': 'Get some air',
    },
    {
      'icon': Icons.menu_book_rounded,
      'iconColor': Color(0xFFEEAA44),
      'iconBg': Color(0xFF2A1E0A),
      'title': 'Journal',
      'subtitle': 'Write it down',
    },
    {
      'icon': Icons.coffee_rounded,
      'iconColor': Color(0xFFEE6688),
      'iconBg': Color(0xFF2A1020),
      'title': 'Relax',
      'subtitle': 'Take a break',
    },
  ];

  Map<String, dynamic> _getCareItemIconAndColors(String title) {
    final t = title.toLowerCase();
    if (t.contains('meditat')) {
      return {
        'icon': Icons.favorite_border_rounded,
        'iconColor': const Color(0xFF9988FF),
        'iconBg': const Color(0xFF1E1A3A),
      };
    } else if (t.contains('walk')) {
      return {
        'icon': Icons.directions_walk_rounded,
        'iconColor': const Color(0xFF22CCAA),
        'iconBg': const Color(0xFF0A2A22),
      };
    } else if (t.contains('journal')) {
      return {
        'icon': Icons.menu_book_rounded,
        'iconColor': const Color(0xFFEEAA44),
        'iconBg': const Color(0xFF2A1E0A),
      };
    } else {
      return {
        'icon': Icons.coffee_rounded,
        'iconColor': const Color(0xFFEE6688),
        'iconBg': const Color(0xFF2A1020),
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasData =
        dreamData?.careReflection != null &&
        dreamData!.careReflection!.isNotEmpty;
    final List<Map<String, dynamic>> itemsToShow = [];

    if (hasData) {
      for (var reflection in dreamData!.careReflection!) {
        final title = reflection.title ?? '';
        final subtitle = reflection.shortTitle ?? '';
        if (title.isEmpty) continue;

        final decoration = _getCareItemIconAndColors(title);
        itemsToShow.add({
          'icon': decoration['icon'] ?? Icons.favorite_border_rounded,
          'iconColor': decoration['iconColor'] ?? const Color(0xFF9988FF),
          'iconBg': decoration['iconBg'] ?? const Color(0xFF1E1A3A),
          'title': title,
          'subtitle': subtitle,
        });
      }
    } else {
      itemsToShow.addAll(_defaultCareItems);
    }

    if (itemsToShow.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CARE & REFLECTION',
          style: TextStyle(
            color: _labelText,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 2.6,
          children: itemsToShow.map((item) => _buildCareCard(item)).toList(),
        ),
      ],
    );
  }

  Widget _buildCareCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _borderColor, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: item['iconBg'] as Color,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(
                item['icon'] as IconData,
                color: item['iconColor'] as Color,
                size: 17,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item['title'] as String,
                    style: const TextStyle(
                      color: _white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    item['subtitle'] as String,
                    style: const TextStyle(color: _subtleText, fontSize: 11),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
