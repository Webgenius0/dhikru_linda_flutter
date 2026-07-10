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

class InsightsMoodTrendCard extends StatelessWidget {
  final MoodTrend? moodTrend;

  const InsightsMoodTrendCard({super.key, this.moodTrend});

  @override
  Widget build(BuildContext context) {
    final hasData = moodTrend?.data != null && moodTrend!.data!.isNotEmpty;
    final pointsYPercentage = hasData
        ? moodTrend!.data!.map((x) => (x.score ?? 0) / 100.0).toList()
        : <double>[];
    final days = hasData
        ? moodTrend!.data!.map((x) => x.day ?? '').toList()
        : ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

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
            'Mood Trend',
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
                  children: ['100', '75', '50', '25', '0']
                      .map(
                        (val) => SizedBox(
                          width: 28.w,
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
                        child: CustomPaint(
                          size: Size.infinite,
                          painter: _MoodTrendLinePainter(
                            pointsYPercentage: pointsYPercentage,
                            lineColor: _accentTeal,
                            gridColor: _dividerColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: days
                            .map(
                              (day) => Expanded(
                                child: Text(
                                  day,
                                  textAlign: TextAlign.center,
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
          SizedBox(height: 18.h),
          Text(
            moodTrend?.description ?? '',
            style: GoogleFonts.inter(
              color: _mutedText,
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class InsightsShimmerMoodTrendCard extends StatelessWidget {
  const InsightsShimmerMoodTrendCard({super.key});

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
              width: 120.w,
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
            SizedBox(height: 18.h),
            Container(
              width: 220.w,
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

class _MoodTrendLinePainter extends CustomPainter {
  final List<double> pointsYPercentage;
  final Color lineColor;
  final Color gridColor;

  _MoodTrendLinePainter({
    required this.pointsYPercentage,
    required this.lineColor,
    required this.gridColor,
  });

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

    if (pointsYPercentage.length < 2) return;

    final double stepX = w / (pointsYPercentage.length - 1);
    final List<Offset> points = [];

    for (int i = 0; i < pointsYPercentage.length; i++) {
      final double x = i * stepX;
      final double y = h - (h * pointsYPercentage[i]);
      points.add(Offset(x, y));
    }

    final Paint lineShadowPaint = Paint()
      ..color = lineColor.withOpacity(0.35)
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    final Path curvePath = Path();
    curvePath.moveTo(points[0].dx, points[0].dy);
    for (int i = 0; i < points.length - 1; i++) {
      final Offset p0 = points[i];
      final Offset p1 = points[i + 1];
      final double controlX = (p0.dx + p1.dx) / 2;
      curvePath.cubicTo(controlX, p0.dy, controlX, p1.dy, p1.dx, p1.dy);
    }

    canvas.drawPath(curvePath, lineShadowPaint);

    final Paint linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(curvePath, linePaint);

    final Paint pointOutlinePaint = Paint()
      ..color = const Color(0xFF111720)
      ..style = PaintingStyle.fill;

    final Paint pointInnerPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    for (final pt in points) {
      canvas.drawCircle(pt, 6, pointInnerPaint);
      canvas.drawCircle(pt, 3, pointOutlinePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _MoodTrendLinePainter oldDelegate) =>
      oldDelegate.pointsYPercentage != pointsYPercentage;
}
