import 'package:flutter/material.dart';
import 'package:dhikru_linda_flutter/helpers/all_routes.dart';
import 'package:dhikru_linda_flutter/helpers/navigation_service.dart';
import 'package:dhikru_linda_flutter/helpers/toast.dart';
import 'package:dhikru_linda_flutter/features/journal/model/new_journal_entry_model.dart';
import 'package:dhikru_linda_flutter/features/journal/model/send_journal_message_model.dart';
import 'package:dhikru_linda_flutter/networks/api_acess.dart';
import 'package:dhikru_linda_flutter/features/home/widgets/home_widgets.dart';
import 'package:share_plus/share_plus.dart';

class InterpretationScren extends StatefulWidget {
  const InterpretationScren({super.key});

  @override
  State<InterpretationScren> createState() => _InterpretationScrenState();
}

class _InterpretationScrenState extends State<InterpretationScren> {
  final TextEditingController _respondController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
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
        if (_dreamData!.userResponse != null &&
            _dreamData!.userResponse!.isNotEmpty) {
          _messages.add(
            ChatMessage(
              sender: 'user',
              message: _dreamData!.userResponse!,
            ),
          );
        }
      }
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _respondController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = InterpretationAppBar(
      onBackTap: () => Navigator.maybePop(context),
      onShareTap: () => _shareInterpretation(context),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _isLoading
                  ? InterpretationShimmer(appBar: appBar)
                  : SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Center(child: appBar),
                          const SizedBox(height: 28),
                          Center(
                            child: InterpretationHeroHeader(
                              dreamData: _dreamData,
                            ),
                          ),
                          const SizedBox(height: 28),
                          InterpretationTextCard(
                            icon: Icons.list_rounded,
                            title: 'Summary',
                            body: _dreamData?.summary ?? '',
                          ),
                          const SizedBox(height: 14),
                          InterpretationTextCard(
                            title: 'Meaning',
                            body: _dreamData?.meaning ?? '',
                          ),
                          const SizedBox(height: 28),
                          InterpretationCareReflection(dreamData: _dreamData),
                          const SizedBox(height: 28),
                          InterpretationEmotionalLandscape(
                            dreamData: _dreamData,
                          ),
                          const SizedBox(height: 28),
                          InterpretationSymbolTags(dreamData: _dreamData),
                          if (_messages.isNotEmpty) ...[
                            const SizedBox(height: 28),
                            InterpretationChatBubbles(messages: _messages),
                          ],
                          const SizedBox(height: 28),
                          InterpretationRespondSection(
                            controller: _respondController,
                          ),
                          const SizedBox(height: 25),
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
              padding: const EdgeInsets.only(bottom: 20),
              child: InterpretationSaveButton(
                onExit: () async {
                  final journalId = _dreamData?.id ?? 0;
                  String responseText = _respondController.text.trim();

                  if (responseText.isEmpty && _messages.isNotEmpty) {
                    final userMsgs = _messages.where(
                      (m) =>
                          m.sender == 'user' &&
                          (m.message?.trim().isNotEmpty ?? false),
                    );
                    if (userMsgs.isNotEmpty) {
                      responseText = userMsgs.last.message!.trim();
                    }
                  }

                  if (journalId != 0 && responseText.isNotEmpty) {
                    await saveJournalResponseRxObj.saveJournalResponse(
                      journalId: journalId,
                      userResponse: responseText,
                    );
                  }

                  if (mounted) {
                    NavigationService.navigateToUntilReplacement(
                      Routes.userNavigationMenu,
                    );
                  }
                },
                onSend: () async {
                  final text = _respondController.text.trim();
                  if (text.isEmpty) {
                    ToastUtil.showShortToast(
                      "The user response field is required.",
                      forceShow: true,
                    );
                    return;
                  }
                  final journalId = _dreamData?.id ?? 0;
                  if (journalId == 0) {
                    ToastUtil.showShortToast(
                      "Invalid journal entry ID.",
                      forceShow: true,
                    );
                    return;
                  }
                  final response = await sendJournalMessageRxObj.sendMessage(
                    journalId: journalId,
                    message: text,
                  );
                  if (response != null && response.success == true) {
                    _respondController.clear();
                    setState(() {
                      if (response.data?.messages != null &&
                          response.data!.messages!.isNotEmpty) {
                        _messages.addAll(response.data!.messages!);
                      } else {
                        if (response.data?.userMessage != null) {
                          _messages.add(response.data!.userMessage!);
                        }
                        if (response.data?.aiMessage != null) {
                          _messages.add(response.data!.aiMessage!);
                        }
                      }
                    });
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_scrollController.hasClients) {
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOut,
                        );
                      }
                    });
                  }
                },
              ),
            ),
    );
  }

  void _shareInterpretation(BuildContext context) {
    final title = _dreamData?.title ?? 'The Endless Ocean';
    final dateAndMoods = _dreamData != null
        ? '${_dreamData!.formattedDate ?? ''}${_dreamData!.moodDisplay != null ? ' • ${_dreamData!.moodDisplay}' : ''}'
        : 'Oct 25 • Anxiety, Overwhelm';
    final summary = _dreamData?.summary ?? '';
    final meaning = _dreamData?.meaning ?? '';

    final buffer = StringBuffer();
    buffer.writeln('✨ Dream Interpretation: $title ✨');
    buffer.writeln('📅 $dateAndMoods');
    buffer.writeln();
    buffer.writeln('📝 Summary:');
    buffer.writeln(summary);
    buffer.writeln();
    buffer.writeln('💡 Meaning:');
    buffer.writeln(meaning);

    final List<String> emotionStrings = [];
    if (_dreamData?.emotionalLandscape != null &&
        _dreamData!.emotionalLandscape!.isNotEmpty) {
      for (var emotion in _dreamData!.emotionalLandscape!) {
        final name = emotion.name ?? '';
        final percent = emotion.percentage ?? 0;
        if (name.isNotEmpty) {
          emotionStrings.add('• $name: $percent%');
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

    final List<String> careStrings = [];
    if (_dreamData?.careReflection != null &&
        _dreamData!.careReflection!.isNotEmpty) {
      for (var reflection in _dreamData!.careReflection!) {
        final t = reflection.title ?? '';
        final st = reflection.shortTitle ?? '';
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

    final tags = _dreamData?.symbolTags ?? [];
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
    final sharePositionOrigin = box != null
        ? (box.localToGlobal(Offset.zero) & box.size)
        : null;

    SharePlus.instance.share(
      ShareParams(
        text: buffer.toString(),
        subject: 'Dream Interpretation: $title',
        sharePositionOrigin: sharePositionOrigin,
      ),
    );
  }
}
