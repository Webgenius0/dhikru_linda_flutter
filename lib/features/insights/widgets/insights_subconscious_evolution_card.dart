import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:dhikru_linda_flutter/features/insights/model/insight_data_model.dart';

const Color _cardBg = Color(0xFF111720);
const Color _dividerColor = Color(0xFF1E2730);
const Color _white = Colors.white;
const Color _mutedText = Color(0xFF8993A4);
const Color _accentPurple = Color(0xFF7C5CF6);
const Color _accentPurpleLight = Color(0xFF9D7FF7);
const Color _accentTeal = Color(0xFF2DD4BF);

class InsightsSubconsciousEvolutionCard extends StatelessWidget {
  final SubconsciousEvolution? evolution;

  const InsightsSubconsciousEvolutionCard({super.key, this.evolution});

  @override
  Widget build(BuildContext context) {
    final title = evolution?.title ?? 'Subconscious Evolution';
    final timeframe = evolution?.timeframe ?? '7 Days';
    final description = evolution?.description ?? '';
    final intensityScore = evolution?.intensityScore ?? 0.0;
    final intensityLabel =
        evolution?.intensityLabel ?? 'Emotional Intensity Score';
    final progressValue = (intensityScore / 10.0).clamp(0.0, 1.0);

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: _dividerColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _accentPurple.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  timeframe,
                  style: GoogleFonts.inter(
                    color: _accentPurpleLight,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Text(
            description,
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.7),
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: LinearProgressIndicator(
                    value: progressValue,
                    minHeight: 6.h,
                    backgroundColor: _dividerColor,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      _accentTeal,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 14.w),
              Text(
                '$intensityScore/10',
                style: GoogleFonts.inter(
                  color: _accentTeal,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            intensityLabel,
            style: GoogleFonts.inter(
              color: _mutedText.withOpacity(0.6),
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class InsightsShimmerSubconsciousEvolutionCard extends StatelessWidget {
  const InsightsShimmerSubconsciousEvolutionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.05),
      highlightColor: Colors.white.withOpacity(0.1),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: _dividerColor, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 160.w,
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: _white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                Container(
                  width: 50.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: _white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            Container(
              width: double.infinity,
              height: 40.h,
              decoration: BoxDecoration(
                color: _white,
                borderRadius: BorderRadius.circular(6.r),
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: _white,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                Container(
                  width: 40.w,
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: _white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Container(
              width: 150.w,
              height: 11.h,
              decoration: BoxDecoration(
                color: _white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
