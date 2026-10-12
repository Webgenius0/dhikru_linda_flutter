import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dhikru_linda_flutter/helpers/all_routes.dart';
import 'package:dhikru_linda_flutter/helpers/navigation_service.dart';

class InsightsLockedView extends StatelessWidget {
  final String? customMessage;
  final VoidCallback? onRefresh;

  const InsightsLockedView({
    super.key,
    this.customMessage,
    this.onRefresh,
  });

  void _navigateToSubscription(BuildContext context) async {
    await NavigationService.navigateTo(Routes.subscriptionScreen);
    if (onRefresh != null) {
      onRefresh!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1E173D),
              Color(0xFF131127),
              Color(0xFF0D0A1C),
            ],
          ),
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(
            color: const Color(0xFF7B6EF6).withValues(alpha: 0.35),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7B6EF6).withValues(alpha: 0.16),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 22.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top Pill Badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7B6EF6), Color(0xFF9D7FF7)],
                ),
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7B6EF6).withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.workspace_premium_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'PREMIUM FEATURE',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Icon Avatar
            Container(
              width: 58.w,
              height: 58.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF9D7FF7).withValues(alpha: 0.28),
                    const Color(0xFF7B6EF6).withValues(alpha: 0.10),
                  ],
                ),
                border: Border.all(
                  color: const Color(0xFF9D7FF7).withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.insights_rounded,
                  color: Color(0xFFB4ACFF),
                  size: 28,
                ),
              ),
            ),

            SizedBox(height: 14.h),

            // Title
            Text(
              'Unlock Pattern & Symbol Insights',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18.5.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),

            SizedBox(height: 8.h),

            // Subtitle
            Text(
              customMessage ??
                  'Gain deep psychological clarity on your dreams, emotional trends, and recurring subconscious symbols.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: const Color(0xFFA5A5BA),
                fontSize: 12.5.sp,
                height: 1.45,
              ),
            ),

            SizedBox(height: 18.h),

            // Value Highlights
            _buildHighlightRow(
              icon: Icons.psychology_rounded,
              title: 'Recurring Symbol Detection',
              subtitle: 'Uncover subconscious archetypes & their meanings',
            ),
            SizedBox(height: 10.h),
            _buildHighlightRow(
              icon: Icons.show_chart_rounded,
              title: 'Mood & Emotional Trends',
              subtitle: 'Track subconscious emotional curves over time',
            ),
            SizedBox(height: 10.h),
            _buildHighlightRow(
              icon: Icons.pie_chart_outline_rounded,
              title: 'Dominant Theme Frequency',
              subtitle: 'Detect underlying dream patterns & triggers',
            ),
            SizedBox(height: 10.h),
            _buildHighlightRow(
              icon: Icons.auto_awesome_rounded,
              title: 'Subconscious Evolution Reports',
              subtitle: 'Personalized AI growth analytics & weekly summaries',
            ),

            SizedBox(height: 22.h),

            // Primary CTA Button
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: () => _navigateToSubscription(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B6EF6),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  shadowColor: const Color(0xFF7B6EF6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.lock_open_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8.w),
                    Flexible(
                      child: Text(
                        'Upgrade to Unlock Insights',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 8.h),

            Text(
              'Cancel anytime via Google Play Store subscriptions',
              style: GoogleFonts.inter(
                color: const Color(0xFF6E6E88),
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightRow({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32.w,
          height: 32.w,
          decoration: BoxDecoration(
            color: const Color(0xFF7B6EF6).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(9.r),
            border: Border.all(
              color: const Color(0xFF7B6EF6).withValues(alpha: 0.25),
              width: 0.8,
            ),
          ),
          child: Center(
            child: Icon(
              icon,
              color: const Color(0xFF9D7FF7),
              size: 16,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  color: const Color(0xFF8888A0),
                  fontSize: 11.5.sp,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
