import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomProfileAppBar extends StatelessWidget {
  final String title;
  final VoidCallback? onBackTap;
  final VoidCallback? onActionTap;
  final IconData actionIcon;
  final bool showBackButton;
  final bool showActionButton;

  const CustomProfileAppBar({
    super.key,
    required this.title,
    this.onBackTap,
    this.onActionTap,
    this.actionIcon = Icons.edit_outlined,
    this.showBackButton = true,
    this.showActionButton = true,
  });

  static const Color _cardBg = Color(0xFF111720);
  static const Color _dividerColor = Color(0xFF1E2730);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 16.h,
      ),
      child: Row(
        children: [
          /// Back Button
          showBackButton
              ? GestureDetector(
                  onTap: onBackTap ??
                      () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                  child: _iconContainer(
                    Icons.chevron_left_rounded,
                    24.sp,
                  ),
                )
              : SizedBox(width: 40.w),

          Expanded(
            child: Center(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          /// Action Button
          showActionButton
              ? GestureDetector(
                  onTap: onActionTap,
                  child: _iconContainer(
                    actionIcon,
                    20.sp,
                  ),
                )
              : SizedBox(width: 40.w),
        ],
      ),
    );
  }

  Widget _iconContainer(
    IconData icon,
    double iconSize,
  ) {
    return Container(
      width: 40.w,
      height: 40.h,
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: _dividerColor,
          width: 1,
        ),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: iconSize,
      ),
    );
  }
}