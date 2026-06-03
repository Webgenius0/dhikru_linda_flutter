import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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

  final List<Map<String, dynamic>> _recentDreams = [
    {
      'emoji': '🌊',
      'title': 'The Endless Ocean',
      'time': 'LAST NIGHT',
      'description':
      'Floating in vast dark water, a lighthouse in the distance calling me forward.',
      'tags': ['#water', '#freedom', '#longing'],
      'emojiColor': Color(0xFF4ECFB5),
    },
    {
      'emoji': '🌿',
      'title': 'Forest of Whispers',
      'time': '2 DAYS AGO',
      'description':
      'Ancient trees speaking in a language I almost understood, leaves forming words.',
      'tags': ['#nature', '#mystery', '#communication'],
      'emojiColor': Color(0xFF6FCF6F),
    },
  ];

  // Mood trend data: Mon–Sun
  final List<FlSpot> _moodSpots = const [
    FlSpot(0, 65),
    FlSpot(1, 70),
    FlSpot(2, 55),
    FlSpot(3, 78),
    FlSpot(4, 74),
    FlSpot(5, 82),
    FlSpot(6, 90),
  ];

  final List<String> _weekDays = const [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(),
              const SizedBox(height: 6),
              _buildGreetingName(),
              const SizedBox(height: 24),
              _buildPortalCard(),
              const SizedBox(height: 24),
              _buildStatsRow(),
              const SizedBox(height: 32),
              _buildRecentDreamsSection(),
              const SizedBox(height: 32),
              _buildWeeklyInsightSection(),
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
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: _accentPurple, width: 2),
        color: const Color(0xFF3A2060),
      ),
      child: ClipOval(
        child: Container(
          color: const Color(0xFF5A3A80),
          child: const Icon(Icons.person, color: Colors.white70, size: 22),
        ),
      ),
    );
  }

  // ─── Greeting ───────────────────────────────────────────────────────────────

  Widget _buildGreetingName() {
    return const Text(
      'Lee H.',
      style: TextStyle(
        color: _white,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.1,
      ),
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
        onPressed: () {},
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

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: '✦',
            iconColor: _accentPurple,
            value: '42',
            label: 'DREAMS',
            hasBorder: false,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatCard(
            icon: '〜',
            iconColor: _accentGreen,
            value: '12',
            label: 'THIS WEEK',
            hasBorder: true,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatCard(
            icon: '😊',
            iconColor: Colors.amber,
            value: 'Vivid',
            label: 'AVG. MOOD',
            hasBorder: false,
            isEmoji: true,
          ),
        ),
      ],
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
    return Container(
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
        children: [
          isEmoji
              ? Text(icon, style: const TextStyle(fontSize: 22))
              : Text(
            icon,
            style: TextStyle(
              color: iconColor,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
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
          ),
        ],
      ),
    );
  }

  // ─── Recent Dreams ──────────────────────────────────────────────────────────

  Widget _buildRecentDreamsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        const SizedBox(height: 14),
        ...List.generate(_recentDreams.length, (index) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: index < _recentDreams.length - 1 ? 12 : 0,
            ),
            child: _buildDreamCard(_recentDreams[index]),
          );
        }),
      ],
    );
  }

  Widget _buildDreamCard(Map<String, dynamic> dream) {
    return Container(
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
                  color: (dream['emojiColor'] as Color).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    dream['emoji'] as String,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  dream['title'] as String,
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
                dream['time'] as String,
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
            dream['description'] as String,
            style: const TextStyle(
              color: Color(0xFFAAAAAC),
              fontSize: 13.5,
              height: 1.5,
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: (dream['tags'] as List<String>).map((tag) {
              return Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─── Weekly Insight / Mood Chart ────────────────────────────────────────────

  Widget _buildWeeklyInsightSection() {
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
        _buildMoodChartCard(),
      ],
    );
  }

  Widget _buildMoodChartCard() {
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
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 100,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 25,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: const Color(0xFF252540),
                    strokeWidth: 1,
                  ),
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
                        if (value == 0 || value == 25 || value == 50 ||
                            value == 75 || value == 100) {
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
                        if (idx < 0 || idx >= _weekDays.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            _weekDays[idx],
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
                    spots: _moodSpots,
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
          const SizedBox(height: 18),
          // Bottom insight text
          const Center(
            child: Text(
              'Your mood has improved by 38% this week',
              style: TextStyle(
                color: Color(0xFF8888AA),
                fontSize: 13,
                letterSpacing: 0.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}