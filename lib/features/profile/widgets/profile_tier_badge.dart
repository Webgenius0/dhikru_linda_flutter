import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

const Color _cardBg = Color(0xFF111720);
const Color _dividerColor = Color(0xFF1E2730);
const Color _mutedText = Color(0xFF8993A4);

class ProfileTierBadge extends StatelessWidget {
  final String tier;
  final bool isPremium;

  const ProfileTierBadge({
    super.key,
    required this.tier,
    required this.isPremium,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(color: _dividerColor, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.star_border_rounded,
              color: const Color(0xFF2DD4BF),
              size: 18.sp,
            ),
            SizedBox(width: 8.w),
            RichText(
              text: TextSpan(
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  TextSpan(
                    text: '$tier ',
                    style: const TextStyle(color: Colors.white),
                  ),
                  TextSpan(
                    text: isPremium ? '(Pro)' : '(Free)',
                    style: TextStyle(color: _mutedText.withOpacity(0.7)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
