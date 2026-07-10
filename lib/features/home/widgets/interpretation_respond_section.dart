import 'package:flutter/material.dart';

const Color _labelText = Color(0xFF6666AA);
const Color _cardBg = Color(0xFF131325);
const Color _borderColor = Color(0xFF252545);
const Color _white = Colors.white;
const Color _subtleText = Color(0xFF8888AA);

class InterpretationRespondSection extends StatelessWidget {
  final TextEditingController controller;

  const InterpretationRespondSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'YOUR RESPOND',
          style: TextStyle(
            color: _labelText,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _borderColor, width: 1),
          ),
          child: TextField(
            controller: controller,
            maxLines: 3,
            style: const TextStyle(color: _white, fontSize: 14, height: 1.5),
            cursorRadius: const Radius.circular(6),
            decoration: const InputDecoration(
              hintText: 'Write your respond ...',
              hintStyle: TextStyle(color: _subtleText, fontSize: 14),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
