import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

const Color _fieldBg = Color(0xFF141B24);
const Color _borderColor = Color(0xFF252F3D);
const Color _accentPurpleLight = Color(0xFF9D7FF7);
const Color _mutedText = Color(0xFF8993A4);

class EditProfileNameField extends StatelessWidget {
  final TextEditingController controller;

  const EditProfileNameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FULL NAME',
          style: GoogleFonts.inter(
            color: _mutedText,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          height: 54.h,
          decoration: BoxDecoration(
            color: _fieldBg,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: _borderColor, width: 1),
          ),
          child: TextField(
            controller: controller,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
            ),
            cursorColor: _accentPurpleLight,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
              hintText: 'Enter your full name',
              hintStyle: GoogleFonts.inter(color: _mutedText, fontSize: 15.sp),
            ),
          ),
        ),
      ],
    );
  }
}
