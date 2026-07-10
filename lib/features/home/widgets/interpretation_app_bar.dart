import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const Color _cardBg = Color(0xFF131325);
const Color _borderColor = Color(0xFF252545);
const Color _white = Colors.white;

class InterpretationAppBar extends StatelessWidget {
  final VoidCallback onBackTap;
  final VoidCallback onShareTap;

  const InterpretationAppBar({
    super.key,
    required this.onBackTap,
    required this.onShareTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: onBackTap,
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
              'Interpretation',
              style: TextStyle(
                color: _white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onShareTap,
          child: Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: _cardBg,
              shape: BoxShape.circle,
              border: Border.all(color: _borderColor, width: 1),
            ),
            child: const Icon(Icons.share, color: _white, size: 16),
          ),
        ),
      ],
    );
  }
}
