import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:dhikru_linda_flutter/features/journal/model/send_journal_message_model.dart';
import 'package:dhikru_linda_flutter/helpers/toast.dart';
import 'package:intl/intl.dart';

const Color _cardBg = Color(0xFF131325);
const Color _borderColor = Color(0xFF252545);
const Color _accentPurple = Color(0xFF7B6EF6);
const Color _aiCardBg = Color(0xFF181733);
const Color _aiBorderColor = Color(0xFF383568);

class InterpretationChatBubbles extends StatelessWidget {
  final List<ChatMessage> messages;
  final bool isAiThinking;

  const InterpretationChatBubbles({
    super.key,
    required this.messages,
    this.isAiThinking = false,
  });

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty && !isAiThinking) return const SizedBox.shrink();

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
        ...messages.map((msg) => _buildMessageItem(context, msg)),
        if (isAiThinking) _buildAiThinkingItem(),
      ],
    );
  }

  Widget _buildMessageItem(BuildContext context, ChatMessage msg) {
    final isAi = msg.sender?.toLowerCase() != 'user';
    final messageText = msg.message?.trim() ?? '';
    if (messageText.isEmpty) return const SizedBox.shrink();

    String formattedTime = '';
    if (msg.createdAt != null) {
      try {
        formattedTime = DateFormat('h:mm a').format(msg.createdAt!.toLocal());
      } catch (_) {}
    }

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
                  color: isAi
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
                  color: isAi
                      ? const Color(0xFFB4ACFF)
                      : const Color(0xFF8888AA),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              if (formattedTime.isNotEmpty) ...[
                const SizedBox(width: 8),
                Text(
                  '• $formattedTime',
                  style: const TextStyle(
                    color: Color(0xFF555577),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              const Spacer(),
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: messageText));
                  ToastUtil.showShortToast('Copied to clipboard');
                },
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.copy_rounded,
                    size: 14,
                    color: isAi
                        ? const Color(0xFF8888AA)
                        : const Color(0xFF666688),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          MarkdownBody(
            data: messageText,
            selectable: true,
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
              code: const TextStyle(
                color: Color(0xFFB4ACFF),
                backgroundColor: Color(0xFF0F0E20),
                fontSize: 13,
                fontFamily: 'monospace',
              ),
              codeblockDecoration: BoxDecoration(
                color: const Color(0xFF0F0E20),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF252545)),
              ),
              blockquote: const TextStyle(
                color: Color(0xFFB4ACFF),
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
              blockquoteDecoration: BoxDecoration(
                color: const Color(0xFF1E1D3A),
                borderRadius: BorderRadius.circular(6),
                border: const Border(
                  left: BorderSide(color: _accentPurple, width: 3),
                ),
              ),
              blockSpacing: 8.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiThinkingItem() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _aiCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _aiBorderColor, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: _accentPurple.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              size: 14,
              color: Color(0xFFB4ACFF),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'AI is reflecting...',
            style: TextStyle(
              color: Color(0xFFB4ACFF),
              fontSize: 13,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(width: 12),
          const SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB4ACFF)),
            ),
          ),
        ],
      ),
    );
  }
}
