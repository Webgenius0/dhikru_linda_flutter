import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dhikru_linda_flutter/features/home/model/home_data_model.dart';

const Color _accentPurple = Color(0xFF7B6EF6);
const Color _accentGreen = Color(0xFF4ECFB5);
const Color _statCardBg = Color(0xFF161628);
const Color _statBorder = Color(0xFF2A2A45);
const Color _white = Colors.white;
const Color _subtleText = Color(0xFF8888AA);

class HomeShimmerStatCard extends StatelessWidget {
  const HomeShimmerStatCard({super.key});

  @override
  Widget build(BuildContext context) {
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
}

class HomeStatsRow extends StatelessWidget {
  final Data? data;
  final bool isLoading;

  const HomeStatsRow({super.key, this.data, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    if (isLoading || data == null || data!.stats == null) {
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            Expanded(child: HomeShimmerStatCard()),
            SizedBox(width: 10),
            Expanded(child: HomeShimmerStatCard()),
            SizedBox(width: 10),
            Expanded(child: HomeShimmerStatCard()),
          ],
        ),
      );
    }

    final stats = data!.stats!;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: HomeStatCard(
              icon: '✦',
              iconColor: _accentPurple,
              value: (stats.totalDreams ?? 0).toString(),
              label: 'DREAMS',
              hasBorder: false,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: HomeStatCard(
              icon: '〜',
              iconColor: _accentGreen,
              value: (stats.dreamsThisWeek ?? 0).toString(),
              label: 'THIS WEEK',
              hasBorder: true,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: HomeStatCard(
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
}

class HomeStatCard extends StatelessWidget {
  final String icon;
  final Color iconColor;
  final String value;
  final String label;
  final bool hasBorder;
  final bool isEmoji;

  const HomeStatCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.hasBorder,
    this.isEmoji = false,
  });

  @override
  Widget build(BuildContext context) {
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
}
