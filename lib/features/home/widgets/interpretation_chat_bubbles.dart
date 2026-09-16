import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:dhikru_linda_flutter/features/journal/model/send_journal_message_model.dart';

const Color _cardBg = Color(0xFF131325);
const Color _borderColor = Color(0xFF252545);
const Color _accentPurple = Color(0xFF7B6EF6);
const Color _aiCardBg = Color(0xFF181733);
const Color _aiBorderColor = Color(0xFF383568);

class InterpretationChatBubbles extends StatelessWidget {
  final List<ChatMessage> messages;

  const InterpretationChatBubbles({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CONVERSATION',
          style: TextStyle(
            color: Color(0xFF6666AA),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(height: 12),
        ...messages.map((msg) => _buildMessageItem(msg)),
      ],
    );
  }

  Widget _buildMessageItem(ChatMessage msg) {
    final isAi = msg.sender == 'ai';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isAi ? _aiCardBg : _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isAi ? _aiBorderColor : _borderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color:
                      isAi
                          ? _accentPurple.withValues(alpha: 0.2)
                          : Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isAi ? Icons.auto_awesome : Icons.person_outline_rounded,
                  size: 14,
                  color: isAi ? const Color(0xFFB4ACFF) : Colors.white70,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                isAi ? 'AI INSIGHT' : 'YOU',
                style: TextStyle(
                  color:
                      isAi ? const Color(0xFFB4ACFF) : const Color(0xFF8888AA),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          MarkdownBody(
            data: msg.message ?? '',
            selectable: false,
            styleSheet: MarkdownStyleSheet(
              p: TextStyle(
                color: isAi ? const Color(0xFFE8E8F5) : Colors.white,
                fontSize: 14,
                height: 1.5,
              ),
              strong: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              em: TextStyle(
                color: isAi ? const Color(0xFFE8E8F5) : Colors.white,
                fontStyle: FontStyle.italic,
                fontSize: 14,
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
                fontSize: 14.5,
                fontWeight: FontWeight.bold,
              ),
              listBullet: TextStyle(
                color: isAi ? const Color(0xFFE8E8F5) : Colors.white,
                fontSize: 14,
              ),
              blockSpacing: 8.0,
            ),
          ),
        ],
      ),
    );
  }
}
