import 'package:flutter/material.dart';

const Color _inputBg = Color(0xFF131325);
const Color _borderColor = Color(0xFF252545);
const Color _white = Colors.white;
const Color _subtleText = Color(0xFF8888AA);
const Color _labelText = Color(0xFF6666AA);

class NewDreamTitleField extends StatelessWidget {
  final TextEditingController controller;

  const NewDreamTitleField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'DREAM TITLE',
          style: TextStyle(
            color: _labelText,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: _inputBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _borderColor, width: 1),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(color: _white, fontSize: 14),
            decoration: const InputDecoration(
              hintText: 'Give your dream a name...',
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
