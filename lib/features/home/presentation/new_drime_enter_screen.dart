import 'package:flutter/material.dart';
import 'package:dhikru_linda_flutter/helpers/all_routes.dart';
import 'package:dhikru_linda_flutter/helpers/navigation_service.dart';
import 'package:dhikru_linda_flutter/helpers/toast.dart';
import 'package:dhikru_linda_flutter/networks/api_acess.dart';
import 'package:dhikru_linda_flutter/features/home/widgets/home_widgets.dart';

class NewDrimeEnterScreen extends StatefulWidget {
  const NewDrimeEnterScreen({super.key});

  @override
  State<NewDrimeEnterScreen> createState() => _NewDrimeEnterScreenState();
}

class _NewDrimeEnterScreenState extends State<NewDrimeEnterScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final Set<int> _selectedTagIds = {};
  bool _isVoiceEntry = false;

  @override
  void initState() {
    super.initState();
    tagsRxObj.getTags();
    _descController.addListener(() {
      if (_descController.text.isEmpty && _isVoiceEntry) {
        setState(() {
          _isVoiceEntry = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
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
                    _buildAppBar(context),
                    const SizedBox(height: 24),
                    const NewDreamDatePicker(),
                    const SizedBox(height: 24),
                    NewDreamTitleField(controller: _titleController),
                    const SizedBox(height: 24),
                    NewDreamDescribeField(
                      controller: _descController,
                      isVoiceEntry: _isVoiceEntry,
                      onVoiceEntryChanged: (isVoice) {
                        setState(() {
                          _isVoiceEntry = isVoice;
                        });
                      },
                    ),
                    const SizedBox(height: 26),
                    NewDreamQuickTags(
                      selectedTagIds: _selectedTagIds,
                      onTagTapped: (tagId, selected) {
                        setState(() {
                          if (selected) {
                            _selectedTagIds.remove(tagId);
                          } else {
                            _selectedTagIds.add(tagId);
                          }
                        });
                        debugPrint(
                          "Selected tags IDs: ${_selectedTagIds.toList()}",
                        );
                      },
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 45),
        child: _buildInterpretButton(),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF131325),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF252545), width: 1),
            ),
            child: const Icon(
              Icons.chevron_left_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
        const SizedBox(width: 14),
        const Text(
          'New dream entry',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  bool _containsSensitiveContent(String title, String content) {
    final sensitiveKeywords = [
      'suicide',
      'suicidal',
      'kill myself',
      'killing myself',
      'self-harm',
      'harm myself',
      'hurt myself',
      'end my life',
      'ending my life',
      'extremely low',
      'want to die',
      'wishing to die',
      'depression',
      'depressed',
      'abuse',
      'murder',
      'violence',
    ];
    final lowerTitle = title.toLowerCase();
    final lowerContent = content.toLowerCase();
    return sensitiveKeywords.any(
      (keyword) =>
          lowerTitle.contains(keyword) || lowerContent.contains(keyword),
    );
  }

  Future<bool?> _showSensitiveWarningDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: const BoxDecoration(
                  color: Color(0xFFFEEBD0),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.warning_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Sensitive Content',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF1D1D3A),
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'This dream contains intense themes. Would you like to proceed?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF8C8CA8),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7B6EF6),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInterpretButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: newJournalEntryRxObj.isLoading,
      builder: (context, isLoading, child) {
        return Container(
          color: const Color(0xFF0D0D1A),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () async {
                if (isLoading) return;
                final title = _titleController.text.trim();
                final content = _descController.text.trim();

                if (title.isEmpty) {
                  ToastUtil.showShortToast(
                    "Please enter a title for your dream.",
                  );
                  return;
                }
                if (content.isEmpty) {
                  ToastUtil.showShortToast(
                    "Please describe your dream or record your voice.",
                  );
                  return;
                }

                bool proceed = true;
                if (_containsSensitiveContent(title, content)) {
                  proceed = await _showSensitiveWarningDialog(context) ?? false;
                }
                if (!proceed) return;

                final success = await newJournalEntryRxObj.addNewJournalEntry(
                  title: title,
                  content: _isVoiceEntry ? null : content,
                  contentVoice: _isVoiceEntry ? content : null,
                  tagIds: _selectedTagIds.toList(),
                );

                if (success && mounted) {
                  final entryModel =
                      newJournalEntryRxObj.dataFetcher.valueOrNull;
                  if (entryModel != null && entryModel.data != null) {
                    NavigationService.navigateTo(
                      Routes.interpretationScren,
                      arguments: entryModel.data,
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7B6EF6),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
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
                    const Text(
                      '✦',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                  ],
                  const Text(
                    'Interpret My Dream',
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
}
