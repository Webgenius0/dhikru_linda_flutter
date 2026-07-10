import 'package:flutter/material.dart';
import 'package:dhikru_linda_flutter/features/journal/model/new_journal_entry_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const Color _labelText = Color(0xFF6666AA);
const Color _cardBg = Color(0xFF131325);
const Color _borderColor = Color(0xFF252545);
const Color _tagBg = Color(0xFF121226);
const Color _tagBorder = Color(0xFF252549);
const Color _tagText = Color(0xFF8888EE);

class InterpretationSymbolTags extends StatelessWidget {
  final Data? dreamData;

  const InterpretationSymbolTags({super.key, this.dreamData});

  static const List<String> _defaultSymbolTags = [
    'Water',
    'Lost',
    'Empty City',
    'Purple Sky',
  ];

  @override
  Widget build(BuildContext context) {
    final hasData =
        dreamData?.symbolTags != null && dreamData!.symbolTags!.isNotEmpty;
    final List<String> tagsToShow = hasData
        ? dreamData!.symbolTags!
        : _defaultSymbolTags;

    if (tagsToShow.isEmpty) return const SizedBox.shrink();

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
          height: 200.h,
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
              children: tagsToShow.map((tag) {
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
