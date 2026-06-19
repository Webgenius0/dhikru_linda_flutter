import 'package:dhikru_linda_flutter/networks/api_acess.dart';
import 'package:dhikru_linda_flutter/features/profile/model/help_and_support_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class HelpAndSupportScreen extends StatefulWidget {
  const HelpAndSupportScreen({super.key});

  @override
  State<HelpAndSupportScreen> createState() => _HelpAndSupportScreenState();
}

class _HelpAndSupportScreenState extends State<HelpAndSupportScreen> {
  // ── Colors ──
  static const _bg = Color(0xFF0B0F14);
  static const _cardBg = Color(0xFF111720);
  static const _mutedText = Color(0xFF8993A4);
  static const _borderColor = Color(0xFF252F3D);

  @override
  void initState() {
    super.initState();
    // Fetch FAQs on screen load
    helpAndSupportRxObj.getHelpAndSupport();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── App Bar ──
            _buildAppBar(),

            // ── Body faq list ──
            Expanded(
              child: StreamBuilder<HelpAndSupportModel>(
                stream: helpAndSupportRxObj.getHelpAndSupportData,
                builder: (context, snapshot) {
                  // Loading indicator
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                      child: _buildShimmerLoader(),
                    );
                  }

                  // Error check
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Failed to load FAQs. Please try again.',
                        style: GoogleFonts.inter(color: Colors.redAccent, fontSize: 14.sp),
                      ),
                    );
                  }

                  final dataList = snapshot.data?.data;

                  // Empty list check
                  if (dataList == null || dataList.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: _buildEmptyState(),
                    );
                  }

                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      final faq = dataList[index];
                      return FAQItemWidget(
                        question: faq.question ?? '',
                        answer: faq.answer ?? '',
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────
  //  App Bar
  // ────────────────────────────────────────────────
  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () {
              if (Navigator.canPop(context)) Navigator.pop(context);
            },
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
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Text(
            'Help & Support',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────
  //  Shimmer Skeleton Loader
  // ────────────────────────────────────────────────
  Widget _buildShimmerLoader() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: _borderColor, width: 1),
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.white.withOpacity(0.05),
            highlightColor: Colors.white.withOpacity(0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 220.w,
                      height: 16.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ────────────────────────────────────────────────
  //  Empty State
  // ────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 80.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0xFF7C5CF6).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.help_outline_rounded,
              color: const Color(0xFF9D7FF7),
              size: 48.sp,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'No FAQs Available',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'We couldn\'t find any help articles at the moment.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: _mutedText,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Dynamic Expandable Accordion Item
// ─────────────────────────────────────────────────────────────────────────────
class FAQItemWidget extends StatefulWidget {
  final String question;
  final String answer;

  const FAQItemWidget({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  State<FAQItemWidget> createState() => _FAQItemWidgetState();
}

class _FAQItemWidgetState extends State<FAQItemWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xFF111720),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: _isExpanded ? const Color(0xFF7C5CF6) : const Color(0xFF252F3D),
            width: 1,
          ),
          boxShadow: _isExpanded
              ? [
                  BoxShadow(
                    color: const Color(0xFF7C5CF6).withOpacity(0.08),
                    blurRadius: 10,
                    spreadRadius: 1,
                  )
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.question,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: _isExpanded ? const Color(0xFF9D7FF7) : const Color(0xFF8993A4),
                    size: 22.sp,
                  ),
                ),
              ],
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(color: Color(0xFF1E2730), height: 1),
                    SizedBox(height: 12.h),
                    Text(
                      widget.answer,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF8993A4),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
            ),
          ],
        ),
      ),
    );
  }
}