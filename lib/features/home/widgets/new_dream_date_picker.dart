import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const Color _dateBg = Color(0xFF131325);
const Color _borderColor = Color(0xFF252545);
const Color _accentPurple = Color(0xFF7B6EF6);
const Color _white = Colors.white;

class NewDreamDatePicker extends StatelessWidget {
  const NewDreamDatePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentDate = DateFormat(
      'EEEE, MMMM d, yyyy',
    ).format(DateTime.now());

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _dateBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor, width: 1),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.calendar_today_rounded,
            color: _accentPurple,
            size: 16,
          ),
          const SizedBox(width: 10),
          Text(
            currentDate,
            style: const TextStyle(
              color: _white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
