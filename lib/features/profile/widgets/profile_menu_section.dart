import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dhikru_linda_flutter/common_widgets/custom_delete_account_widget.dart';
import 'package:dhikru_linda_flutter/common_widgets/custom_logout_widget.dart';
import 'package:dhikru_linda_flutter/features/profile/presentation/change_password_screen.dart';
import 'package:dhikru_linda_flutter/features/profile/presentation/help_and_support_screen.dart';
import 'package:dhikru_linda_flutter/features/profile/presentation/privacy_policy_screen.dart';
import 'package:dhikru_linda_flutter/features/profile/presentation/terms_and_condition_screen.dart';

const Color _cardBg = Color(0xFF111720);
const Color _dividerColor = Color(0xFF1E2730);
const Color _mutedText = Color(0xFF8993A4);
const Color _redAccent = Color(0xFFFF4B4B);

class ProfileMenuSection extends StatelessWidget {
  const ProfileMenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: _dividerColor, width: 1),
        ),
        child: Column(
          children: [
            _buildMenuItem(
              icon: Icons.shield_outlined,
              iconColor: Colors.white70,
              label: 'Privacy Policy',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PrivacyPolicyScreen(),
                  ),
                );
              },
            ),
            _buildDivider(),

            _buildMenuItem(
              icon: Icons.article_outlined,
              iconColor: Colors.white70,
              label: 'Terms & Conditions',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TermsAndConditionScreen(),
                  ),
                );
              },
            ),
            _buildDivider(),

            _buildMenuItem(
              icon: Icons.help_outline_rounded,
              iconColor: Colors.white70,
              label: 'Help & Support',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HelpAndSupportScreen(),
                  ),
                );
              },
            ),
            _buildDivider(),

            _buildMenuItem(
              icon: Icons.lock_outline_rounded,
              iconColor: Colors.white70,
              label: 'Change Password',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ChangePasswordScreen(),
                  ),
                );
              },
            ),
            _buildDivider(),

            _buildMenuItem(
              icon: Icons.delete_outline_rounded,
              iconColor: Colors.white70,
              label: 'Delete Account',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => const CustomDeleteAccountWidget(),
                );
              },
            ),
            _buildDivider(),

            _buildMenuItem(
              icon: Icons.logout_rounded,
              iconColor: _redAccent,
              label: 'Sign Out',
              labelColor: _redAccent,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => const CustomLogoutWidget(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    String? subtitle,
    Color? subtitleColor,
    Color? labelColor,
    bool showArrow = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            Container(
              width: 38.w,
              height: 38.h,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20.sp),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      color: labelColor ?? Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        color: subtitleColor ?? _mutedText,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (showArrow)
              Icon(Icons.chevron_right_rounded, color: _mutedText, size: 20.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: _dividerColor,
      indent: 16.w,
      endIndent: 16.w,
    );
  }
}
