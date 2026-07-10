import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class InterpretationShimmer extends StatelessWidget {
  final Widget appBar;

  const InterpretationShimmer({super.key, required this.appBar});

  Widget _box({double? width, double? height, double? radius, bool circle = false}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circle ? null : BorderRadius.circular(radius ?? 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Center(child: appBar),
          const SizedBox(height: 28),

          // Shimmer Hero Header
          Center(
            child: Shimmer.fromColors(
              baseColor: Colors.white.withOpacity(0.05),
              highlightColor: Colors.white.withOpacity(0.1),
              child: Column(
                children: [
                  _box(width: 60, height: 60, circle: true),
                  const SizedBox(height: 16),
                  _box(width: 180, height: 24, radius: 6),
                  const SizedBox(height: 8),
                  _box(width: 120, height: 14, radius: 4),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),

          // Shimmer Summary Card
          _shimmerCard(height: 120),
          const SizedBox(height: 14),

          // Shimmer Meaning Card
          _shimmerCard(height: 100),
          const SizedBox(height: 28),

          // Shimmer Your Respond Section
          Shimmer.fromColors(
            baseColor: Colors.white.withOpacity(0.05),
            highlightColor: Colors.white.withOpacity(0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _box(width: 100, height: 12),
                const SizedBox(height: 12),
                _box(width: double.infinity, height: 80, radius: 14),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Shimmer Care Reflection Section
          Shimmer.fromColors(
            baseColor: Colors.white.withOpacity(0.05),
            highlightColor: Colors.white.withOpacity(0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _box(width: 120, height: 12),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 2.6,
                  children: List.generate(4, (index) {
                    return _box(radius: 12);
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _shimmerCard({required double height}) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.05),
      highlightColor: Colors.white.withOpacity(0.1),
      child: _box(width: double.infinity, height: height, radius: 16),
    );
  }
}
