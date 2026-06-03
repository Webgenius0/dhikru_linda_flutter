import 'package:dhikru_linda_flutter/features/profile/widgets/custom_profile_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class InsightsScreen extends StatefulWidget {
  final VoidCallback? onGoHome;

  const InsightsScreen({super.key, this.onGoHome});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  // ── Colors ──
  static const Color _white = Colors.white;
  static const Color _borderColor = Color(0xFF252545);
  static const _bg = Color(0xFF0B0F14);
  static const _cardBg = Color(0xFF111720);
  static const _dividerColor = Color(0xFF1E2730);
  static const _mutedText = Color(0xFF8993A4);
  static const _accentPurple = Color(0xFF7C5CF6);
  static const _accentPurpleLight = Color(0xFF9D7FF7);
  static const _accentTeal = Color(0xFF2DD4BF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── App Bar ──
            SliverToBoxAdapter(child: _buildAppBar(context)),

            // ── Mood Trend Card ──
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: _buildMoodTrendCard(),
              ),
            ),

            // ── Theme Frequency Card ──
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: _buildThemeFrequencyCard(),
              ),
            ),

            // ── Recurring Symbols Section ──
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                  top: 20.h,
                  bottom: 8.h,
                ),
                child: Text(
                  'RECURRING SYMBOLS',
                  style: GoogleFonts.inter(
                    color: _mutedText,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: _buildRecurringSymbols(),
              ),
            ),

            // ── Subconscious Evolution Card ──
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: _buildSubconsciousEvolutionCard(),
              ),
            ),

            // ── Unlock Premium Insights Card ──
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: _buildPremiumCard(),
              ),
            ),

            // Padding at the bottom of the scroll list
            SliverToBoxAdapter(child: SizedBox(height: 10.h)),
          ],
        ),
      ),
    );
  }

  // ─── App Bar ─────────────────────────────────────────────────────────────────

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (widget.onGoHome != null) {
                widget.onGoHome!();
              } else if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            child: Container(
              width: 34,
              height: 34,
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
            'Insights',
            style: TextStyle(
              color: _white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────
  //  Mood Trend Card Widget
  // ────────────────────────────────────────────────
  Widget _buildMoodTrendCard() {
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

          // Hybrid Line Chart
          SizedBox(
            height: 180.h,
            child: Row(
              children: [
                // Y-axis labels
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

                // Chart Grid & Line CustomPaint
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: CustomPaint(
                          size: Size.infinite,
                          painter: _MoodTrendLinePainter(
                            pointsYPercentage: [
                              0.65,
                              0.70,
                              0.55,
                              0.80,
                              0.75,
                              0.85,
                              0.90,
                            ],
                            lineColor: _accentTeal,
                            gridColor: _dividerColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),

                      // X-axis labels
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:
                            ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
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
            'Your mood has improved by 38% this week',
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

  // ────────────────────────────────────────────────
  //  Theme Frequency Card Widget
  // ────────────────────────────────────────────────
  Widget _buildThemeFrequencyCard() {
    final List<double> barPercentages = [1.0, 0.75, 0.375, 0.25, 0.125];
    final List<String> barLabels = ['Fear', 'Growth', 'Joy', 'Calm', 'Other'];

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

          // Custom Bar Chart
          SizedBox(
            height: 180.h,
            child: Row(
              children: [
                // Y-axis labels
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: ['40', '30', '20', '10', '0']
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

                // Chart Grid & Bars
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            // Custom Painter for horizontal grid lines
                            Positioned.fill(
                              child: CustomPaint(
                                painter: _BarChartGridPainter(
                                  gridColor: _dividerColor,
                                ),
                              ),
                            ),

                            // Beautiful Bars Row
                            Positioned.fill(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: List.generate(5, (index) {
                                  return FractionallySizedBox(
                                    heightFactor: barPercentages[index],
                                    child: Container(
                                      width: 28.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(8.r),
                                        ),
                                        gradient: const LinearGradient(
                                          colors: [_accentTeal, _accentPurple],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
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

                      // X-axis labels
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: barLabels
                            .map(
                              (label) => Expanded(
                                child: Text(
                                  label,
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
          SizedBox(height: 20.h),

          // Legend and details
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
                'Fear (40%)',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────
  //  Recurring Symbols Tags
  // ────────────────────────────────────────────────
  Widget _buildRecurringSymbols() {
    final List<Map<String, dynamic>> symbols = [
      {'tag': '#Water', 'count': 8},
      {'tag': '#nature', 'count': 5},
      {'tag': '#flying', 'count': 4},
    ];

    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children: symbols.map((sym) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: _accentPurple.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: _accentPurple.withOpacity(0.3), width: 1),
          ),
          child: Text(
            '${sym['tag']} (${sym['count']})',
            style: GoogleFonts.inter(
              color: _accentPurpleLight,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  // ────────────────────────────────────────────────
  //  Subconscious Evolution Dashboard
  // ────────────────────────────────────────────────
  Widget _buildSubconsciousEvolutionCard() {
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
          // Header row with "7 Days" Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subconscious Evolution',
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
                  '7 Days',
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

          // Main summary text
          Text(
            'Your dreams have shifted from anxiety-driven narratives to more exploratory and peaceful themes. Water symbols have increased 40% this month, suggesting a deeper dive into emotional awareness.',
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.7),
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
          SizedBox(height: 24.h),

          // Linear Progress Indicator row
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: LinearProgressIndicator(
                    value: 0.72,
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
                '7.2/10',
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
            'Emotional Intensity Score',
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

  // ────────────────────────────────────────────────
  //  Premium Card
  // ────────────────────────────────────────────────
  Widget _buildPremiumCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF1E1446), Color(0xFF120B2E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: _accentPurple.withOpacity(0.12),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
        border: Border.all(color: _accentPurple.withOpacity(0.25), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          GestureDetector(
            onTap: () {
              // TODO: navigate to subscription
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
}

// ────────────────────────────────────────────────
//  Custom Painter for Line Chart Trend Curve
// ────────────────────────────────────────────────
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

    // Draw horizontal grid lines (Y levels: 100, 75, 50, 25, 0 -> 4 intervals)
    final Paint gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (int i = 0; i <= 4; i++) {
      final double yPos = h * (i / 4);
      canvas.drawLine(Offset(0, yPos), Offset(w, yPos), gridPaint);
    }

    if (pointsYPercentage.isEmpty) return;

    // Calculate Day coordinate offsets
    final double stepX = w / (pointsYPercentage.length - 1);
    final List<Offset> points = [];

    for (int i = 0; i < pointsYPercentage.length; i++) {
      final double x = i * stepX;
      final double y = h - (h * pointsYPercentage[i]);
      points.add(Offset(x, y));
    }

    // Draw glowing shadow background line
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

    // Draw primary solid curve
    final Paint linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(curvePath, linePaint);

    // Draw point circle nodes
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
  bool shouldRepaint(covariant _MoodTrendLinePainter oldDelegate) => false;
}

// ────────────────────────────────────────────────
//  Custom Painter for Bar Chart Grid Lines
// ────────────────────────────────────────────────
class _BarChartGridPainter extends CustomPainter {
  final Color gridColor;

  _BarChartGridPainter({required this.gridColor});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Draw Y level horizontal lines (Y levels: 40, 30, 20, 10, 0 -> 4 intervals)
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
