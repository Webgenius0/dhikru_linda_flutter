import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dhikru_linda_flutter/features/home/model/home_data_model.dart';
import 'package:dhikru_linda_flutter/features/journal/presentation/journal_detail_screen.dart';

const Color _cardBg = Color(0xFF161628);
const Color _accentGreen = Color(0xFF4ECFB5);
const Color _subtleText = Color(0xFF8888AA);
const Color _tagBg = Color(0xFF1E1E35);
const Color _tagText = Color(0xFF6666AA);
const Color _white = Colors.white;

class HomeShimmerDreamCard extends StatelessWidget {
  const HomeShimmerDreamCard({super.key});

  @override
  Widget build(BuildContext context) {
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
}

class HomeRecentDreamsSection extends StatelessWidget {
  final Data? data;
  final bool isLoading;
  final VoidCallback? onGoJournal;

  const HomeRecentDreamsSection({
    super.key,
    this.data,
    required this.isLoading,
    this.onGoJournal,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading || data == null || data!.recentDreams == null) {
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
                onTap: onGoJournal,
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
          const HomeShimmerDreamCard(),
          const SizedBox(height: 12),
          const HomeShimmerDreamCard(),
        ],
      );
    }

    final dreams = data!.recentDreams!;
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
                onTap: onGoJournal,
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
              onTap: onGoJournal,
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
            child: HomeDreamCard(dream: dreams[index], index: index),
          );
        }),
      ],
    );
  }
}

class HomeDreamCard extends StatelessWidget {
  final RecentDream dream;
  final int index;

  const HomeDreamCard({
    super.key,
    required this.dream,
    required this.index,
  });

  Color _getAccentColor(int idx) {
    const colors = [
      Color(0xFF22CEE9), // 1st
      Color(0xFF49D97E), // 2nd
      Color(0xFF7B6EF6), // 3rd
      Color(0xFFEEAA44), // 4th
      Color(0xFFEE6688), // 5th
    ];
    return colors[idx % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final moodStr = dream.moodDisplay ?? '';
    final accentColor = _getAccentColor(index);
    String emoji = '😴';
    if (moodStr.isNotEmpty) {
      final parts = moodStr.split(' ');
      if (parts.isNotEmpty) {
        emoji = parts.first;
      }
    }

    return GestureDetector(
      onTap: () {
        final dreamMap = {
          'id': dream.id,
          'title': dream.title ?? 'Untitled Dream',
          'date': dream.timeAgo ?? '',
          'badge': dream.moodDisplay ?? 'DREAM',
          'badgeColor': const Color(0xFF221144),
          'badgeTextColor': const Color(0xFFFFD0FF),
          'description': dream.summary ?? '',
          'tags': dream.emotionalTags ?? <String>[],
          'leftAccent': accentColor,
        };
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JournalDetailScreen(dream: dreamMap),
          ),
        );
      },
      child: ClipRRect(
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
                          color: accentColor.withOpacity(0.12),
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
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
