import 'package:flutter/material.dart';

const Color _white = Colors.white;
const Color _searchBg = Color(0xFF131325);
const Color _borderColor = Color(0xFF252545);
const Color _subtleText = Color(0xFF8888AA);

class JournalSearchBar extends StatelessWidget {
  final TextEditingController controller;

  const JournalSearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _searchBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor, width: 1),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: _white, fontSize: 14),
        cursorRadius: const Radius.circular(6),
        textAlignVertical: TextAlignVertical.center,
        decoration: const InputDecoration(
          hintText: 'Search dreams',
          hintStyle: TextStyle(color: _subtleText, fontSize: 14),
          prefixIcon: Icon(Icons.search_rounded, color: _subtleText, size: 20),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 13),
        ),
      ),
    );
  }
}
