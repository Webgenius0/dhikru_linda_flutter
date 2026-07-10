import 'package:flutter/material.dart';
import 'package:dhikru_linda_flutter/features/journal/model/get_all_journal_model.dart';
import 'package:dhikru_linda_flutter/networks/api_acess.dart';
import 'package:dhikru_linda_flutter/features/journal/widgets/journal_widgets.dart';
import 'package:dhikru_linda_flutter/features/journal/presentation/journal_detail_screen.dart';

class JournalScreen extends StatefulWidget {
  final VoidCallback? onGoHome;
  final int? tagId;

  const JournalScreen({super.key, this.onGoHome, this.tagId});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  static const Color _bgColor = Color(0xFF0D0D1A);
  static const Color _subtleText = Color(0xFF8888AA);

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
                  JournalAppBar(onGoHome: widget.onGoHome),
                  const SizedBox(height: 20),
                  JournalSearchBar(controller: _searchController),
                  const SizedBox(height: 16),
                  JournalFilterChips(
                    selectedTagId: _selectedTagId,
                    onTagSelected: (tagId) {
                      setState(() {
                        _selectedTagId = tagId;
                      });
                      getAllJournalRxObj.getJournalEntries(tagId: tagId);
                    },
                  ),
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
                      final journalList = snapshot.hasData ? (snapshot.data?.data ?? []) : [];

                      if (isLoading) {
                        return ListView.separated(
                          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 25),
                          itemCount: journalList.isEmpty ? 4 : journalList.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) => const JournalShimmerDreamCard(),
                        );
                      }

                      final String query = _searchController.text.toLowerCase();
                      final filteredList = journalList.where((item) {
                        final titleMatch = (item.title ?? '').toLowerCase().contains(query);
                        return titleMatch;
                      }).toList();

                      if (filteredList.isEmpty) {
                        return const Center(
                          child: Text(
                            'No journal entries found.',
                            style: TextStyle(color: _subtleText, fontSize: 14),
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 35),
                        itemCount: filteredList.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = filteredList[index];
                          final dreamMap = MoodHelper.mapDatumToDreamMap(item);
                          return JournalDreamCard(
                            dream: dreamMap,
                            onTagTap: _filterByTagName,
                            index: index,
                            onTap: (updatedDream) async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JournalDetailScreen(dream: updatedDream),
                                ),
                              );
                              _searchController.clear();
                            },
                          );
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
}
