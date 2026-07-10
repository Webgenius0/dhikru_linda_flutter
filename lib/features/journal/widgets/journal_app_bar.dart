import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const Color _white = Colors.white;
const Color _cardBg = Color(0xFF131325);
const Color _borderColor = Color(0xFF252545);

class JournalAppBar extends StatelessWidget {
  final VoidCallback? onGoHome;

  const JournalAppBar({super.key, this.onGoHome});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            if (onGoHome != null) {
              onGoHome!();
            } else if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          child: Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: _cardBg,
              shape: BoxShape.circle,
              border: Border.all(color: _borderColor, width: 1),
            ),
            child: const Icon(
              Icons.chevron_left_rounded,
              color: _white,
              size: 22,
            ),
          ),
        ),
        const SizedBox(width: 14),
        const Text(
          'Journal',
          style: TextStyle(
            color: _white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }
}
