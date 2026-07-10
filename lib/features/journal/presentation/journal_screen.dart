import 'package:flutter/material.dart';
import 'package:dhikru_linda_flutter/features/journal/presentation/journal_detail_screen.dart';
import 'package:dhikru_linda_flutter/features/journal/model/tags_model.dart'
    hide Datum;
import 'package:dhikru_linda_flutter/features/journal/model/get_all_journal_model.dart';
import 'package:dhikru_linda_flutter/networks/api_acess.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class JournalScreen extends StatefulWidget {
  final VoidCallback? onGoHome;
  final int? tagId;

  const JournalScreen({super.key, this.onGoHome, this.tagId});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  // ─── Colors ─────────────────────────────────────────────────────────────────
  static const Color _bgColor = Color(0xFF0D0D1A);
  static const Color _cardBg = Color(0xFF131325);
  static const Color _borderColor = Color(0xFF252545);
  static const Color _accentPurple = Color(0xFF7B6EF6);
  static const Color _white = Colors.white;
  static const Color _subtleText = Color(0xFF8888AA);
  static const Color _tagBg = Color(0xFF1A1A35);
  static const Color _tagText = Color(0xFF7777BB);
  static const Color _searchBg = Color(0xFF131325);

  // ─── State ──────────────────────────────────────────────────────────────────
  int? _selectedTagId;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedTagId = widget.tagId;
    tagsRxObj.getTags();
    getAllJournalRxObj.getJournalEntries(tagId: _selectedTagId);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void didUpdateWidget(covariant JournalScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tagId != widget.tagId) {
      setState(() {
        _selectedTagId = widget.tagId;
      });
      getAllJournalRxObj.getJournalEntries(tagId: _selectedTagId);
    }
  }

  void _onSearchChanged() {
    setState(() {});
  }

  void _filterByTagName(String name) {
    final tagsModel = tagsRxObj.dataFetcher.valueOrNull;
    if (tagsModel != null && tagsModel.data != null) {
      final tagsList = tagsModel.data ?? [];
      for (final tag in tagsList) {
        if (tag.name?.toLowerCase() == name.toLowerCase()) {
          final tagId = tag.id;
          setState(() {
            _selectedTagId = tagId;
          });
          getAllJournalRxObj.getJournalEntries(tagId: tagId);
          return;
        }
      }
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // Mood color and emoji mapping helper
  Map<String, dynamic> _getMoodAssets(String? mood) {
    final m = (mood ?? '').toLowerCase();
    if (m.contains('longing') || m.contains('wave') || m.contains('🌊')) {
      return {
        'emoji': '🌊',
        'emojiColor': const Color(0xFF4ECFB5),
        'badge': 'LONGING',
        'badgeColor': const Color(0xFF3A2A60),
        'badgeTextColor': const Color(0xFFBBAAFF),
        'leftAccent': const Color(0xFF7B6EF6),
      };
    } else if (m.contains('calm') ||
        m.contains('leaf') ||
        m.contains('🌿') ||
        m.contains('peaceful')) {
      return {
        'emoji': '🌿',
        'emojiColor': const Color(0xFF6FCF6F),
        'badge': 'CALM',
        'badgeColor': const Color(0xFF1A3A2A),
        'badgeTextColor': const Color(0xFF6FCF6F),
        'leftAccent': const Color(0xFF6FCF6F),
      };
    } else if (m.contains('euphoric') ||
        m.contains('star') ||
        m.contains('✦') ||
        m.contains('wonder')) {
      return {
        'emoji': '✦',
        'emojiColor': const Color(0xFFFFD700),
        'badge': 'EUPHORIC',
        'badgeColor': const Color(0xFF2A2A10),
        'badgeTextColor': const Color(0xFFFFD060),
        'leftAccent': const Color(0xFFFFD700),
      };
    } else {
      // Default / fallback
      return {
        'emoji': '✨',
        'emojiColor': const Color(0xFFFFC0CB),
        'badge': mood?.toUpperCase() ?? 'DREAM',
        'badgeColor': const Color(0xFF221144),
        'badgeTextColor': const Color(0xFFFFD0FF),
        'leftAccent': const Color(0xFF7B6EF6),
      };
    }
  }

  Map<String, dynamic> _mapDatumToDreamMap(Datum item) {
    final moodAssets = _getMoodAssets(item.moodDisplay);
    return {
      'id': item.id,
      'emoji': moodAssets['emoji'],
      'emojiColor': moodAssets['emojiColor'],
      'title': item.title ?? 'Untitled Dream',
      'date': item.formattedDate ?? '',
      'badge': moodAssets['badge'],
      'badgeColor': moodAssets['badgeColor'],
      'badgeTextColor': moodAssets['badgeTextColor'],
      'description': item.summary ?? '',
      'tags': item.symbolTags ?? <String>[],
      'leftAccent': moodAssets['leftAccent'],
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + 16),
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
              child: StreamBuilder<GetAllJournalModel>(
                stream: getAllJournalRxObj.getJournalStream,
                builder: (context, snapshot) {
                  return ValueListenableBuilder<bool>(
                    valueListenable: getAllJournalRxObj.isLoading,
                    builder: (context, apiLoading, child) {
                      final isLoading =
                          apiLoading ||
                          snapshot.connectionState == ConnectionState.waiting;
                      final journalList = snapshot.hasData
                          ? (snapshot.data?.data ?? [])
                          : [];

                      if (isLoading) {
                        return ListView.separated(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: 25,
                          ),
                          itemCount: journalList.isEmpty
                              ? 4
                              : journalList.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) =>
                              _buildShimmerDreamCard(),
                        );
                      }

                      // Client-side search filtering using title
                      final String query = _searchController.text.toLowerCase();
                      final filteredList = journalList.where((item) {
                        final titleMatch = (item.title ?? '')
                            .toLowerCase()
                            .contains(query);
                        return titleMatch;
                      }).toList();

                      if (filteredList.isEmpty) {
                        return Center(
                          child: Text(
                            'No journal entries found.',
                            style: TextStyle(color: _subtleText, fontSize: 14),
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: 35,
                        ),
                        itemCount: filteredList.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = filteredList[index];
                          final dreamMap = _mapDatumToDreamMap(item);
                          return _buildDreamCard(dreamMap);
                        },
                      );
                    },
                  );
                },
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
          onTap: () {
            if (widget.onGoHome != null) {
              widget.onGoHome!();
            } else if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          child: Container(
            width: 40.w,
            height: 40.w,
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
    return StreamBuilder<TagsModel>(
      stream: tagsRxObj.getTagsStream,
      builder: (context, snapshot) {
        final isLoading = snapshot.connectionState == ConnectionState.waiting;
        final tagsList = snapshot.hasData ? (snapshot.data?.data ?? []) : [];

        // Combine 'All' with fetched tags
        final List<Map<String, dynamic>> currentFilters = [
          {'id': null, 'name': 'All'},
        ];
        for (var tag in tagsList) {
          if (tag.name != null && tag.name!.isNotEmpty) {
            currentFilters.add({'id': tag.id, 'name': tag.name});
          }
        }

        if (isLoading) {
          // Show shimmer effect for filter chips
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(4, (index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Shimmer.fromColors(
                    baseColor: Colors.white.withOpacity(0.05),
                    highlightColor: Colors.white.withOpacity(0.1),
                    child: Container(
                      width: 70 + (index * 10.0),
                      height: 38,
                      decoration: BoxDecoration(
                        color: _cardBg,
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: currentFilters.map((filter) {
              final filterName = filter['name'] as String;
              final filterId = filter['id'] as int?;
              final bool selected = _selectedTagId == filterId;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTagId = filterId;
                    });
                    getAllJournalRxObj.getJournalEntries(tagId: filterId);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? _accentPurple : _cardBg,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: selected ? _accentPurple : _borderColor,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      filterName,
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
      },
    );
  }

  Widget _buildShimmerDreamCard() {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.05),
      highlightColor: Colors.white.withOpacity(0.1),
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _borderColor, width: 1),
        ),
      ),
    );
  }

  // ─── Dream Card ──────────────────────────────────────────────────────────────

  Widget _buildDreamCard(Map<String, dynamic> dream) {
    final Color accent = dream['leftAccent'] as Color;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JournalDetailScreen(dream: dream),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 16, 16, 14),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Emoji bubble
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: (dream['emojiColor'] as Color).withOpacity(
                            0.12,
                          ),
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
                          horizontal: 8,
                          vertical: 4,
                        ),
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
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: (dream['tags'] as List<String>).map((tag) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () => _filterByTagName(tag),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
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
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
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
                decoration: BoxDecoration(
                  color: accent,
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
