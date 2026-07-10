import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const Color _cardBg = Color(0xFF111720);
const Color _borderColor = Color(0xFF252545);
const Color _white = Colors.white;

class ProfileAppBar extends StatelessWidget {
  final VoidCallback? onGoHome;
  final VoidCallback onEditProfileTap;

  const ProfileAppBar({
    super.key,
    this.onGoHome,
    required this.onEditProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: statusBarHeight + 16,
        bottom: 16,
      ),
      child: Row(
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
            'Profile',
            style: TextStyle(
              color: _white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onEditProfileTap,
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: _cardBg,
                shape: BoxShape.circle,
                border: Border.all(color: _borderColor, width: 1),
              ),
              child: const Icon(Icons.edit_outlined, color: _white, size: 15),
            ),
          ),
        ],
      ),
    );
  }
}
