import 'dart:io';

import 'package:dhikru_linda_flutter/common_widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class CustomProfileHeaderWidget extends StatelessWidget {
  final String? name;
  final String? email;
  final String? gender;
  final dynamic age;
  final String? status;
  final File? imageFile;
  final String? imageUrl;
  final bool isLoading;

  const CustomProfileHeaderWidget({
    super.key,
    this.name,
    this.email,
    this.gender,
    this.age,
    this.status,
    this.imageFile,
    this.imageUrl,
    this.isLoading = false,
  });

  static const Color _bg = Color(0xFF0B0F14);
  static const Color _mutedText = Color(0xFF8993A4);
  static const Color _accentPurple = Color(0xFF7C5CF6);

  String _formatGender(String? val) {
    if (val == null) return '';
    final v = val.toLowerCase().trim();
    if (v == 'male') return 'Male';
    if (v == 'female') return 'Female';
    return val;
  }

  String _formatStatus(String? val) {
    if (val == null) return '';
    final v = val.toLowerCase().trim().replaceAll('_', ' ');
    if (v == 'single') return 'Single';
    if (v == 'married') return 'Married';
    if (v == 'divorced') return 'Divorced';
    if (v == 'prefer not to say') return 'Prefer not to say';
    return v
        .split(' ')
        .map(
          (word) => word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1)}'
              : '',
        )
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final List<String> parts = [];
    if (gender != null &&
        gender.toString().trim().isNotEmpty &&
        gender.toString().trim().toLowerCase() != 'null') {
      parts.add('Gender: ${_formatGender(gender)}');
    }
    if (age != null &&
        age.toString().trim().isNotEmpty &&
        age.toString().trim().toLowerCase() != 'null') {
      parts.add('Age : $age');
    }
    if (status != null &&
        status.toString().trim().isNotEmpty &&
        status.toString().trim().toLowerCase() != 'null') {
      parts.add('Marital Status: ${_formatStatus(status)}');
    }
    final detailsText = parts.join(' || ');

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
              child: isLoading
                  ? Shimmer.fromColors(
                      baseColor: Colors.white.withOpacity(0.05),
                      highlightColor: Colors.white.withOpacity(0.1),
                      child: Container(
                        width: 108.r,
                        height: 108.r,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : ProfileAvatar(
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
        isLoading
            ? Shimmer.fromColors(
                baseColor: Colors.white.withOpacity(0.05),
                highlightColor: Colors.white.withOpacity(0.1),
                child: Container(
                  width: 160.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Text(
                    name ?? '',
                    maxLines: 1,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ),

        SizedBox(height: 6.h),

        // ── Email ──
        isLoading
            ? Shimmer.fromColors(
                baseColor: Colors.white.withOpacity(0.05),
                highlightColor: Colors.white.withOpacity(0.1),
                child: Container(
                  width: 200.w,
                  height: 14.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              )
            : Text(
                email ?? '',
                style: GoogleFonts.inter(
                  color: _mutedText,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),

        if (isLoading || detailsText.isNotEmpty) ...[
          SizedBox(height: 8.h),
          isLoading
              ? Shimmer.fromColors(
                  baseColor: Colors.white.withOpacity(0.05),
                  highlightColor: Colors.white.withOpacity(0.1),
                  child: Container(
                    width: 180.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                )
              : Text(
                  detailsText,
                  style: GoogleFonts.inter(
                    color: _mutedText.withOpacity(0.85),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ],

        SizedBox(height: 16.h),
      ],
    );
  }
}
