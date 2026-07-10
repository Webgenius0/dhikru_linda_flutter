import 'package:dhikru_linda_flutter/networks/api_acess.dart';
import 'package:dhikru_linda_flutter/features/profile/model/privacy_policy_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  // ── Colors ──
  static const _bg = Color(0xFF0B0F14);
  static const _cardBg = Color(0xFF111720);
  static const _mutedText = Color(0xFF8993A4);
  static const _borderColor = Color(0xFF252F3D);

  @override
  void initState() {
    super.initState();
    // Fetch privacy policy content on load
    privacyPolicyRxObj.getPrivacyPolicy();
  }

  // ── Basic HTML to Widget parser helper ──
  List<Widget> _parseHtmlToWidgets(String htmlContent) {
    // Replace breaks/paragraphs with newlines to segment block elements
    final lines = htmlContent
        .replaceAll('<p>', '\n')
        .replaceAll('</p>', '\n')
        .replaceAll('<br>', '\n')
        .replaceAll('<br/>', '\n')
        .replaceAll('<br />', '\n')
        .replaceAll('<h1>', '\n[H1]')
        .replaceAll('</h1>', '\n')
        .replaceAll('<h2>', '\n[H2]')
        .replaceAll('</h2>', '\n')
        .replaceAll('<h3>', '\n[H3]')
        .replaceAll('</h3>', '\n')
        .replaceAll('<h4>', '\n[H4]')
        .replaceAll('</h4>', '\n')
        .split('\n');

    final List<Widget> widgets = [];
    for (var line in lines) {
      var isHeading = false;
      var currentLine = line;

      // Extract our custom header tokens
      if (currentLine.startsWith('[H1]') ||
          currentLine.startsWith('[H2]') ||
          currentLine.startsWith('[H3]') ||
          currentLine.startsWith('[H4]')) {
        isHeading = true;
        currentLine = currentLine.substring(4);
      }

      // Strip other HTML tags
      final cleanLine = currentLine.replaceAll(RegExp(r'<[^>]*>'), '').trim();
      if (cleanLine.isEmpty) continue;

      widgets.add(
        Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Text(
            cleanLine,
            style: GoogleFonts.inter(
              color: isHeading ? Colors.white : _mutedText,
              fontSize: isHeading ? 18.sp : 14.sp,
              fontWeight: isHeading ? FontWeight.w700 : FontWeight.w400,
              height: 1.5,
            ),
          ),
        ),
      );
    }
    return widgets;
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

            // ── Content body ──
            Expanded(
              child: StreamBuilder<PrivacyPolicyModel>(
                stream: privacyPolicyRxObj.getPrivacyPolicyData,
                builder: (context, snapshot) {
                  // Loading state
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 24.h,
                      ),
                      child: _buildShimmerLoader(),
                    );
                  }

                  // Error check
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Failed to load Privacy Policy. Please try again.',
                        style: GoogleFonts.inter(
                          color: Colors.redAccent,
                          fontSize: 14.sp,
                        ),
                      ),
                    );
                  }

                  final pageData = snapshot.data?.data;
                  final content = pageData?.content;

                  // Empty content check
                  if (pageData == null ||
                      content == null ||
                      content.trim().isEmpty) {
                    return Center(
                      child: Text(
                        'No content available.',
                        style: GoogleFonts.inter(
                          color: _mutedText,
                          fontSize: 14.sp,
                        ),
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 24.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _parseHtmlToWidgets(content),
                    ),
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
              width: 40.w,
              height: 40.w,
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
          StreamBuilder<PrivacyPolicyModel>(
            stream: privacyPolicyRxObj.getPrivacyPolicyData,
            builder: (context, snapshot) {
              final title = snapshot.data?.data?.title ?? 'Privacy Policy';
              return Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────
  //  Shimmer Skeleton Loader
  // ────────────────────────────────────────────────
  Widget _buildShimmerLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.05),
      highlightColor: Colors.white.withOpacity(0.1),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(8, (index) {
            final isTitle = index == 0 || index == 4;
            return Container(
              margin: EdgeInsets.only(bottom: 16.h),
              width: isTitle ? 180.w : double.infinity,
              height: isTitle ? 20.h : 14.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            );
          }),
        ),
      ),
    );
  }
}
