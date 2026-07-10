import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:dhikru_linda_flutter/features/insights/model/insight_data_model.dart';

const Color _cardBg = Color(0xFF111720);
const Color _dividerColor = Color(0xFF1E2730);
const Color _white = Colors.white;
const Color _mutedText = Color(0xFF8993A4);
const Color _accentTeal = Color(0xFF2DD4BF);
const Color _accentPurple = Color(0xFF7C5CF6);

class InsightsThemeFrequencyCard extends StatelessWidget {
  final ThemeFrequency? themeFrequency;

  const InsightsThemeFrequencyCard({super.key, this.themeFrequency});

  @override
  Widget build(BuildContext context) {
    final themeData = themeFrequency?.data ?? [];

    int maxVal = 40;
    for (var item in themeData) {
      if (item.percentage != null && item.percentage! > maxVal) {
        maxVal = item.percentage!;
      }
    }
    if (maxVal % 10 != 0) {
      maxVal = ((maxVal / 10).ceil() * 10);
    }
    if (maxVal == 0) maxVal = 40;

    final yLabels = [
      maxVal.toString(),
      (maxVal * 0.75).round().toString(),
      (maxVal * 0.5).round().toString(),
      (maxVal * 0.25).round().toString(),
      '0',
    ];

    final List<double> barPercentages = themeData.isEmpty
        ? [1.0, 0.75, 0.375, 0.25, 0.125]
        : themeData.map((e) => (e.percentage ?? 0) / maxVal).toList();
    final List<String> barLabels = themeData.isEmpty
        ? ['Fear', 'Growth', 'Joy', 'Calm', 'Other']
        : themeData.map((e) => e.name ?? '').toList();

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
          Text(
            'Theme Frequency',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 24.h),

          SizedBox(
            height: 180.h,
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: yLabels
                      .map(
                        (val) => SizedBox(
                          width: 24.w,
                          child: Text(
                            val,
                            textAlign: TextAlign.right,
                            style: GoogleFonts.inter(
                              color: _mutedText.withOpacity(0.6),
                              fontSize: 11.sp,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: CustomPaint(
                                painter: _BarChartGridPainter(
                                  gridColor: _dividerColor,
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: List.generate(barPercentages.length, (
                                  index,
                                ) {
                                  return Expanded(
                                    child: FractionallySizedBox(
                                      heightFactor: barPercentages[index],
                                      child: Center(
                                        child: Container(
                                          width: 28.w,
                                          constraints: BoxConstraints(
                                            maxWidth: 28.w,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(8.r),
                                            ),
                                            gradient: const LinearGradient(
                                              colors: [
                                                _accentTeal,
                                                _accentPurple,
                                              ],
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: barLabels
                            .map(
                              (label) => Expanded(
                                child: Text(
                                  label,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    color: _mutedText.withOpacity(0.6),
                                    fontSize: 11.sp,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          if (themeFrequency?.dominantThemeLabel != null &&
              themeFrequency!.dominantThemeLabel!.isNotEmpty) ...[
            Text(
              'Most common theme',
              style: GoogleFonts.inter(
                color: _mutedText.withOpacity(0.6),
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 6.h),
            Row(
              children: [
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: const BoxDecoration(
                    color: _accentPurple,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  themeFrequency!.dominantThemeLabel!,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class InsightsShimmerThemeFrequencyCard extends StatelessWidget {
  const InsightsShimmerThemeFrequencyCard({super.key});

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
            Container(
              width: 140.w,
              height: 16.h,
              decoration: BoxDecoration(
                color: _white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(height: 24.h),
            Container(
              height: 180.h,
              decoration: BoxDecoration(
                color: _white,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              width: 100.w,
              height: 12.h,
              decoration: BoxDecoration(
                color: _white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(height: 6.h),
            Container(
              width: 80.w,
              height: 14.h,
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

class _BarChartGridPainter extends CustomPainter {
  final Color gridColor;

  _BarChartGridPainter({required this.gridColor});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final Paint gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (int i = 0; i <= 4; i++) {
      final double yPos = h * (i / 4);
      canvas.drawLine(Offset(0, yPos), Offset(w, yPos), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartGridPainter oldDelegate) => false;
}
