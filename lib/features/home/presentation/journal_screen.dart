import 'package:flutter/material.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  // ─── Colors ─────────────────────────────────────────────────────────────────
  static const Color _bgColor      = Color(0xFF0D0D1A);
  static const Color _cardBg       = Color(0xFF131325);
  static const Color _borderColor  = Color(0xFF252545);
  static const Color _accentPurple = Color(0xFF7B6EF6);
  static const Color _white        = Colors.white;
  static const Color _subtleText   = Color(0xFF8888AA);
  static const Color _labelText    = Color(0xFF6666AA);
  static const Color _tagBg        = Color(0xFF1A1A35);
  static const Color _tagText      = Color(0xFF7777BB);
  static const Color _searchBg     = Color(0xFF131325);

  // ─── State ──────────────────────────────────────────────────────────────────
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filters = ['All', 'Water', 'Flying', 'Nature', 'Surreal'];

  final List<Map<String, dynamic>> _dreams = [
    {
      'emoji': '🌊',
      'emojiColor': Color(0xFF4ECFB5),
      'title': 'The Endless Ocean',
      'date': 'Apr 28',
      'badge': 'LONGING',
      'badgeColor': Color(0xFF3A2A60),
      'badgeTextColor': Color(0xFFBBAAFF),
      'description':
      'Floating in vast dark water, a lighthouse calling me forward from the distance.',
      'tags': ['#water', '#freedom'],
      'leftAccent': Color(0xFF7B6EF6),
    },
    {
      'emoji': '🌿',
      'emojiColor': Color(0xFF6FCF6F),
      'title': 'Forest of Whispers',
      'date': 'Apr 26',
      'badge': 'CALM',
      'badgeColor': Color(0xFF1A3A2A),
      'badgeTextColor': Color(0xFF6FCF6F),
      'description':
      'Ancient trees spoke in a language I almost understood, leaves forming words.',
      'tags': ['#nature', '#mystery'],
      'leftAccent': Color(0xFF6FCF6F),
    },
    {
      'emoji': '✦',
      'emojiColor': Color(0xFFFFD700),
      'title': 'City in the Clouds',
      'date': 'Apr 24',
      'badge': 'EUPHORIC',
      'badgeColor': Color(0xFF2A2A10),
      'badgeTextColor': Color(0xFFFFD060),
      'description':
      'A floating metropolis above the clouds where everyone flew effortlessly.',
      'tags': ['#flying', '#wonder'],
      'leftAccent': Color(0xFFFFD700),
    },
  ];

  List<Map<String, dynamic>> get _filteredDreams {
    if (_selectedFilter == 'All') return _dreams;
    return _dreams.where((d) {
      final tags = (d['tags'] as List<String>).join(' ');
      return tags.toLowerCase().contains(_selectedFilter.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAppBar(context),
                  const SizedBox(height: 20),
                  _buildSearchBar(),
                  const SizedBox(height: 16),
                  _buildFilterChips(),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filteredDreams.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) =>
                    _buildDreamCard(_filteredDreams[index]),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ─── App Bar ─────────────────────────────────────────────────────────────────

  Widget _buildAppBar(BuildContext context) {
    return Row(
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
          'Journal',
          style: TextStyle(
            color: _white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  // ─── Search Bar ──────────────────────────────────────────────────────────────

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: _searchBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor, width: 1),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: _white, fontSize: 14),
        decoration: const InputDecoration(
          hintText: 'Search dreams',
          hintStyle: TextStyle(color: _subtleText, fontSize: 14),
          prefixIcon: Icon(Icons.search_rounded, color: _subtleText, size: 20),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 13),
        ),
      ),
    );
  }

  // ─── Filter Chips ────────────────────────────────────────────────────────────

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _filters.map((filter) {
          final bool selected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = filter),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 9),
                decoration: BoxDecoration(
                  color: selected ? _accentPurple : _cardBg,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: selected ? _accentPurple : _borderColor,
                    width: 1,
                  ),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    color: selected ? _white : _subtleText,
                    fontSize: 13,
                    fontWeight: selected
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─── Dream Card ──────────────────────────────────────────────────────────────

  Widget _buildDreamCard(Map<String, dynamic> dream) {
    final Color accent = dream['leftAccent'] as Color;

    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor, width: 1),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left color accent bar
            Container(
              width: 3.5,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            // Card content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 16, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Emoji bubble
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: (dream['emojiColor'] as Color)
                                .withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              dream['emoji'] as String,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Title + date
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dream['title'] as String,
                                style: const TextStyle(
                                  color: _white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.2,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                dream['date'] as String,
                                style: const TextStyle(
                                  color: _subtleText,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: dream['badgeColor'] as Color,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            dream['badge'] as String,
                            style: TextStyle(
                              color: dream['badgeTextColor'] as Color,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Description
                    Text(
                      dream['description'] as String,
                      style: const TextStyle(
                        color: Color(0xFFAAAAAC),
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Tags
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children:
                      (dream['tags'] as List<String>).map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
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
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}