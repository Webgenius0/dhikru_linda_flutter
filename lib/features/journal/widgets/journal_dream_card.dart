import 'package:flutter/material.dart';
import 'package:dhikru_linda_flutter/features/journal/model/get_all_journal_model.dart';

const Color _white = Colors.white;
const Color _cardBg = Color(0xFF131325);
const Color _borderColor = Color(0xFF252545);
const Color _subtleText = Color(0xFF8888AA);
const Color _tagBg = Color(0xFF1A1A35);
const Color _tagText = Color(0xFF7777BB);

class JournalDreamCard extends StatelessWidget {
  final Map<String, dynamic> dream;
  final ValueChanged<String> onTagTap;
  final int index;
  final ValueChanged<Map<String, dynamic>> onTap;

  const JournalDreamCard({
    super.key,
    required this.dream,
    required this.onTagTap,
    required this.index,
    required this.onTap,
  });

  Color _getAccentColor(int idx) {
    const colors = [
      Color(0xFF22CEE9), // 1st
      Color(0xFF49D97E), // 2nd
      Color(0xFF7B6EF6), // 3rd
      Color(0xFFEEAA44), // 4th
      Color(0xFFEE6688), // 5th
    ];
    return colors[idx % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = _getAccentColor(index);

    return GestureDetector(
      onTap: () {
        final updatedDream = Map<String, dynamic>.from(dream);
        updatedDream['leftAccent'] = accentColor;
        onTap(updatedDream);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 16, 16, 14),
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _borderColor, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            dream['emoji'] as String,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dream['title'] as String,
                              style: const TextStyle(
                                color: _white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.2,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              dream['date'] as String,
                              style: const TextStyle(
                                color: _subtleText,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: dream['badgeColor'] as Color,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          dream['badge'] as String,
                          style: TextStyle(
                            color: dream['badgeTextColor'] as Color,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    dream['description'] as String,
                    style: const TextStyle(
                      color: Color(0xFFAAAAAC),
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: (dream['tags'] as List<String>).map((tag) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () => onTagTap(tag),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _tagBg,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                tag,
                                style: const TextStyle(
                                  color: _tagText,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 4,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
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

class MoodHelper {
  static Map<String, dynamic> getMoodAssets(String? mood) {
    final m = (mood ?? '').toLowerCase();
    if (m.contains('longing') || m.contains('wave') || m.contains('🌊')) {
      return {
        'emoji': '🌊',
        'emojiColor': const Color(0xFF4ECFB5),
        'badge': 'LONGING',
        'badgeColor': const Color(0xFF3A2A60),
        'badgeTextColor': const Color(0xFFBBAAFF),
        'leftAccent': const Color(0xFF7B6EF6),
      };
    } else if (m.contains('calm') ||
        m.contains('leaf') ||
        m.contains('🌿') ||
        m.contains('peaceful')) {
      return {
        'emoji': '🌿',
        'emojiColor': const Color(0xFF6FCF6F),
        'badge': 'CALM',
        'badgeColor': const Color(0xFF1A3A2A),
        'badgeTextColor': const Color(0xFF6FCF6F),
        'leftAccent': const Color(0xFF6FCF6F),
      };
    } else if (m.contains('euphoric') ||
        m.contains('star') ||
        m.contains('✦') ||
        m.contains('wonder')) {
      return {
        'emoji': '✦',
        'emojiColor': const Color(0xFFFFD700),
        'badge': 'EUPHORIC',
        'badgeColor': const Color(0xFF2A2A10),
        'badgeTextColor': const Color(0xFFFFD060),
        'leftAccent': const Color(0xFFFFD700),
      };
    } else {
      return {
        'emoji': '✨',
        'emojiColor': const Color(0xFFFFC0CB),
        'badge': mood?.toUpperCase() ?? 'DREAM',
        'badgeColor': const Color(0xFF221144),
        'badgeTextColor': const Color(0xFFFFD0FF),
        'leftAccent': const Color(0xFF7B6EF6),
      };
    }
  }

  static Map<String, dynamic> mapDatumToDreamMap(Datum item) {
    final moodAssets = getMoodAssets(item.moodDisplay);
    return {
      'id': item.id,
      'emoji': moodAssets['emoji'],
      'emojiColor': moodAssets['emojiColor'],
      'title': item.title ?? 'Untitled Dream',
      'date': item.formattedDate ?? '',
      'badge': moodAssets['badge'],
      'badgeColor': moodAssets['badgeColor'],
      'badgeTextColor': moodAssets['badgeTextColor'],
      'description': item.summary ?? '',
      'tags': item.symbolTags ?? <String>[],
      'leftAccent': moodAssets['leftAccent'],
    };
  }
}
