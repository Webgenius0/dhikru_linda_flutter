import 'package:dhikru_linda_flutter/helpers/all_routes.dart';
import 'package:dhikru_linda_flutter/helpers/navigation_service.dart';
import 'package:dhikru_linda_flutter/networks/api_acess.dart';
import 'package:dhikru_linda_flutter/features/journal/model/tags_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:speech_to_text/speech_to_text.dart';

class NewDrimeEnterScreen extends StatefulWidget {
  const NewDrimeEnterScreen({super.key});

  @override
  State<NewDrimeEnterScreen> createState() => _NewDrimeEnterScreenState();
}

class _NewDrimeEnterScreenState extends State<NewDrimeEnterScreen> {
  // ─── Colors ─────────────────────────────────────────────────────────────────
  static const Color _bgColor = Color(0xFF0D0D1A);
  static const Color _cardBg = Color(0xFF131325);
  static const Color _inputBg = Color(0xFF131325);
  static const Color _borderColor = Color(0xFF252545);
  static const Color _accentPurple = Color(0xFF7B6EF6);
  static const Color _white = Colors.white;
  static const Color _subtleText = Color(0xFF8888AA);
  static const Color _labelText = Color(0xFF6666AA);
  static const Color _tagBg = Color(0xFF1A1A35);
  static const Color _tagBorder = Color(0xFF2A2A55);
  static const Color _tagText = Color(0xFF9999CC);
  static const Color _voiceBg = Color(0xFF1E1A45);
  static const Color _dateBg = Color(0xFF131325);

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  final Set<int> _selectedTagIds = {};

  @override
  void initState() {
    super.initState();
    tagsRxObj.getTags();
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
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── Scrollable body ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildAppBar(context),
                    const SizedBox(height: 24),
                    _buildDatePicker(),
                    const SizedBox(height: 24),
                    _buildDreamTitleField(),
                    const SizedBox(height: 24),
                    _buildDescribeField(),
                    const SizedBox(height: 26),
                    _buildQuickTags(),
                    const SizedBox(height: 100), // space for bottom button
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // ── Floating bottom button ──
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 45),
        child: _buildInterpretButton(),
      ),
    );
  }

  // ─── App Bar ────────────────────────────────────────────────────────────────

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
          'New Dream Entry',
          style: TextStyle(
            color: _white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  // ─── Date Picker ────────────────────────────────────────────────────────────

  Widget _buildDatePicker() {
    final String currentDate = DateFormat(
      'EEEE, MMMM d, yyyy',
    ).format(DateTime.now());

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _dateBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor, width: 1),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.calendar_today_rounded,
            color: _accentPurple,
            size: 16,
          ),
          const SizedBox(width: 10),
          Text(
            currentDate,
            style: const TextStyle(
              color: _white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Dream Title ────────────────────────────────────────────────────────────

  Widget _buildDreamTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'DREAM TITLE',
          style: TextStyle(
            color: _labelText,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: _inputBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _borderColor, width: 1),
          ),
          child: TextField(
            controller: _titleController,
            style: const TextStyle(color: _white, fontSize: 14),
            decoration: const InputDecoration(
              hintText: 'Give your dream a name...',
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

  // ─── Describe Your Dream ────────────────────────────────────────────────────

  Widget _buildDescribeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label row with Voice button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'DESCRIBE YOUR DREAM',
              style: TextStyle(
                color: _labelText,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.6,
              ),
            ),
            _buildVoiceButton(),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: _inputBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _borderColor, width: 1),
          ),
          child: TextField(
            controller: _descController,
            maxLines: 6,
            style: const TextStyle(color: _white, fontSize: 14, height: 1.55),
            decoration: const InputDecoration(
              hintText:
                  'I was flying over a vast violet ocean, when suddenly...',
              hintStyle: TextStyle(
                color: _subtleText,
                fontSize: 14,
                height: 1.55,
              ),
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

  Widget _buildVoiceButton() {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => _VoiceRecordingBottomSheetContent(
            controller: _descController,
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _voiceBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _accentPurple.withOpacity(0.4),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.mic_rounded,
              color: _accentPurple,
              size: 14,
            ),
            const SizedBox(width: 5),
            Text(
              'Voice',
              style: TextStyle(
                color: _accentPurple,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Quick Tags ─────────────────────────────────────────────────────────────

  Widget _buildQuickTags() {
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
        StreamBuilder<TagsModel>(
          stream: tagsRxObj.getTagsStream,
          builder: (context, snapshot) {
            final isLoading = snapshot.connectionState == ConnectionState.waiting;
            final tagsList = snapshot.hasData ? (snapshot.data?.data ?? []) : [];

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

                final bool selected = _selectedTagIds.contains(tagId);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (selected) {
                        _selectedTagIds.remove(tagId);
                      } else {
                        _selectedTagIds.add(tagId);
                      }
                    });
                    debugPrint("Selected tags IDs: ${_selectedTagIds.toList()}");
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? _accentPurple.withOpacity(0.18) : _tagBg,
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
                        fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  // ─── Bottom Interpret Button ─────────────────────────────────────────────────

  Widget _buildInterpretButton() {
    return Container(
      color: _bgColor,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: () {
            NavigationService.navigateTo(Routes.interpretationScren);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _accentPurple,
            foregroundColor: _white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('✦', style: TextStyle(fontSize: 16, color: Colors.white)),
              SizedBox(width: 8),
              Text(
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
  }
}

class _VoiceRecordingBottomSheetContent extends StatefulWidget {
  final TextEditingController controller;

  const _VoiceRecordingBottomSheetContent({
    required this.controller,
  });

  @override
  State<_VoiceRecordingBottomSheetContent> createState() => _VoiceRecordingBottomSheetContentState();
}

class _VoiceRecordingBottomSheetContentState extends State<_VoiceRecordingBottomSheetContent> with SingleTickerProviderStateMixin {
  late final SpeechToText _speech;
  bool _isListening = false;
  late final String _originalText;
  String _currentSpeechText = '';
  bool _isInitialized = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _speech = SpeechToText();
    _originalText = widget.controller.text;
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
      lowerBound: 0.6,
      upperBound: 1.0,
    )..repeat(reverse: true);
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    try {
      bool available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            if (mounted) {
              setState(() {
                _isListening = false;
              });
            }
          }
        },
        onError: (errorNotification) {
          if (mounted) {
            setState(() {
              _isListening = false;
            });
          }
        },
      );

      if (available && mounted) {
        setState(() {
          _isInitialized = true;
        });
        _startListening();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Speech recognition is not available or permission denied.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to initialize speech recognition: $e')),
        );
      }
    }
  }

  void _startListening() async {
    if (!_isInitialized) return;
    setState(() {
      _isListening = true;
    });
    await _speech.listen(
      onResult: (result) {
        if (mounted) {
          setState(() {
            _currentSpeechText = result.recognizedWords;
            widget.controller.text = _originalText.isEmpty
                ? _currentSpeechText
                : '$_originalText $_currentSpeechText';
          });
        }
      },
    );
  }

  void _stopListening() async {
    await _speech.stop();
    if (mounted) {
      setState(() {
        _isListening = false;
      });
    }
  }

  @override
  void dispose() {
    _speech.stop();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String displayText = widget.controller.text.isEmpty
        ? 'Speak now to write your dream...'
        : widget.controller.text;
    final bool isEmpty = widget.controller.text.isEmpty;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).padding.bottom + 24),
      decoration: const BoxDecoration(
        color: Color(0xFF131325),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 20,
            spreadRadius: 5,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 24),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isListening) ...[
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEE4444),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFEE4444).withOpacity(0.5 * _pulseController.value),
                            blurRadius: 6,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
              ],
              Text(
                _isListening ? 'Listening...' : 'Recording Paused',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Live Text Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: const Color(0xFF0D0D1A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF252545), width: 1),
            ),
            constraints: const BoxConstraints(minHeight: 120, maxHeight: 180),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Text(
                displayText,
                style: TextStyle(
                  color: isEmpty ? Colors.white.withOpacity(0.35) : Colors.white,
                  fontSize: 14,
                  height: 1.6,
                  fontStyle: isEmpty ? FontStyle.italic : FontStyle.normal,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Pulsing Glow Microphone Button
          Center(
            child: GestureDetector(
              onTap: () {
                if (_isListening) {
                  _stopListening();
                } else {
                  _startListening();
                }
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer Glow Animation
                  if (_isListening)
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Container(
                          width: 84 * _pulseController.value,
                          height: 84 * _pulseController.value,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF7B6EF6).withOpacity(0.15 * (1.0 - _pulseController.value + 0.3)),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF7B6EF6).withOpacity(0.2),
                                blurRadius: 20,
                                spreadRadius: 5,
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  Container(
                    width: 74,
                    height: 74,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: _isListening
                            ? [const Color(0xFFFF5252), const Color(0xFFFF1744)]
                            : [const Color(0xFF9E85F5), const Color(0xFF634DF2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (_isListening ? const Color(0xFFFF1744) : const Color(0xFF634DF2)).withOpacity(0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Icon(
                      _isListening ? Icons.stop_rounded : Icons.mic_rounded,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 36),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    widget.controller.text = _originalText;
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF252545)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Color(0xFF8888AA),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7B6EF6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Done',
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
        ],
      ),
    );
  }
}
