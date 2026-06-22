import 'package:flutter/material.dart';
import 'package:dhikru_linda_flutter/helpers/all_routes.dart';
import 'package:dhikru_linda_flutter/helpers/navigation_service.dart';
import 'package:dhikru_linda_flutter/helpers/toast.dart';
import 'package:dhikru_linda_flutter/features/journal/model/new_journal_entry_model.dart';
import 'package:dhikru_linda_flutter/networks/api_acess.dart';
import 'package:shimmer/shimmer.dart';
import 'package:share_plus/share_plus.dart';

class InterpretationScren extends StatefulWidget {
  const InterpretationScren({super.key});

  @override
  State<InterpretationScren> createState() => _InterpretationScrenState();
}

class _InterpretationScrenState extends State<InterpretationScren> {
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

  Data? _dreamData;
  bool _isInitialized = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Data) {
        _dreamData = args;
        if (_dreamData!.userResponse != null) {
          _respondController.text = _dreamData!.userResponse!;
        }
      }
      _isInitialized = true;
    }
  }

  final List<Map<String, dynamic>> _emotions = [
    {
      'label': 'Anxiety',
      'percent': 75,
      'color': Color(0xFFEE4444),
      'trackColor': Color(0xFF3A1A1A),
    },
    {
      'label': 'Confusion',
      'percent': 45,
      'color': Color(0xFF4466EE),
      'trackColor': Color(0xFF1A1A3A),
    },
    {
      'label': 'Awe',
      'percent': 30,
      'color': Color(0xFF22CC88),
      'trackColor': Color(0xFF0A2A1A),
    },
  ];

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

  final List<String> _symbolTags = [
    'Water',
    'Lost',
    'Empty City',
    'Purple Sky',
  ];

  @override
  void dispose() {
    _respondController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _isLoading
                  ? _buildShimmerLoading()
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Center(child: _buildAppBar(context)),
                          const SizedBox(height: 28),

                          // ── NEW: Hero header ──
                          Center(child: _buildHeroHeader()),
                          const SizedBox(height: 28),

                          // ── Summary card ──
                          _buildTextCard(
                            icon: Icons.list_rounded,
                            iconColor: _accentPurple,
                            title: 'Summary',
                            body:
                                _dreamData?.summary ??
                                'You were wandering through a deserted metropolis under a vivid purple sky. Losing your shoes preceded a sudden flood, leaving you wading through rising waters. You were wandering through a deserted metropolis under a vivid purple sky. Losing your shoes preceded a sudden flood, leaving you wading through rising waters....',
                          ),
                          const SizedBox(height: 14),

                          // ── Meaning card ──
                          _buildTextCard(
                            title: 'Meaning',
                            body:
                                _dreamData?.meaning ??
                                'You were wandering through a deserted metropolis under a vivid purple sky. Losing your shoes preceded a sudden flood, leaving you wading through rising waters. You were wandering through a deserted',
                          ),
                          const SizedBox(height: 28),

                          _buildYourRespondSection(),
                          const SizedBox(height: 28),
                          _buildCareReflectionSection(),
                          const SizedBox(height: 28),
                          _buildEmotionalLandscapeSection(),
                          const SizedBox(height: 28),
                          _buildSymbolTagsSection(),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _isLoading
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.only(bottom: 45),
              child: _buildSaveButton(),
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
              'Interpretation',
              style: TextStyle(
                color: _white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        // Share button
        Builder(
          builder: (context) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _shareInterpretation(context),
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: _cardBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: _borderColor, width: 1),
                ),
                child: const Icon(Icons.share, color: _white, size: 16),
              ),
            );
          },
        ),
      ],
    );
  }

  // ─── Hero Header ─────────────────────────────────────────────────────────────

  Widget _buildHeroHeader() {
    final title = _dreamData?.title ?? 'The Endless Ocean';
    final dateAndMoods = _dreamData != null
        ? '${_dreamData!.formattedDate ?? ''}${_dreamData!.moodDisplay != null ? ' • ${_dreamData!.moodDisplay}' : ''}'
        : 'Oct 25 • Anxiety, Overwhelm';

    return Column(
      children: [
        // Purple circle icon
        Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            color: _accentPurple,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Text(
              '✦',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
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
          dateAndMoods,
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
        color: _cardBg,
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
              hintText: 'Write your respond ...',
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

  Widget _buildCareReflectionSection() {
    final hasData =
        _dreamData?.careReflection != null &&
        _dreamData!.careReflection!.isNotEmpty;
    final List<Map<String, dynamic>> itemsToShow = [];

    if (hasData) {
      for (var reflection in _dreamData!.careReflection!) {
        final title = reflection.title ?? '';
        final subtitle = reflection.shortTitle ?? '';
        if (title.isEmpty) continue;

        final decoration = _getCareItemIconAndColors(title);
        itemsToShow.add({
          'icon': decoration['icon'] ?? Icons.favorite_border_rounded,
          'iconColor': decoration['iconColor'] ?? const Color(0xFF9988FF),
          'iconBg': decoration['iconBg'] ?? const Color(0xFF1E1A3A),
          'title': title,
          'subtitle': subtitle,
        });
      }
    } else {
      itemsToShow.addAll(_careItems);
    }

    if (itemsToShow.isEmpty) return const SizedBox.shrink();

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
          children: itemsToShow.map((item) => _buildCareCard(item)).toList(),
        ),
      ],
    );
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
    } else if (t.contains('journal')) {
      return {
        'icon': Icons.menu_book_rounded,
        'iconColor': const Color(0xFFEEAA44),
        'iconBg': const Color(0xFF2A1E0A),
      };
    } else {
      return {
        'icon': Icons.coffee_rounded,
        'iconColor': const Color(0xFFEE6688),
        'iconBg': const Color(0xFF2A1020),
      };
    }
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

  Widget _buildEmotionalLandscapeSection() {
    final hasData =
        _dreamData?.emotionalLandscape != null &&
        _dreamData!.emotionalLandscape!.isNotEmpty;
    final List<Map<String, dynamic>> emotionsToShow = [];

    if (hasData) {
      for (var emotion in _dreamData!.emotionalLandscape!) {
        final name = emotion.name ?? '';
        final percent = emotion.percentage ?? 0;
        if (name.isEmpty) continue;

        emotionsToShow.add({
          'label': name,
          'percent': percent,
          'color': _getEmotionColor(name),
          'trackColor': _getEmotionTrackColor(name),
        });
      }
    } else {
      emotionsToShow.addAll(_emotions);
    }

    if (emotionsToShow.isEmpty) return const SizedBox.shrink();

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
            children: List.generate(emotionsToShow.length, (index) {
              final item = emotionsToShow[index];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index < emotionsToShow.length - 1 ? 18 : 0,
                ),
                child: _buildEmotionBar(item),
              );
            }),
          ),
        ),
      ],
    );
  }

  Color _getEmotionColor(String name) {
    final n = name.toLowerCase();
    if (n.contains('anxi') ||
        n.contains('fear') ||
        n.contains('stress') ||
        n.contains('overwhelm'))
      return const Color(0xFFEE4444);
    if (n.contains('confus') || n.contains('doubt') || n.contains('puzzl'))
      return const Color(0xFF4466EE);
    if (n.contains('awe') || n.contains('wonder') || n.contains('amaz'))
      return const Color(0xFF22CC88);
    return const Color(0xFF7B6EF6);
  }

  Color _getEmotionTrackColor(String name) {
    final n = name.toLowerCase();
    if (n.contains('anxi') ||
        n.contains('fear') ||
        n.contains('stress') ||
        n.contains('overwhelm'))
      return const Color(0xFF3A1A1A);
    if (n.contains('confus') || n.contains('doubt') || n.contains('puzzl'))
      return const Color(0xFF1A1A3A);
    if (n.contains('awe') || n.contains('wonder') || n.contains('amaz'))
      return const Color(0xFF0A2A1A);
    return const Color(0xFF1A1A30);
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

  Widget _buildSymbolTagsSection() {
    final hasData =
        _dreamData?.symbolTags != null && _dreamData!.symbolTags!.isNotEmpty;
    final List<String> tagsToShow = hasData
        ? _dreamData!.symbolTags!
        : _symbolTags;

    if (tagsToShow.isEmpty) return const SizedBox.shrink();

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
          children: tagsToShow.map((tag) {
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

  // ─── Save to Journal Button ───────────────────────────────────────────────────

  Widget _buildSaveButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: saveJournalResponseRxObj.isLoading,
      builder: (context, isLoading, child) {
        return Container(
          color: _bgColor,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () async {
                if (isLoading) return;
                final text = _respondController.text.trim();

                if (text.isEmpty) {
                  ToastUtil.showShortToast(
                    "The user response field is required.",
                  );
                  return;
                }

                final journalId = _dreamData?.id ?? 0;
                final success = await saveJournalResponseRxObj
                    .saveJournalResponse(
                      journalId: journalId,
                      userResponse: text,
                    );

                if (success && mounted) {
                  NavigationService.navigateToUntilReplacement(
                    Routes.userNavigationMenu,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentPurple,
                foregroundColor: _white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLoading) ...[
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ] else ...[
                    const Icon(
                      Icons.bookmark_border_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                  ],
                  const Text(
                    'Save to Journal',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerLoading() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Center(child: _buildAppBar(context)),
          const SizedBox(height: 28),

          // Shimmer Hero Header
          Center(
            child: Shimmer.fromColors(
              baseColor: Colors.white.withOpacity(0.05),
              highlightColor: Colors.white.withOpacity(0.1),
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: 180,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 120,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),

          // Shimmer Summary Card
          _buildShimmerCard(height: 120),
          const SizedBox(height: 14),

          // Shimmer Meaning Card
          _buildShimmerCard(height: 100),
          const SizedBox(height: 28),

          // Shimmer Your Respond Section
          Shimmer.fromColors(
            baseColor: Colors.white.withOpacity(0.05),
            highlightColor: Colors.white.withOpacity(0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 100, height: 12, color: Colors.white),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Shimmer Care Reflection Section
          Shimmer.fromColors(
            baseColor: Colors.white.withOpacity(0.05),
            highlightColor: Colors.white.withOpacity(0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 120, height: 12, color: Colors.white),
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
                        borderRadius: BorderRadius.circular(12),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildShimmerCard({required double height}) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.05),
      highlightColor: Colors.white.withOpacity(0.1),
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  void _shareInterpretation(BuildContext context) {
    final title = _dreamData?.title ?? 'The Endless Ocean';
    final dateAndMoods = _dreamData != null
        ? '${_dreamData!.formattedDate ?? ''}${_dreamData!.moodDisplay != null ? ' • ${_dreamData!.moodDisplay}' : ''}'
        : 'Oct 25 • Anxiety, Overwhelm';
    final summary =
        _dreamData?.summary ??
        'You were wandering through a deserted metropolis under a vivid purple sky. Losing your shoes preceded a sudden flood, leaving you wading through rising waters. You were wandering through a deserted metropolis under a vivid purple sky. Losing your shoes preceded a sudden flood, leaving you wading through rising waters....';
    final meaning =
        _dreamData?.meaning ??
        'You were wandering through a deserted metropolis under a vivid purple sky. Losing your shoes preceded a sudden flood, leaving you wading through rising waters. You were wandering through a deserted';

    final buffer = StringBuffer();
    buffer.writeln('✨ Dream Interpretation: $title ✨');
    buffer.writeln('📅 $dateAndMoods');
    buffer.writeln();
    buffer.writeln('📝 Summary:');
    buffer.writeln(summary);
    buffer.writeln();
    buffer.writeln('💡 Meaning:');
    buffer.writeln(meaning);

    // 📊 Emotional Landscape
    final List<String> emotionStrings = [];
    if (_dreamData?.emotionalLandscape != null && _dreamData!.emotionalLandscape!.isNotEmpty) {
      for (var emotion in _dreamData!.emotionalLandscape!) {
        final name = emotion.name ?? '';
        final percent = emotion.percentage ?? 0;
        if (name.isNotEmpty) {
          emotionStrings.add('• $name: $percent%');
        }
      }
    } else {
      for (var emotion in _emotions) {
        final label = emotion['label'] ?? '';
        final percent = emotion['percent'] ?? 0;
        if (label.isNotEmpty) {
          emotionStrings.add('• $label: $percent%');
        }
      }
    }

    if (emotionStrings.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('📊 Emotional Landscape:');
      for (var emotion in emotionStrings) {
        buffer.writeln(emotion);
      }
    }

    // 🧘 Care & Reflection
    final List<String> careStrings = [];
    if (_dreamData?.careReflection != null && _dreamData!.careReflection!.isNotEmpty) {
      for (var reflection in _dreamData!.careReflection!) {
        final t = reflection.title ?? '';
        final st = reflection.shortTitle ?? '';
        if (t.isNotEmpty) {
          careStrings.add(st.isNotEmpty ? '• $t ($st)' : '• $t');
        }
      }
    } else {
      for (var item in _careItems) {
        final t = item['title'] ?? '';
        final st = item['subtitle'] ?? '';
        if (t.isNotEmpty) {
          careStrings.add(st.isNotEmpty ? '• $t ($st)' : '• $t');
        }
      }
    }

    if (careStrings.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('🧘 Care & Reflection:');
      for (var care in careStrings) {
        buffer.writeln(care);
      }
    }

    // 🏷️ Symbol Tags
    final tags = _dreamData?.symbolTags ?? _symbolTags;
    if (tags.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('🏷️ Symbol Tags:');
      buffer.writeln(tags.join(', '));
    }

    final userResponse = _respondController.text.trim();
    if (userResponse.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('💭 My Response:');
      buffer.writeln(userResponse);
    }

    final box = context.findRenderObject() as RenderBox?;
    final sharePositionOrigin = box != null ? (box.localToGlobal(Offset.zero) & box.size) : null;

    SharePlus.instance.share(
      ShareParams(
        text: buffer.toString(),
        subject: 'Dream Interpretation: $title',
        sharePositionOrigin: sharePositionOrigin,
      ),
    );
  }
}
