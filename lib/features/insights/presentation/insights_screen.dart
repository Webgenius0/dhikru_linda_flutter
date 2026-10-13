import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dhikru_linda_flutter/networks/api_acess.dart';
import 'package:dhikru_linda_flutter/features/insights/model/insight_data_model.dart';
import 'package:dhikru_linda_flutter/features/insights/widgets/insights_widgets.dart';

class InsightsScreen extends StatefulWidget {
  final VoidCallback? onGoHome;
  final void Function(int? tagId)? onGoJournal;

  const InsightsScreen({super.key, this.onGoHome, this.onGoJournal});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await Future.wait([
      insightsDataRxObj.getInsightsData(),
      tagsRxObj.getTags(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F14),
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          color: const Color(0xFF7B6EF6),
          backgroundColor: const Color(0xFF131325),
          onRefresh: _fetchData,
          child: ValueListenableBuilder<bool>(
            valueListenable: insightsDataRxObj.isLoading,
            builder: (context, isLoading, _) {
              return ValueListenableBuilder<bool>(
                valueListenable: insightsDataRxObj.isPremiumLocked,
                builder: (context, isLocked, _) {
                  return StreamBuilder<InsightsDataModel>(
                    stream: insightsDataRxObj.getInsightsDataStream,
                    builder: (context, snapshot) {
                      final data = snapshot.hasData ? snapshot.data?.data : null;
                      final hasError = snapshot.hasError;
                      final isWaiting = isLoading ||
                          (snapshot.connectionState == ConnectionState.waiting &&
                              !snapshot.hasData &&
                              !hasError &&
                              !isLocked);

                      return CustomScrollView(
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        slivers: [
                          SliverToBoxAdapter(
                            child: InsightsAppBar(onGoHome: widget.onGoHome),
                          ),

                          // 1. Loading Shimmers
                          if (isWaiting) ...[
                            const SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                child: InsightsShimmerMoodTrendCard(),
                              ),
                            ),
                            const SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                child: InsightsShimmerThemeFrequencyCard(),
                              ),
                            ),
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
                                    color: const Color(0xFF8993A4),
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ),
                            const SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: InsightsShimmerRecurringSymbols(),
                              ),
                            ),
                            const SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                                child: InsightsShimmerSubconsciousEvolutionCard(),
                              ),
                            ),
                          ]
                          // 2. Premium Locked State (403 Forbidden or Non-Premium tier)
                          else if (isLocked) ...[
                            SliverToBoxAdapter(
                              child: InsightsLockedView(
                                customMessage: insightsDataRxObj.lockMessage.value,
                                onRefresh: _fetchData,
                              ),
                            ),
                          ]
                          // 3. General Network Error State
                          else if (hasError && data == null) ...[
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24.w,
                                  vertical: 36.h,
                                ),
                                child: _buildErrorCard(),
                              ),
                            ),
                          ]
                          // 4. Data Loaded State
                          else if (data != null) ...[
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                child: InsightsMoodTrendCard(moodTrend: data.moodTrend),
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                child: InsightsThemeFrequencyCard(
                                  themeFrequency: data.themeFrequency,
                                ),
                              ),
                            ),
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
                                    color: const Color(0xFF8993A4),
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: InsightsRecurringSymbols(
                                  symbols: data.recurringSymbols,
                                  onGoJournal: widget.onGoJournal,
                                ),
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                                child: InsightsSubconsciousEvolutionCard(
                                  evolution: data.subconsciousEvolution,
                                ),
                              ),
                            ),
                          ]
                          else ...[
                            SliverToBoxAdapter(
                              child: InsightsLockedView(
                                customMessage: insightsDataRxObj.lockMessage.value,
                                onRefresh: _fetchData,
                              ),
                            ),
                          ],

                          SliverToBoxAdapter(child: SizedBox(height: 15.h)),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: const Color(0xFF131325),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFF252545)),
      ),
      child: Column(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.redAccent.withValues(alpha: 0.12),
            ),
            child: const Icon(
              Icons.cloud_off_rounded,
              color: Colors.redAccent,
              size: 24,
            ),
          ),
          SizedBox(height: 14.h),
          Text(
            'Unable to Load Insights',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Please check your internet connection and try again.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: const Color(0xFF8888AA),
              fontSize: 12.5.sp,
            ),
          ),
          SizedBox(height: 18.h),
          ElevatedButton(
            onPressed: _fetchData,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7B6EF6),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
