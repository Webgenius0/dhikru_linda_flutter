import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:dhikru_linda_flutter/features/journal/model/show_journal_model.dart';
import 'package:dhikru_linda_flutter/networks/api_acess.dart';

class JournalDetailScreen extends StatefulWidget {
  final Map<String, dynamic> dream;

  const JournalDetailScreen({super.key, required this.dream});

  @override
  State<JournalDetailScreen> createState() => _JournalDetailScreenState();
}

class _JournalDetailScreenState extends State<JournalDetailScreen> {
  // ─── Colors ─────────────────────────────────────────────────────────────────
  static const Color _bgColor = Color(0xFF0D0D1A);
  static const Color _cardBg = Color(0xFF131325);
  static const Color _borderColor = Color(0xFF252545);
  static const Color _accentPurple = Color(0xFF7B6EF6);
  static const Color _white = Colors.white;
  static const Color _subtleText = Color(0xFF8888AA);
  static const Color _labelText = Color(0xFF6666AA);
  static const Color _tagBg = Color(0xFF121226);
  static const Color _tagBorder = Color(0xFF252549);
  static const Color _tagText = Color(0xFF8888EE);

  final TextEditingController _respondController = TextEditingController();

  // Care items mapping
  final List<Map<String, dynamic>> _careItems = [
    {
      'icon': Icons.favorite_border_rounded,
      'iconColor': Color(0xFF9988FF),
      'iconBg': Color(0xFF1E1A3A),
      'title': 'Meditate',
      'subtitle': '5 min practice',
    },
    {
      'icon': Icons.directions_walk_rounded,
      'iconColor': Color(0xFF22CCAA),
      'iconBg': Color(0xFF0A2A22),
      'title': 'Walk',
      'subtitle': 'Get some air',
    },
    {
      'icon': Icons.menu_book_rounded,
      'iconColor': Color(0xFFEEAA44),
      'iconBg': Color(0xFF2A1E0A),
      'title': 'Journal',
      'subtitle': 'Write it down',
    },
    {
      'icon': Icons.coffee_rounded,
      'iconColor': Color(0xFFEE6688),
      'iconBg': Color(0xFF2A1020),
      'title': 'Relax',
      'subtitle': 'Take a break',
    },
  ];

  @override
  void initState() {
    super.initState();
    showJournalRxObj.clean();
    if (widget.dream['id'] != null) {
      showJournalRxObj.showJournalDetails(journalId: widget.dream['id']);
    }

    showJournalRxObj.getShowJournalStream.firstWhere((data) => data.data != null).then((data) {
      if (mounted && data.data?.userResponse != null) {
        _respondController.text = data.data!.userResponse!;
      }
    });
  }

  @override
  void dispose() {
    _respondController.dispose();
    showJournalRxObj.clean();
    super.dispose();
  }

  Color _getEmotionColor(String? name) {
    if (name == null) return const Color(0xFF7B6EF6);
    final n = name.toLowerCase();
    if (n.contains('anxi') || n.contains('fear') || n.contains('stress') || n.contains('overwhelm')) return const Color(0xFFEE4444);
    if (n.contains('confus') || n.contains('doubt') || n.contains('puzzl')) return const Color(0xFF7B6EF6);
    if (n.contains('awe') || n.contains('wonder') || n.contains('amaz')) return const Color(0xFF00CFFF);
    if (n.contains('joy') || n.contains('happ') || n.contains('excit') || n.contains('calm')) return const Color(0xFF22CCAA);
    if (n.contains('sad') || n.contains('grief') || n.contains('sorrow')) return const Color(0xFF9988FF);
    return const Color(0xFF7B6EF6);
  }

  Map<String, dynamic> _getCareItemIconAndColors(String title) {
    final t = title.toLowerCase();
    if (t.contains('meditat')) {
      return {
        'icon': Icons.favorite_border_rounded,
        'iconColor': const Color(0xFF9988FF),
        'iconBg': const Color(0xFF1E1A3A),
      };
    } else if (t.contains('walk')) {
      return {
        'icon': Icons.directions_walk_rounded,
        'iconColor': const Color(0xFF22CCAA),
        'iconBg': const Color(0xFF0A2A22),
      };
    } else if (t.contains('journ')) {
      return {
        'icon': Icons.menu_book_rounded,
        'iconColor': const Color(0xFFEEAA44),
        'iconBg': const Color(0xFF2A1E0A),
      };
    } else if (t.contains('relax')) {
      return {
        'icon': Icons.coffee_rounded,
        'iconColor': const Color(0xFFEE6688),
        'iconBg': const Color(0xFF2A1020),
      };
    }
    return {
      'icon': Icons.self_improvement_rounded,
      'iconColor': const Color(0xFF9988FF),
      'iconBg': const Color(0xFF1E1A3A),
    };
  }

  Widget _buildShimmerLoader(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.04),
      highlightColor: Colors.white.withOpacity(0.08),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Header row skeleton
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Container(
                      width: 130.w,
                      height: 18.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Hero header centered details
            Center(
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 200.w,
                    height: 22.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 140.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Summary Card
            Container(
              width: double.infinity,
              height: 120.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            const SizedBox(height: 14),

            // Meaning Card
            Container(
              width: double.infinity,
              height: 100.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            const SizedBox(height: 28),

            // Respond label & box
            Container(
              width: 100.w,
              height: 12.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(3.r),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              height: 80.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            const SizedBox(height: 28),

            // Care label & grids
            Container(
              width: 130.w,
              height: 12.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(3.r),
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.6,
              children: List.generate(4, (index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                );
              }),
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: StreamBuilder<ShowJournalModel>(
          stream: showJournalRxObj.getShowJournalStream,
          builder: (context, snapshot) {
            return ValueListenableBuilder<bool>(
              valueListenable: showJournalRxObj.isLoading,
              builder: (context, apiLoading, child) {
                final isLoading = apiLoading || snapshot.connectionState == ConnectionState.waiting;
                if (isLoading) {
                  return _buildShimmerLoader(context);
                }

                final journalData = snapshot.data?.data;
                if (journalData == null) {
                  return const Center(
                    child: Text(
                      "No journal details found.",
                      style: TextStyle(color: _subtleText),
                    ),
                  );
                }

                // Dynamically retrieve values from journalData, fallback to dream values
                final String title = journalData.title ?? widget.dream['title'] ?? 'The Endless Ocean';
                final String date = journalData.formattedDate ?? widget.dream['date'] ?? 'Oct 25';

                // Derive a clean list of emotions from the badge or default
                final String badge = (journalData.moodDisplay ?? widget.dream['badge'] as String? ?? 'Anxiety, Overwhelm').toLowerCase();
                final String capitalizedBadge = badge
                    .split(', ')
                    .map((word) => word.isNotEmpty ? (word.substring(0, 1).toUpperCase() + word.substring(1)) : '')
                    .join(', ');
                final String subtitleText = '$date • $capitalizedBadge';

                // Summary & Meaning contents
                final String summary = journalData.summary ?? widget.dream['summary'] ?? '';
                final String meaning = journalData.meaning ?? widget.dream['meaning'] ?? '';

                // Emotions configuration
                final List<Map<String, dynamic>> emotions = (journalData.emotionalLandscape != null && journalData.emotionalLandscape!.isNotEmpty)
                    ? journalData.emotionalLandscape!.map((e) {
                        final color = _getEmotionColor(e.name);
                        return {
                          'label': e.name ?? '',
                          'percent': e.percentage ?? 0,
                          'color': color,
                          'trackColor': color.withOpacity(0.15),
                        };
                      }).toList()
                    : [
                        {
                          'label': 'Anxiety',
                          'percent': 75,
                          'color': const Color(0xFFEE4444),
                          'trackColor': const Color(0xFF3A1A1A),
                        },
                        {
                          'label': 'Confusion',
                          'percent': 45,
                          'color': const Color(0xFF7B6EF6),
                          'trackColor': const Color(0xFF221A3A),
                        },
                        {
                          'label': 'Awe',
                          'percent': 30,
                          'color': const Color(0xFF00CFFF),
                          'trackColor': const Color(0xFF0A253A),
                        },
                      ];

                // Care items mapping from API with fallback to default mockup list
                final List<Map<String, dynamic>> careItems = (journalData.careReflection != null && journalData.careReflection!.isNotEmpty)
                    ? journalData.careReflection!.map((item) {
                        final itemTitle = item.shortTitle ?? item.title ?? 'Reflection';
                        final itemSubtitle = item.title ?? item.shortTitle ?? '';
                        final mapping = _getCareItemIconAndColors(itemTitle);
                        return {
                          'icon': mapping['icon'],
                          'iconColor': mapping['iconColor'],
                          'iconBg': mapping['iconBg'],
                          'title': itemTitle,
                          'subtitle': itemSubtitle,
                        };
                      }).toList()
                    : _careItems;

                // Symbol Tags configuration
                final List<String> symbolTags = journalData.symbolTags ?? List<String>.from(widget.dream['tags'] ?? []);

                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            _buildAppBar(context),
                            const SizedBox(height: 28),

                            // Hero Header with glowing icon and title
                            Center(child: _buildHeroHeader(title, subtitleText)),
                            const SizedBox(height: 28),

                            // Summary glassmorphism card
                            _buildTextCard(
                              icon: Icons.notes_rounded,
                              iconColor: _accentPurple,
                              title: 'Summary',
                              body: summary,
                            ),
                            const SizedBox(height: 14),

                            // Meaning glassmorphism card
                            _buildTextCard(title: 'Meaning', body: meaning),
                            const SizedBox(height: 28),

                            // Response input section
                            _buildYourRespondSection(),
                            const SizedBox(height: 28),

                            // Care & Reflection cards
                            _buildCareReflectionSection(careItems),
                            const SizedBox(height: 28),

                            // Emotional landscape progress bars
                            _buildEmotionalLandscapeSection(emotions),
                            const SizedBox(height: 28),

                            // Symbol tags section
                            _buildSymbolTagsSection(symbolTags),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  // ─── App Bar ─────────────────────────────────────────────────────────────────

  Widget _buildAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.maybePop(context),
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
              'Journal details',
              style: TextStyle(
                color: _white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        // Share/iOS share button
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: _cardBg,
            shape: BoxShape.circle,
            border: Border.all(color: _borderColor, width: 1),
          ),
          child: const Icon(Icons.share, color: _white, size: 16),
        ),
      ],
    );
  }

  // ─── Hero Header ─────────────────────────────────────────────────────────────

  Widget _buildHeroHeader(String title, String subtitleText) {
    return Column(
      children: [
        // Glimmering custom icon with glow shadow
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF9E85F5), Color(0xFF634DF2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7B6EF6).withOpacity(0.35),
                blurRadius: 18,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Dream title
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: _white,
            fontSize: 26,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        // Date + tags
        Text(
          subtitleText,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: _subtleText,
            fontSize: 13,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }

  // ─── Text Card (Summary / Meaning) ───────────────────────────────────────────

  Widget _buildTextCard({
    IconData? icon,
    Color? iconColor,
    required String title,
    required String body,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: _cardBg.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: iconColor ?? _accentPurple, size: 18),
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: const TextStyle(
                  color: _white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            body,
            style: const TextStyle(
              color: Color(0xFFAAAAAC),
              fontSize: 13.5,
              height: 1.6,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Your Respond ────────────────────────────────────────────────────────────

  Widget _buildYourRespondSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'YOUR RESPOND',
          style: TextStyle(
            color: _labelText,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _borderColor, width: 1),
          ),
          child: TextField(
            controller: _respondController,
            maxLines: 3,
            style: const TextStyle(color: _white, fontSize: 14, height: 1.5),
            decoration: const InputDecoration(
              hintText: 'Write your respond ..',
              hintStyle: TextStyle(color: _subtleText, fontSize: 14),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  // ─── Care & Reflection ───────────────────────────────────────────────────────

  Widget _buildCareReflectionSection(List<Map<String, dynamic>> careItems) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CARE & REFLECTION',
          style: TextStyle(
            color: _labelText,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 2.6,
          children: careItems.map((item) => _buildCareCard(item)).toList(),
        ),
      ],
    );
  }

  Widget _buildCareCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _borderColor, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: item['iconBg'] as Color,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(
                item['icon'] as IconData,
                color: item['iconColor'] as Color,
                size: 17,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item['title'] as String,
                    style: const TextStyle(
                      color: _white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    item['subtitle'] as String,
                    style: const TextStyle(color: _subtleText, fontSize: 11),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Emotional Landscape ─────────────────────────────────────────────────────

  Widget _buildEmotionalLandscapeSection(List<Map<String, dynamic>> emotions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'EMOTIONAL LANDSCAPE',
          style: TextStyle(
            color: _labelText,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _borderColor, width: 1),
          ),
          child: Column(
            children: List.generate(emotions.length, (index) {
              final item = emotions[index];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index < emotions.length - 1 ? 18 : 0,
                ),
                child: _buildEmotionBar(item),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildEmotionBar(Map<String, dynamic> item) {
    final int percent = item['percent'] as int;
    final Color barColor = item['color'] as Color;
    final Color trackColor = item['trackColor'] as Color;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item['label'] as String,
              style: const TextStyle(
                color: _white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$percent%',
              style: const TextStyle(
                color: _subtleText,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Container(
                  height: 6,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: trackColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOut,
                  height: 6,
                  width: constraints.maxWidth * (percent / 100),
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  // ─── Symbol Tags ─────────────────────────────────────────────────────────────

  Widget _buildSymbolTagsSection(List<String> symbolTags) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SYMBOL TAGS',
          style: TextStyle(
            color: _labelText,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: symbolTags.map((tag) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              decoration: BoxDecoration(
                color: _tagBg,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: _tagBorder, width: 1),
              ),
              child: Text(
                tag,
                style: const TextStyle(
                  color: _tagText,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
