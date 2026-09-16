import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

const Color _cardBg = Color(0xFF131325);
const Color _borderColor = Color(0xFF252545);
const Color _accentPurple = Color(0xFF7B6EF6);
const Color _white = Colors.white;

class JournalDetailTextCard extends StatelessWidget {
  final IconData? icon;
  final Color? iconColor;
  final String title;
  final String body;

  const JournalDetailTextCard({
    super.key,
    this.icon,
    this.iconColor,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: _cardBg.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: iconColor ?? _accentPurple, size: 18),
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: const TextStyle(
                  color: _white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          MarkdownBody(
            data: body,
            selectable: false,
            styleSheet: MarkdownStyleSheet(
              p: const TextStyle(
                color: Color(0xFFAAAAAC),
                fontSize: 13.5,
                height: 1.6,
                letterSpacing: 0.1,
              ),
              strong: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13.5,
                letterSpacing: 0.1,
              ),
              em: const TextStyle(
                color: Color(0xFFAAAAAC),
                fontStyle: FontStyle.italic,
                fontSize: 13.5,
              ),
              h1: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              h2: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              h3: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              listBullet: const TextStyle(
                color: Color(0xFFAAAAAC),
                fontSize: 13.5,
              ),
              blockSpacing: 10.0,
            ),
          ),
        ],
      ),
    );
  }
}
