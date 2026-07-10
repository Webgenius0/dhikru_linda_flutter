import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

const Color _cardBg = Color(0xFF131325);
const Color _borderColor = Color(0xFF252545);

class JournalShimmerDreamCard extends StatelessWidget {
  const JournalShimmerDreamCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.05),
      highlightColor: Colors.white.withOpacity(0.1),
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _borderColor, width: 1),
        ),
      ),
    );
  }
}
