import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppVersionFooter extends StatelessWidget {
  final String version;
  final Color textColor;
  final double? fontSize;

  const AppVersionFooter({
    super.key,
    required this.version,
    this.textColor = const Color(0xFF8993A4),
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 28.h,
        bottom: 8.h,
      ),
      child: Center(
        child: Text(
          version,
          style: GoogleFonts.inter(
            color: textColor.withOpacity(0.5),
            fontSize: fontSize ?? 12.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}