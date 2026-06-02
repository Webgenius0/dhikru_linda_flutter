// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:dhikru_linda_flutter/common_widgets/custom_delete_account_widget.dart';
import 'package:dhikru_linda_flutter/common_widgets/custom_logout_widget.dart';
import 'package:dhikru_linda_flutter/features/profile/presentation/edit_profile_screen.dart';
import 'package:dhikru_linda_flutter/features/profile/widgets/custom_app_version_footer.dart';
import 'package:dhikru_linda_flutter/features/profile/widgets/custom_profile_appbar_widget.dart';
import 'package:dhikru_linda_flutter/features/profile/widgets/custom_profile_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onGoHome;

  const ProfileScreen({super.key, this.onGoHome});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ── Placeholder user data (replace with real model / provider later) ──
  String _name = 'Sarah Jenkins';
  String _email = 'sarah.dreams@example.com';
  String _gender = 'Female';
  int _age = 25;
  String _status = 'Single';
  final String _tier = 'Dreamer Tier';
  final bool _isPremium = false;
  File? _imageFile;
  String? _imageUrl;

  // ── Colors ──
  static const _bg = Color(0xFF0B0F14);
  static const _cardBg = Color(0xFF111720);
  static const _dividerColor = Color(0xFF1E2730);
  static const _mutedText = Color(0xFF8993A4);
  static const _accentPurple = Color(0xFF7C5CF6);
  static const _accentPurpleLight = Color(0xFF9D7FF7);
  static const _redAccent = Color(0xFFFF4B4B);

  Future<void> _navigateToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(
          name: _name,
          email: _email,
          gender: _gender,
          age: _age,
          status: _status,
          imageUrl: _imageUrl,
        ),
      ),
    );
    if (result != null && result is Map && mounted) {
      setState(() {
        _name = result['name'] as String? ?? _name;
        _gender = result['gender'] as String? ?? _gender;
        _age = result['age'] as int? ?? _age;
        _status = result['status'] as String? ?? _status;
        _imageFile = result['imageFile'] as File? ?? _imageFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── App Bar ──
            SliverToBoxAdapter(
              child: CustomProfileAppBar(
                title: 'Profile',
                onBackTap: () {
                  if (widget.onGoHome != null) {
                    widget.onGoHome!();
                  } else if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                onActionTap: _navigateToEditProfile,
                actionIcon: Icons.edit_outlined,
                showBackButton: true,
                showActionButton: true,
              ),
            ),

            // ── Avatar + User Info ──
            SliverToBoxAdapter(
              child: CustomProfileHeaderWidget(
                name: _name,
                email: _email,
                gender: _gender,
                age: _age,
                status: _status,
                imageFile: _imageFile,
                imageUrl: _imageUrl,
                onEditTap: _navigateToEditProfile,
              ),
            ),

            // ── Tier Badge ──
            SliverToBoxAdapter(child: _buildTierBadge()),

            SliverToBoxAdapter(child: SizedBox(height: 24.h)),

            // ── Premium Card ──
            if (!_isPremium)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: _buildPremiumCard(),
                ),
              ),

            SliverToBoxAdapter(child: SizedBox(height: 28.h)),

            // ── Account & Data Section ──
            SliverToBoxAdapter(child: _buildSectionLabel('ACCOUNT & DATA')),
            SliverToBoxAdapter(child: SizedBox(height: 12.h)),
            SliverToBoxAdapter(child: _buildMenuSection()),

            // ── Version Footer ──
            SliverToBoxAdapter(
              child: AppVersionFooter(version: 'DreamTrace App v1.0.4'),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 15.h)),
          ],
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────
  //  Tier Badge
  // ────────────────────────────────────────────────
  Widget _buildTierBadge() {
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
                    text: '$_tier ',
                    style: const TextStyle(color: Colors.white),
                  ),
                  TextSpan(
                    text: _isPremium ? '(Pro)' : '(Free)',
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

  // ────────────────────────────────────────────────
  //  Premium Upgrade Card
  // ────────────────────────────────────────────────
  Widget _buildPremiumCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF1E1446), Color(0xFF120B2E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C5CF6).withOpacity(0.12),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
        border: Border.all(color: _accentPurple.withOpacity(0.25), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                color: _accentPurpleLight,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Unlock Premium Insights',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          // Description
          Text(
            'Get unlimited AI interpretations, deep symbol analysis, and weekly pattern reports.',
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.65),
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
          SizedBox(height: 18.h),

          // CTA Button
          GestureDetector(
            onTap: () {
              // TODO: navigate to premium/subscription screen
            },
            child: Container(
              width: double.infinity,
              height: 48.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.r),
                gradient: const LinearGradient(
                  colors: [Color(0xFF9D7FF7), _accentPurple],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _accentPurple.withOpacity(0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                'Upgrade to Premium',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────
  //  Section Label
  // ────────────────────────────────────────────────
  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: _mutedText,
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────
  //  Menu Section
  // ────────────────────────────────────────────────
  Widget _buildMenuSection() {
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
            // Privacy & Security
            _buildMenuItem(
              icon: Icons.shield_outlined,
              iconColor: const Color(0xFF2DD4BF),
              label: 'Privacy & Security',
              subtitle: 'Your dreams are securely encrypted',
              subtitleColor: const Color(0xFF2DD4BF),
              showArrow: true,
              onTap: () {
                // TODO: navigate to privacy & security
              },
            ),
            _buildDivider(),

            // Help & Support
            _buildMenuItem(
              icon: Icons.help_outline_rounded,
              iconColor: Colors.white70,
              label: 'Help & Support',
              onTap: () {
                // TODO: navigate to help & support
              },
            ),
            _buildDivider(),

            // Delete Account
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

            // Sign Out
            _buildMenuItem(
              icon: Icons.logout_rounded,
              iconColor: _redAccent,
              label: 'Sign Out',
              labelColor: _redAccent,
              showDivider: false,
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
    bool showDivider = true,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            // Icon container (Circular to match premium mockup)
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

            // Label + optional subtitle
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
