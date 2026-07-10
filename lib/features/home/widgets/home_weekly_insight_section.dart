import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:dhikru_linda_flutter/features/home/model/home_data_model.dart';

const Color _cardBg = Color(0xFF161628);
const Color _subtleText = Color(0xFF8888AA);
const Color _white = Colors.white;

class HomeWeeklyInsightSection extends StatelessWidget {
  final Data? data;
  final bool isLoading;

  const HomeWeeklyInsightSection({
    super.key,
    this.data,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading || data == null || data!.weeklyInsight?.moodTrend == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'WEEKLY INSIGHT',
            style: TextStyle(
              color: _subtleText,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.8,
            ),
          ),
          const SizedBox(height: 14),
          Shimmer.fromColors(
            baseColor: Colors.white.withOpacity(0.05),
            highlightColor: Colors.white.withOpacity(0.1),
            child: Container(
              width: double.infinity,
              height: 250.h,
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'WEEKLY INSIGHT',
          style: TextStyle(
            color: _subtleText,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.8,
          ),
        ),
        const SizedBox(height: 14),
        HomeMoodChartCard(moodTrend: data!.weeklyInsight!.moodTrend!),
      ],
    );
  }
}

class HomeMoodChartCard extends StatelessWidget {
  final MoodTrend moodTrend;

  const HomeMoodChartCard({super.key, required this.moodTrend});

  @override
  Widget build(BuildContext context) {
    final List<FlSpot> spots = [];
    final trendData = moodTrend.data ?? [];
    for (int i = 0; i < trendData.length; i++) {
      spots.add(FlSpot(i.toDouble(), (trendData[i].score ?? 0).toDouble()));
    }

    final List<String> weekDays = trendData.map((d) => d.day ?? '').toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 16, 20),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF22223A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chart title
          const Text(
            'Mood Trend',
            style: TextStyle(
              color: _white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 20),
          // Chart
          if (spots.isEmpty)
            Container(
              height: 200,
              alignment: Alignment.center,
              child: const Text(
                'No data available',
                style: TextStyle(color: _subtleText),
              ),
            )
          else
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: (spots.length - 1).toDouble(),
                  minY: 0,
                  maxY: 100,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 25,
                    getDrawingHorizontalLine: (value) =>
                        FlLine(color: const Color(0xFF252540), strokeWidth: 1),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        interval: 25,
                        getTitlesWidget: (value, meta) {
                          if (value == 0 ||
                              value == 25 ||
                              value == 50 ||
                              value == 75 ||
                              value == 100) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                color: Color(0xFF555577),
                                fontSize: 11,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final int idx = value.toInt();
                          if (idx < 0 || idx >= weekDays.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              weekDays[idx],
                              style: const TextStyle(
                                color: Color(0xFF666688),
                                fontSize: 11,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      curveSmoothness: 0.35,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF7B6EF6), // purple
                          Color(0xFF00CFFF), // cyan/blue
                        ],
                      ),
                      barWidth: 2.5,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, bar, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: const Color(0xFF00CFFF),
                            strokeWidth: 2,
                            strokeColor: const Color(0xFF161628),
                          );
                        },
                      ),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          if (moodTrend.description != null &&
              moodTrend.description!.isNotEmpty) ...[
            const SizedBox(height: 18),
            Center(
              child: Text(
                moodTrend.description!,
                style: const TextStyle(
                  color: Color(0xFF8888AA),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
