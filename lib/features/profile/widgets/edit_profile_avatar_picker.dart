import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dhikru_linda_flutter/common_widgets/profile_avatar.dart';

const Color _accentPurple = Color(0xFF7C5CF6);
const Color _accentPurpleLight = Color(0xFF9D7FF7);
const Color _bg = Color(0xFF0B0F14);

class EditProfileAvatarPicker extends StatelessWidget {
  final File? pickedImage;
  final String? imageUrl;
  final VoidCallback onTap;

  const EditProfileAvatarPicker({
    super.key,
    this.pickedImage,
    this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: GestureDetector(
            onTap: onTap,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [_accentPurple, Color(0xFF4A90E2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: ProfileAvatar(
                    radius: 50.r,
                    imageFile: pickedImage,
                    imageUrl: imageUrl,
                    borderColor: _bg,
                    borderWidth: 3,
                  ),
                ),
                Container(
                  width: 32.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: _accentPurple,
                    shape: BoxShape.circle,
                    border: Border.all(color: _bg, width: 2.5),
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: 15.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h),
        GestureDetector(
          onTap: onTap,
          child: Text(
            'Change Photo',
            style: GoogleFonts.inter(
              color: _accentPurpleLight,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
