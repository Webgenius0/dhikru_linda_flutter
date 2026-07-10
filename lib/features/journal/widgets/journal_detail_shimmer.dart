import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class JournalDetailShimmer extends StatelessWidget {
  const JournalDetailShimmer({super.key});

  Widget _box({double? width, double? height, double? radius, bool circle = false}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circle ? null : BorderRadius.circular(radius ?? 4.r),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.04),
      highlightColor: Colors.white.withOpacity(0.08),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _box(width: 34, height: 34, circle: true),
                    const SizedBox(width: 14),
                    _box(width: 130.w, height: 18.h),
                  ],
                ),
                _box(width: 34, height: 34, circle: true),
              ],
            ),
            const SizedBox(height: 28),
            Center(
              child: Column(
                children: [
                  _box(width: 72, height: 72, circle: true),
                  const SizedBox(height: 20),
                  _box(width: 200.w, height: 22.h),
                  const SizedBox(height: 8),
                  _box(width: 140.w, height: 14.h),
                ],
              ),
            ),
            const SizedBox(height: 28),
            _box(width: double.infinity, height: 120.h, radius: 16.r),
            const SizedBox(height: 14),
            _box(width: double.infinity, height: 100.h, radius: 16.r),
            const SizedBox(height: 28),
            _box(width: 100.w, height: 12.h, radius: 3.r),
            const SizedBox(height: 12),
            _box(width: double.infinity, height: 80.h, radius: 14.r),
            const SizedBox(height: 28),
            _box(width: 130.w, height: 12.h, radius: 3.r),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.6,
              children: List.generate(4, (_) => _box(radius: 12.r)),
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }
}
