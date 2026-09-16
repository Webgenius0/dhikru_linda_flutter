import 'package:flutter/material.dart';
import 'package:dhikru_linda_flutter/networks/api_acess.dart';

const Color _bgColor = Color(0xFF0D0D1A);
const Color _accentPurple = Color(0xFF7B6EF6);
const Color _white = Colors.white;

class InterpretationSaveButton extends StatelessWidget {
  final VoidCallback onSend;
  final VoidCallback? onExit;

  const InterpretationSaveButton({
    super.key,
    required this.onSend,
    this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: sendJournalMessageRxObj.isLoading,
      builder: (context, isSendLoading, child) {
        return ValueListenableBuilder<bool>(
          valueListenable: saveJournalResponseRxObj.isLoading,
          builder: (context, isExitLoading, child) {
            return SafeArea(
              top: false,
              bottom: true,
              child: Container(
                color: _bgColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                children: [
                  // Exit Button (Left)
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed:
                            (isExitLoading || isSendLoading)
                                ? null
                                : (onExit ?? () => Navigator.maybePop(context)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E1E38),
                          foregroundColor: _white,
                          elevation: 0,
                          side: const BorderSide(
                            color: Color(0xFF33335A),
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isExitLoading) ...[
                              const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                              const SizedBox(width: 8),
                            ] else ...[
                              const Icon(
                                Icons.close_rounded,
                                size: 18,
                                color: Color(0xFFAAAAAA),
                              ),
                              const SizedBox(width: 8),
                            ],
                            const Text(
                              'Exit',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Send Button (Right)
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed:
                            (isExitLoading || isSendLoading) ? null : onSend,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _accentPurple,
                          foregroundColor: _white,
                          disabledBackgroundColor: _accentPurple.withValues(
                            alpha: 0.6,
                          ),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isSendLoading) ...[
                              const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                              const SizedBox(width: 8),
                            ] else ...[
                              const Icon(
                                Icons.send_rounded,
                                size: 18,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                            ],
                            const Text(
                              'Send',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            );
          },
        );
      },
    );
  }
}
