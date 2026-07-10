import 'package:flutter/material.dart';
import 'package:dhikru_linda_flutter/features/journal/model/show_journal_model.dart';
import 'package:dhikru_linda_flutter/networks/api_acess.dart';
import 'package:dhikru_linda_flutter/features/journal/widgets/journal_detail_widgets.dart';

class JournalDetailScreen extends StatefulWidget {
  final Map<String, dynamic> dream;

  const JournalDetailScreen({super.key, required this.dream});

  @override
  State<JournalDetailScreen> createState() => _JournalDetailScreenState();
}

class _JournalDetailScreenState extends State<JournalDetailScreen> {
  @override
  void initState() {
    super.initState();
    showJournalRxObj.clean();
    if (widget.dream['id'] != null) {
      showJournalRxObj.showJournalDetails(journalId: widget.dream['id']);
    }
  }

  @override
  void dispose() {
    showJournalRxObj.clean();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: SafeArea(
        child: StreamBuilder<ShowJournalModel>(
          stream: showJournalRxObj.getShowJournalStream,
          builder: (context, snapshot) {
            return ValueListenableBuilder<bool>(
              valueListenable: showJournalRxObj.isLoading,
              builder: (context, apiLoading, child) {
                final isLoading =
                    apiLoading ||
                    snapshot.connectionState == ConnectionState.waiting;
                if (isLoading) {
                  return const JournalDetailShimmer();
                }

                final journalData = snapshot.data?.data;
                if (journalData == null) {
                  return const Center(
                    child: Text(
                      "No journal details found.",
                      style: TextStyle(color: Color(0xFF8888AA)),
                    ),
                  );
                }

                final String title =
                    journalData.title ??
                    widget.dream['title'] ??
                    'The Endless Ocean';
                final String date =
                    journalData.formattedDate ??
                    widget.dream['date'] ??
                    'Oct 25';

                final String badge =
                    (journalData.moodDisplay ??
                            widget.dream['badge'] as String? ??
                            'Anxiety, Overwhelm')
                        .toLowerCase();
                final String capitalizedBadge = badge
                    .split(', ')
                    .map(
                      (word) => word.isNotEmpty
                          ? (word.substring(0, 1).toUpperCase() +
                                word.substring(1))
                          : '',
                    )
                    .join(', ');
                final String subtitleText = '$date • $capitalizedBadge';

                final String summary =
                    journalData.summary ?? widget.dream['summary'] ?? '';
                final String meaning =
                    journalData.meaning ?? widget.dream['meaning'] ?? '';

                final List<Map<String, dynamic>> emotions =
                    (journalData.emotionalLandscape != null &&
                        journalData.emotionalLandscape!.isNotEmpty)
                    ? journalData.emotionalLandscape!.map((e) {
                        final color = getEmotionColor(e.name);
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

                final List<Map<String, dynamic>> careItems =
                    (journalData.careReflection != null &&
                        journalData.careReflection!.isNotEmpty)
                    ? journalData.careReflection!.map((item) {
                        final itemTitle =
                            item.shortTitle ?? item.title ?? 'Reflection';
                        final itemSubtitle =
                            item.title ?? item.shortTitle ?? '';
                        final mapping = getCareItemIconAndColors(itemTitle);
                        return {
                          'icon': mapping['icon'],
                          'iconColor': mapping['iconColor'],
                          'iconBg': mapping['iconBg'],
                          'title': itemTitle,
                          'subtitle': itemSubtitle,
                        };
                      }).toList()
                    : defaultCareItems;

                final List<String> symbolTags =
                    journalData.symbolTags ??
                    List<String>.from(widget.dream['tags'] ?? []);

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
                            JournalDetailAppBar(
                              onBackTap: () => Navigator.maybePop(context),
                              onShareTap: () => shareInterpretation(
                                context,
                                title: title,
                                subtitleText: subtitleText,
                                summary: summary,
                                meaning: meaning,
                                userResponse: journalData.userResponse,
                                emotions: emotions,
                                careItems: careItems,
                                symbolTags: symbolTags,
                              ),
                            ),
                            const SizedBox(height: 28),
                            Center(
                              child: JournalDetailHeroHeader(
                                title: title,
                                subtitleText: subtitleText,
                              ),
                            ),
                            const SizedBox(height: 28),
                            JournalDetailTextCard(
                              icon: Icons.notes_rounded,
                              title: 'Summary',
                              body: summary,
                            ),
                            const SizedBox(height: 14),
                            JournalDetailTextCard(
                              title: 'Meaning',
                              body: meaning,
                            ),
                            const SizedBox(height: 28),
                            if (journalData.userResponse != null &&
                                journalData.userResponse!
                                    .trim()
                                    .isNotEmpty) ...[
                              JournalDetailRespondSection(
                                userResponse: journalData.userResponse!,
                              ),
                              const SizedBox(height: 28),
                            ],
                            JournalDetailCareReflection(careItems: careItems),
                            const SizedBox(height: 28),
                            JournalDetailEmotionalLandscape(emotions: emotions),
                            const SizedBox(height: 28),
                            JournalDetailSymbolTags(symbolTags: symbolTags),
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
}
