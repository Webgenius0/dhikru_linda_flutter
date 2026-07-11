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
    insightsDataRxObj.getInsightsData();
    tagsRxObj.getTags();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F14),
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
                SliverToBoxAdapter(
                  child: InsightsAppBar(onGoHome: widget.onGoHome),
                ),

                if (isLoading || data == null) ...[
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
                ] else ...[
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
                ],

                // const SliverToBoxAdapter(
                //   child: Padding(
                //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                //     child: InsightsPremiumCard(),
                //   ),
                // ),
                SliverToBoxAdapter(child: SizedBox(height: 15.h)),
              ],
            );
          },
        ),
      ),
    );
  }
}
