import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

export 'journal_detail_shimmer.dart';
export 'journal_detail_app_bar.dart';
export 'journal_detail_hero_header.dart';
export 'journal_detail_text_card.dart';
export 'journal_detail_respond_section.dart';
export 'journal_detail_care_reflection.dart';
export 'journal_detail_emotional_landscape.dart';

// ─── Colors ─────────────────────────────────────────────────────────────────
const Color _cardBg = Color(0xFF131325);
const Color _borderColor = Color(0xFF252545);
const Color _labelText = Color(0xFF6666AA);
const Color _tagBg = Color(0xFF121226);
const Color _tagBorder = Color(0xFF252549);
const Color _tagText = Color(0xFF8888EE);

// Default care items mockup list
final List<Map<String, dynamic>> defaultCareItems = [
  {
    'icon': Icons.favorite_border_rounded,
    'iconColor': const Color(0xFF9988FF),
    'iconBg': const Color(0xFF1E1A3A),
    'title': 'Meditate',
    'subtitle': '5 min practice',
  },
  {
    'icon': Icons.directions_walk_rounded,
    'iconColor': const Color(0xFF22CCAA),
    'iconBg': const Color(0xFF0A2A22),
    'title': 'Walk',
    'subtitle': 'Get some air',
  },
  {
    'icon': Icons.menu_book_rounded,
    'iconColor': const Color(0xFFEEAA44),
    'iconBg': const Color(0xFF2A1E0A),
    'title': 'Journal',
    'subtitle': 'Write it down',
  },
  {
    'icon': Icons.coffee_rounded,
    'iconColor': const Color(0xFFEE6688),
    'iconBg': const Color(0xFF2A1020),
    'title': 'Relax',
    'subtitle': 'Take a break',
  },
];

// ─── Helpers ────────────────────────────────────────────────────────────────

Color getEmotionColor(String? name) {
  if (name == null) return const Color(0xFF7B6EF6);
  final n = name.toLowerCase();
  if (n.contains('anxi') ||
      n.contains('fear') ||
      n.contains('stress') ||
      n.contains('overwhelm')) {
    return const Color(0xFFEE4444);
  }
  if (n.contains('confus') || n.contains('doubt') || n.contains('puzzl')) {
    return const Color(0xFF7B6EF6);
  }
  if (n.contains('awe') || n.contains('wonder') || n.contains('amaz')) {
    return const Color(0xFF00CFFF);
  }
  if (n.contains('joy') ||
      n.contains('happ') ||
      n.contains('excit') ||
      n.contains('calm')) {
    return const Color(0xFF22CCAA);
  }
  if (n.contains('sad') || n.contains('grief') || n.contains('sorrow')) {
    return const Color(0xFF9988FF);
  }
  return const Color(0xFF7B6EF6);
}

Map<String, dynamic> getCareItemIconAndColors(String title) {
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
  } else if (t.contains('journ')) {
    return {
      'icon': Icons.menu_book_rounded,
      'iconColor': const Color(0xFFEEAA44),
      'iconBg': const Color(0xFF2A1E0A),
    };
  } else if (t.contains('relax')) {
    return {
      'icon': Icons.coffee_rounded,
      'iconColor': const Color(0xFFEE6688),
      'iconBg': const Color(0xFF2A1020),
    };
  }
  return {
    'icon': Icons.self_improvement_rounded,
    'iconColor': const Color(0xFF9988FF),
    'iconBg': const Color(0xFF1E1A3A),
  };
}

void shareInterpretation(
  BuildContext context, {
  required String title,
  required String subtitleText,
  required String summary,
  required String meaning,
  String? userResponse,
  required List<Map<String, dynamic>> emotions,
  required List<Map<String, dynamic>> careItems,
  required List<String> symbolTags,
}) {
  final buffer = StringBuffer();
  buffer.writeln('✨ Dream Interpretation: $title ✨');
  buffer.writeln('📅 $subtitleText');
  buffer.writeln();
  buffer.writeln('📝 Summary:');
  buffer.writeln(summary);
  buffer.writeln();
  buffer.writeln('💡 Meaning:');
  buffer.writeln(meaning);

  if (emotions.isNotEmpty) {
    buffer.writeln();
    buffer.writeln('📊 Emotional Landscape:');
    for (var emotion in emotions) {
      final label = emotion['label'] ?? '';
      final percent = emotion['percent'] ?? 0;
      if (label.isNotEmpty) {
        buffer.writeln('• $label: $percent%');
      }
    }
  }

  if (careItems.isNotEmpty) {
    buffer.writeln();
    buffer.writeln('🧘 Care & Reflection:');
    for (var care in careItems) {
      final t = care['title'] ?? '';
      final st = care['subtitle'] ?? '';
      if (t.isNotEmpty) {
        buffer.writeln(st.isNotEmpty ? '• $t ($st)' : '• $t');
      }
    }
  }

  if (symbolTags.isNotEmpty) {
    buffer.writeln();
    buffer.writeln('🏷️ Symbol Tags:');
    buffer.writeln(symbolTags.join(', '));
  }

  if (userResponse != null && userResponse.trim().isNotEmpty) {
    buffer.writeln();
    buffer.writeln('💭 My Response:');
    buffer.writeln(userResponse);
  }

  final box = context.findRenderObject() as RenderBox?;
  final sharePositionOrigin = box != null
      ? (box.localToGlobal(Offset.zero) & box.size)
      : null;

  SharePlus.instance.share(
    ShareParams(
      text: buffer.toString(),
      subject: 'Dream Interpretation: $title',
      sharePositionOrigin: sharePositionOrigin,
    ),
  );
}
// ─── Widgets ────────────────────────────────────────────────────────────────

class JournalDetailSymbolTags extends StatelessWidget {
  final List<String> symbolTags;

  const JournalDetailSymbolTags({super.key, required this.symbolTags});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SYMBOL TAGS',
          style: TextStyle(
            color: _labelText,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _borderColor, width: 1),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: symbolTags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: _tagBg,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: _tagBorder, width: 1),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      color: _tagText,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
