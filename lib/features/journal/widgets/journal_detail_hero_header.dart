import 'package:flutter/material.dart';

const Color _white = Colors.white;
const Color _subtleText = Color(0xFF8888AA);

class JournalDetailHeroHeader extends StatelessWidget {
  final String title;
  final String subtitleText;

  const JournalDetailHeroHeader({
    super.key,
    required this.title,
    required this.subtitleText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Glimmering custom icon with glow shadow
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF9E85F5), Color(0xFF634DF2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7B6EF6).withOpacity(0.35),
                blurRadius: 18,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Dream title
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: _white,
            fontSize: 26,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        // Date + tags
        Text(
          subtitleText,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: _subtleText,
            fontSize: 13,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }
}
