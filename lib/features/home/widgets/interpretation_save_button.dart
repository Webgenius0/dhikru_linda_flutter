import 'package:flutter/material.dart';
import 'package:dhikru_linda_flutter/networks/api_acess.dart';

const Color _bgColor = Color(0xFF0D0D1A);
const Color _accentPurple = Color(0xFF7B6EF6);
const Color _white = Colors.white;

class InterpretationSaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const InterpretationSaveButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: saveJournalResponseRxObj.isLoading,
      builder: (context, isLoading, child) {
        return Container(
          color: _bgColor,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentPurple,
                foregroundColor: _white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
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
                    const Icon(
                      Icons.bookmark_border_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                  ],
                  const Text(
                    'Save to Journal',
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
