import 'package:dhikru_linda_flutter/features/insights/model/insight_data_model.dart';
import 'package:dhikru_linda_flutter/networks/api_acess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

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
  void initState() {
    super.initState();
    insightsDataRxObj.getInsightsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        top: false,
        child: StreamBuilder<InsightsDataModel>(
          stream: insightsDataRxObj.getInsightsDataStream,
          builder: (context, snapshot) {
            final isLoading =
                snapshot.connectionState == ConnectionState.waiting;
            final data = snapshot.hasData ? snapshot.data?.data : null;

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ── App Bar ──
                SliverToBoxAdapter(child: _buildAppBar(context)),

                if (isLoading || data == null) ...[
                  // ── Mood Trend Shimmer Card ──
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h,
                      ),
                      child: _buildShimmerMoodTrendCard(),
                    ),
                  ),

                  // ── Theme Frequency Shimmer Card ──
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h,
                      ),
                      child: _buildShimmerThemeFrequencyCard(),
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
                      child: _buildShimmerRecurringSymbols(),
                    ),
                  ),

                  // ── Subconscious Evolution Shimmer Card ──
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      child: _buildShimmerSubconsciousEvolutionCard(),
                    ),
                  ),
                ] else ...[
                  // ── Mood Trend Card ──
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h,
                      ),
                      child: _buildMoodTrendCard(data.moodTrend),
                    ),
                  ),

                  // ── Theme Frequency Card ──
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h,
                      ),
                      child: _buildThemeFrequencyCard(data.themeFrequency),
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
                      child: _buildRecurringSymbols(data.recurringSymbols),
                    ),
                  ),

                  // ── Subconscious Evolution Card ──
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      child: _buildSubconsciousEvolutionCard(
                        data.subconsciousEvolution,
                      ),
                    ),
                  ),
                ],

                // ── Unlock Premium Insights Card ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    child: _buildPremiumCard(),
                  ),
                ),

                // Padding at the bottom of the scroll list
                SliverToBoxAdapter(child: SizedBox(height: 10.h)),
              ],
            );
          },
        ),
      ),
    );
  }

  // ─── App Bar ─────────────────────────────────────────────────────────────────

  Widget _buildAppBar(BuildContext context) {
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
  Widget _buildMoodTrendCard(MoodTrend? moodTrend) {
    final hasData = moodTrend?.data != null && moodTrend!.data!.isNotEmpty;
    final pointsYPercentage = hasData
        ? moodTrend.data!.map((x) => (x.score ?? 0) / 100.0).toList()
        : <double>[];
    final days = hasData
        ? moodTrend.data!.map((x) => x.day ?? '').toList()
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
                            pointsYPercentage: pointsYPercentage,
                            lineColor: _accentTeal,
                            gridColor: _dividerColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),

                      // X-axis labels
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

  // ─── Shimmer Mood Trend Card ───
  Widget _buildShimmerMoodTrendCard() {
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

  // ────────────────────────────────────────────────
  //  Theme Frequency Card Widget
  // ────────────────────────────────────────────────
  Widget _buildThemeFrequencyCard(ThemeFrequency? themeFrequency) {
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

          // Custom Bar Chart
          SizedBox(
            height: 180.h,
            child: Row(
              children: [
                // Y-axis labels
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
                                children: List.generate(barPercentages.length, (
                                  index,
                                ) {
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

          if (themeFrequency?.dominantThemeLabel != null &&
              themeFrequency!.dominantThemeLabel!.isNotEmpty) ...[
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
                  themeFrequency.dominantThemeLabel!,
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

  // ─── Shimmer Theme Frequency Card ───
  Widget _buildShimmerThemeFrequencyCard() {
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

  // ────────────────────────────────────────────────
  //  Recurring Symbols Tags
  // ────────────────────────────────────────────────
  Widget _buildRecurringSymbols(List<RecurringSymbol>? symbols) {
    if (symbols == null || symbols.isEmpty) {
      return Text(
        'No recurring symbols detected yet.',
        style: GoogleFonts.inter(
          color: _mutedText.withOpacity(0.6),
          fontSize: 13.sp,
          fontWeight: FontWeight.w400,
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: symbols.map((sym) {
          final tag = sym.display ?? '#${sym.name ?? ''}';
          return Container(
            margin: EdgeInsets.only(right: 10.w),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: _accentPurple.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: _accentPurple.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              tag,
              style: GoogleFonts.inter(
                color: _accentPurpleLight,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─── Shimmer Recurring Symbols ───
  Widget _buildShimmerRecurringSymbols() {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.05),
      highlightColor: Colors.white.withOpacity(0.1),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: Row(
          children: List.generate(3, (index) {
            return Container(
              margin: EdgeInsets.only(right: 10.w),
              width: (80 + (index * 15)).w,
              height: 32.h,
              decoration: BoxDecoration(
                color: _white,
                borderRadius: BorderRadius.circular(20.r),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────
  //  Subconscious Evolution Dashboard
  // ────────────────────────────────────────────────
  Widget _buildSubconsciousEvolutionCard(SubconsciousEvolution? evolution) {
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
          // Header row with "7 Days" Badge
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

          // Main summary text
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

          // Linear Progress Indicator row
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

  // ─── Shimmer Subconscious Evolution Card ───
  Widget _buildShimmerSubconsciousEvolutionCard() {
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

    if (pointsYPercentage.length < 2) return;

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
  bool shouldRepaint(covariant _MoodTrendLinePainter oldDelegate) =>
      oldDelegate.pointsYPercentage != pointsYPercentage;
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
