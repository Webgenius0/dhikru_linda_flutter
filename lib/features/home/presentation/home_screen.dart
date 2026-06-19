import 'package:dhikru_linda_flutter/helpers/all_routes.dart';
import 'package:dhikru_linda_flutter/helpers/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:dhikru_linda_flutter/networks/api_acess.dart';
import 'package:dhikru_linda_flutter/features/home/model/get_profile_model.dart'
    hide Data;
import 'package:dhikru_linda_flutter/features/home/model/home_data_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:dhikru_linda_flutter/networks/endpoints.dart' as endpoints;

class HomeScreen extends StatefulWidget {
  final VoidCallback? onGoProfile;
  final VoidCallback? onGoJournal;
  const HomeScreen({super.key, this.onGoProfile, this.onGoJournal});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Colors
  static const Color _bgColor = Color(0xFF0D0D1A);
  static const Color _cardBg = Color(0xFF161628);
  static const Color _accentGreen = Color(0xFF4ECFB5);
  static const Color _accentPurple = Color(0xFF7B6EF6);
  static const Color _buttonPurple = Color(0xFF7B6EF6);
  static const Color _streakBg = Color(0xFF2A1A10);
  static const Color _streakText = Color(0xFFE08030);
  static const Color _white = Colors.white;
  static const Color _subtleText = Color(0xFF8888AA);
  static const Color _statCardBg = Color(0xFF161628);
  static const Color _statBorder = Color(0xFF2A2A45);
  static const Color _tagBg = Color(0xFF1E1E35);
  static const Color _tagText = Color(0xFF6666AA);

  @override
  void initState() {
    super.initState();
    getProfileRxObj.getProfileInfo();
    homeDataRxObj.getHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: MediaQuery.of(context).padding.top + 16,
            bottom: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(),
              const SizedBox(height: 6),
              _buildGreetingName(),
              const SizedBox(height: 24),
              _buildPortalCard(),
              const SizedBox(height: 24),
              StreamBuilder<HomeDataModel>(
                stream: homeDataRxObj.getHomeDataStream,
                builder: (context, snapshot) {
                  final isLoading =
                      snapshot.connectionState == ConnectionState.waiting;
                  final data = snapshot.hasData ? snapshot.data?.data : null;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatsRow(data, isLoading),
                      const SizedBox(height: 32),
                      _buildRecentDreamsSection(data, isLoading),
                      const SizedBox(height: 32),
                      _buildWeeklyInsightSection(data, isLoading),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Top Bar ────────────────────────────────────────────────────────────────

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: const [
            Text(
              'Good night ',
              style: TextStyle(
                color: _white,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text('🌙', style: TextStyle(fontSize: 15)),
          ],
        ),
        Row(
          children: [
            _buildStreakBadge(),
            const SizedBox(width: 10),
            _buildAvatar(),
          ],
        ),
      ],
    );
  }

  Widget _buildStreakBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _streakBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF3D2010), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text('🔥', style: TextStyle(fontSize: 13)),
          SizedBox(width: 5),
          Text(
            '7 DAY STREAK',
            style: TextStyle(
              color: _streakText,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return GestureDetector(
      onTap: widget.onGoProfile,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: _accentPurple, width: 2),
          color: const Color(0xFF3A2060),
        ),
        child: ClipOval(
          child: StreamBuilder<GetProfileModel>(
            stream: getProfileRxObj.getProfileData,
            builder: (context, snapshot) {
              final user = snapshot.data?.data?.user;
              final avatar = user?.avatar;
              if (avatar != null && avatar.isNotEmpty) {
                String fullImageUrl = avatar;
                if (!fullImageUrl.startsWith('http')) {
                  fullImageUrl =
                      "${endpoints.url}/${fullImageUrl.startsWith('/') ? fullImageUrl.substring(1) : fullImageUrl}";
                }
                return CachedNetworkImage(
                  imageUrl: fullImageUrl,
                  width: 38,
                  height: 38,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.white.withOpacity(0.05),
                    highlightColor: Colors.white.withOpacity(0.1),
                    child: Container(
                      width: 38,
                      height: 38,
                      color: Colors.white,
                    ),
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/person_img.png',
                    width: 38,
                    height: 38,
                    fit: BoxFit.cover,
                  ),
                );
              }
              return Container(
                color: const Color(0xFF5A3A80),
                child: Image.asset(
                  'assets/images/person_img.png',
                  height: 22,
                  width: 22,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ─── Greeting ───────────────────────────────────────────────────────────────

  Widget _buildGreetingName() {
    return StreamBuilder<GetProfileModel>(
      stream: getProfileRxObj.getProfileData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData ||
            snapshot.data?.data?.user == null) {
          return Shimmer.fromColors(
            baseColor: Colors.white.withOpacity(0.05),
            highlightColor: Colors.white.withOpacity(0.1),
            child: Container(
              width: 120,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
        final name = snapshot.data?.data?.user?.name ?? '';
        return Text(
          name,
          style: const TextStyle(
            color: _white,
            fontSize: 32,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            height: 1.1,
          ),
        );
      },
    );
  }

  // ─── Portal Card ────────────────────────────────────────────────────────────

  Widget _buildPortalCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF22223A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LAST NIGHT\'S PORTAL',
            style: TextStyle(
              color: _accentGreen,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'What shadows\ndanced in your\nmind?',
            style: TextStyle(
              color: _white,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              height: 1.2,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 28),
          _buildLogButton(),
          const SizedBox(height: 18),
          Center(
            child: Text(
              '"The dream is a little hidden door..."',
              style: TextStyle(
                color: _subtleText,
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          NavigationService.navigateTo(Routes.newDrimeEnterScreen);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _buttonPurple,
          foregroundColor: _white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.notes_rounded, size: 20, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Log & Interpret',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Stats Row ──────────────────────────────────────────────────────────────

  Widget _buildShimmerStatCard() {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.05),
      highlightColor: Colors.white.withOpacity(0.1),
      child: Container(
        height: 110.h,
        decoration: BoxDecoration(
          color: _statCardBg,
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
    );
  }

  Widget _buildStatsRow(Data? data, bool isLoading) {
    if (isLoading || data == null || data.stats == null) {
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: _buildShimmerStatCard()),
            const SizedBox(width: 10),
            Expanded(child: _buildShimmerStatCard()),
            const SizedBox(width: 10),
            Expanded(child: _buildShimmerStatCard()),
          ],
        ),
      );
    }

    final stats = data.stats!;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _buildStatCard(
              icon: '✦',
              iconColor: _accentPurple,
              value: (stats.totalDreams ?? 0).toString(),
              label: 'DREAMS',
              hasBorder: false,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildStatCard(
              icon: '〜',
              iconColor: _accentGreen,
              value: (stats.dreamsThisWeek ?? 0).toString(),
              label: 'THIS WEEK',
              hasBorder: true,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildStatCard(
              icon: '😊',
              iconColor: Colors.amber,
              value: stats.avgMood ?? 'N/A',
              label: 'AVG. MOOD',
              hasBorder: false,
              isEmoji: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String icon,
    required Color iconColor,
    required String value,
    required String label,
    required bool hasBorder,
    bool isEmoji = false,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
            decoration: BoxDecoration(
              color: _statCardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: hasBorder ? _accentPurple : _statBorder,
                width: hasBorder ? 1.5 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isEmoji
                    ? Text(
                        icon,
                        style: const TextStyle(fontSize: 22),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : Text(
                        icon,
                        style: TextStyle(
                          color: iconColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    color: _white,
                    fontSize: value.length > 3 ? 18 : 26,
                    fontWeight: FontWeight.w700,
                    height: 1.0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(
                    color: _subtleText,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 4,
              decoration: const BoxDecoration(
                color: _accentPurple,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Recent Dreams ──────────────────────────────────────────────────────────

  Widget _buildShimmerDreamCard() {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.05),
      highlightColor: Colors.white.withOpacity(0.1),
      child: Container(
        width: double.infinity,
        height: 120.h,
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
    );
  }

  Widget _buildRecentDreamsSection(Data? data, bool isLoading) {
    if (isLoading || data == null || data.recentDreams == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'RECENT DREAMS',
                style: TextStyle(
                  color: _subtleText,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.8,
                ),
              ),
              GestureDetector(
                onTap: widget.onGoJournal,
                child: const Text(
                  'View All',
                  style: TextStyle(
                    color: _accentGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _buildShimmerDreamCard(),
          const SizedBox(height: 12),
          _buildShimmerDreamCard(),
        ],
      );
    }

    final dreams = data.recentDreams!;
    if (dreams.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'RECENT DREAMS',
                style: TextStyle(
                  color: _subtleText,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.8,
                ),
              ),
              GestureDetector(
                onTap: widget.onGoJournal,
                child: const Text(
                  'View All',
                  style: TextStyle(
                    color: _accentGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 30),
            alignment: Alignment.center,
            child: const Text(
              'No dreams logged yet.',
              style: TextStyle(color: _subtleText),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'RECENT DREAMS',
              style: TextStyle(
                color: _subtleText,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.8,
              ),
            ),
            GestureDetector(
              onTap: widget.onGoJournal,
              child: const Text(
                'View All',
                style: TextStyle(
                  color: _accentGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.8,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ...List.generate(dreams.length, (index) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: index < dreams.length - 1 ? 12 : 0,
            ),
            child: _buildDreamCard(dreams[index]),
          );
        }),
      ],
    );
  }

  Widget _buildDreamCard(RecentDream dream) {
    final moodStr = dream.moodDisplay ?? '';
    String emoji = '😴';
    if (moodStr.isNotEmpty) {
      final parts = moodStr.split(' ');
      if (parts.isNotEmpty) {
        emoji = parts.first;
      }
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF22223A), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: _accentPurple.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        dream.title ?? 'Untitled Dream',
                        style: const TextStyle(
                          color: _white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      dream.timeAgo ?? '',
                      style: const TextStyle(
                        color: _subtleText,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  dream.summary ?? '',
                  style: const TextStyle(
                    color: Color(0xFFAAAAAC),
                    fontSize: 13.5,
                    height: 1.5,
                    letterSpacing: 0.1,
                  ),
                ),
                if (dream.emotionalTags != null &&
                    dream.emotionalTags!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: dream.emotionalTags!.map((tag) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: _tagBg,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(
                                color: _tagText,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 4,
              decoration: const BoxDecoration(
                color: _accentPurple,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Weekly Insight / Mood Chart ────────────────────────────────────────────

  Widget _buildWeeklyInsightSection(Data? data, bool isLoading) {
    if (isLoading || data == null || data.weeklyInsight?.moodTrend == null) {
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
        _buildMoodChartCard(data.weeklyInsight!.moodTrend!),
      ],
    );
  }

  Widget _buildMoodChartCard(MoodTrend moodTrend) {
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
