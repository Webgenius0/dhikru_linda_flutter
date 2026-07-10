import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:dhikru_linda_flutter/features/journal/model/tags_model.dart';
import 'package:dhikru_linda_flutter/networks/api_acess.dart';

const Color _cardBg = Color(0xFF131325);
const Color _borderColor = Color(0xFF252545);
const Color _accentPurple = Color(0xFF7B6EF6);
const Color _white = Colors.white;
const Color _subtleText = Color(0xFF8888AA);

class JournalFilterChips extends StatelessWidget {
  final int? selectedTagId;
  final ValueChanged<int?> onTagSelected;

  const JournalFilterChips({
    super.key,
    required this.selectedTagId,
    required this.onTagSelected,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TagsModel>(
      stream: tagsRxObj.getTagsStream,
      builder: (context, snapshot) {
        final isLoading = snapshot.connectionState == ConnectionState.waiting;
        final tagsList = snapshot.hasData ? (snapshot.data?.data ?? []) : [];

        final List<Map<String, dynamic>> currentFilters = [
          {'id': null, 'name': 'All'},
        ];
        for (var tag in tagsList) {
          if (tag.name != null && tag.name!.isNotEmpty) {
            currentFilters.add({'id': tag.id, 'name': tag.name});
          }
        }

        if (isLoading) {
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
              final bool selected = selectedTagId == filterId;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => onTagSelected(filterId),
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
}
