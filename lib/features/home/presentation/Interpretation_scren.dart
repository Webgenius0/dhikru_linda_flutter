import 'package:flutter/material.dart';
import 'package:dhikru_linda_flutter/helpers/all_routes.dart';
import 'package:dhikru_linda_flutter/helpers/navigation_service.dart';
import 'package:dhikru_linda_flutter/helpers/toast.dart';

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
              child: SingleChildScrollView(
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

                    // ── NEW: Summary card ──
                    _buildTextCard(
                      icon: Icons.list_rounded,
                      iconColor: _accentPurple,
                      title: 'Summary',
                      body:
                          'You were wandering through a deserted metropolis under a vivid purple sky. Losing your shoes preceded a sudden flood, leaving you wading through rising waters. You were wandering through a deserted metropolis under a vivid purple sky. Losing your shoes preceded a sudden flood, leaving you wading through rising waters....',
                    ),
                    const SizedBox(height: 14),

                    // ── NEW: Meaning card ──
                    _buildTextCard(
                      title: 'Meaning',
                      body:
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
      bottomNavigationBar: Padding(
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

  Widget _buildHeroHeader() {
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
        const Text(
          'The Endless Ocean',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _white,
            fontSize: 26,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        // Date + tags
        const Text(
          'Oct 25 • Anxiety, Overwhelm',
          textAlign: TextAlign.center,
          style: TextStyle(
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
          children: _careItems.map((item) => _buildCareCard(item)).toList(),
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

  Widget _buildEmotionalLandscapeSection() {
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
            children: List.generate(_emotions.length, (index) {
              final item = _emotions[index];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index < _emotions.length - 1 ? 18 : 0,
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

  Widget _buildSymbolTagsSection() {
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
          children: _symbolTags.map((tag) {
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
    return Container(
      color: _bgColor,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: () {
            ToastUtil.showShortToast('Save to Journal');
            NavigationService.navigateToUntilReplacement(Routes.userNavigationMenu);
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
            children: const [
              Icon(
                Icons.bookmark_border_rounded,
                size: 20,
                color: Colors.white,
              ),
              SizedBox(width: 8),
              Text(
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
  }
}
