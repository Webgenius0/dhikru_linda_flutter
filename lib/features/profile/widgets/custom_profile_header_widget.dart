import 'dart:io';

import 'package:dhikru_linda_flutter/common_widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomProfileHeaderWidget extends StatelessWidget {
  final String name;
  final String email;
  final String gender;
  final int age;
  final String status;
  final File? imageFile;
  final String? imageUrl;

  const CustomProfileHeaderWidget({
    super.key,
    required this.name,
    required this.email,
    required this.gender,
    required this.age,
    required this.status,
    this.imageFile,
    this.imageUrl,
  });

  static const Color _bg = Color(0xFF0B0F14);
  static const Color _mutedText = Color(0xFF8993A4);
  static const Color _accentPurple = Color(0xFF7C5CF6);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10.h),

        // ── Glowing Profile Avatar ──
        Center(
          child: GestureDetector(
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _accentPurple.withOpacity(0.35),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ],
                gradient: const LinearGradient(
                  colors: [_accentPurple, Color(0xFF4A90E2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ProfileAvatar(
                radius: 54.r,
                imageFile: imageFile,
                imageUrl: imageUrl,
                borderColor: _bg,
                borderWidth: 3,
              ),
            ),
          ),
        ),

        SizedBox(height: 18.h),

        // ── Name ──
        Text(
          name,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),

        SizedBox(height: 6.h),

        // ── Email ──
        Text(
          email,
          style: GoogleFonts.inter(
            color: _mutedText,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),

        SizedBox(height: 8.h),

        // ── Details (Gender || Age : X || Status) ──
        Text(
          '$gender || Age : $age || $status',
          style: GoogleFonts.inter(
            color: _mutedText.withOpacity(0.85),
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
        ),

        SizedBox(height: 16.h),
      ],
    );
  }
}
