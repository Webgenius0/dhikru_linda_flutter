import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dhikru_linda_flutter/networks/api_acess.dart';
import 'package:dhikru_linda_flutter/features/journal/model/tags_model.dart';

const Color _labelText = Color(0xFF6666AA);
const Color _inputBg = Color(0xFF131325);
const Color _borderColor = Color(0xFF252545);
const Color _cardBg = Color(0xFF131325);
const Color _subtleText = Color(0xFF8888AA);
const Color _accentPurple = Color(0xFF7B6EF6);
const Color _tagBg = Color(0xFF1A1A35);
const Color _tagBorder = Color(0xFF2A2A55);
const Color _tagText = Color(0xFF9999CC);

class NewDreamQuickTags extends StatelessWidget {
  final Set<int> selectedTagIds;
  final Function(int, bool) onTagTapped;

  const NewDreamQuickTags({
    super.key,
    required this.selectedTagIds,
    required this.onTagTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'QUICK TAGS',
          style: TextStyle(
            color: _labelText,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(height: 14),
        Container(
          height: 200.h,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: _inputBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _borderColor, width: 1),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            child: StreamBuilder<TagsModel>(
              stream: tagsRxObj.getTagsStream,
              builder: (context, snapshot) {
                final isLoading =
                    snapshot.connectionState == ConnectionState.waiting;
                final tagsList = snapshot.hasData
                    ? (snapshot.data?.data ?? [])
                    : [];

                if (isLoading) {
                  return Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(6, (index) {
                      return Shimmer.fromColors(
                        baseColor: Colors.white.withOpacity(0.05),
                        highlightColor: Colors.white.withOpacity(0.1),
                        child: Container(
                          width: 60.0 + (index * 8.0),
                          height: 36,
                          decoration: BoxDecoration(
                            color: _cardBg,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      );
                    }),
                  );
                }

                if (tagsList.isEmpty) {
                  return const Text(
                    'No tags found',
                    style: TextStyle(color: _subtleText, fontSize: 13),
                  );
                }

                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: tagsList.map((tag) {
                    final int tagId = tag.id ?? 0;
                    final String tagName = tag.name ?? '';
                    if (tagName.isEmpty) return const SizedBox.shrink();

                    final bool selected = selectedTagIds.contains(tagId);
                    return GestureDetector(
                      onTap: () {
                        onTagTapped(tagId, selected);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? _accentPurple.withOpacity(0.18)
                              : _tagBg,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: selected ? _accentPurple : _tagBorder,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          tagName.startsWith('#') ? tagName : '#$tagName',
                          style: TextStyle(
                            color: selected ? _accentPurple : _tagText,
                            fontSize: 13,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
