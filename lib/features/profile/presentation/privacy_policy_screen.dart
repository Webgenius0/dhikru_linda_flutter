import 'package:dhikru_linda_flutter/features/profile/model/privacy_policy_model.dart';
import 'package:dhikru_linda_flutter/helpers/html_markdown_converter.dart';
import 'package:dhikru_linda_flutter/helpers/url_lunch.dart';
import 'package:dhikru_linda_flutter/networks/api_acess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
  static const _accentColor = Color(0xFF8B7AE8);

  @override
  void initState() {
    super.initState();
    // Fetch privacy policy content on load
    privacyPolicyRxObj.getPrivacyPolicy();
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
                initialData: privacyPolicyRxObj.dataFetcher.valueOrNull,
                stream: privacyPolicyRxObj.getPrivacyPolicyData,
                builder: (context, snapshot) {
                  // Loading state when no existing data is cached
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      !snapshot.hasData) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 24.h,
                      ),
                      child: _buildShimmerLoader(),
                    );
                  }

                  // Error check
                  if (snapshot.hasError &&
                      (!snapshot.hasData ||
                          snapshot.data?.data?.content == null)) {
                    return _buildErrorState();
                  }

                  final pageData = snapshot.data?.data;
                  final content = pageData?.content;

                  // Empty content check
                  if (pageData == null ||
                      content == null ||
                      content.trim().isEmpty) {
                    return _buildEmptyState();
                  }

                  final markdownData = htmlToMarkdown(content);

                  return RefreshIndicator(
                    color: _accentColor,
                    backgroundColor: _cardBg,
                    onRefresh: () async {
                      await privacyPolicyRxObj.getPrivacyPolicy();
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 20.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (pageData.updatedAt != null) ...[
                            Text(
                              'Last updated: ${DateFormat('MMMM dd, yyyy').format(pageData.updatedAt!)}',
                              style: GoogleFonts.inter(
                                color: _mutedText.withValues(alpha: 0.8),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 16.h),
                          ],
                          MarkdownBody(
                            data: markdownData,
                            selectable: true,
                            onTapLink: (text, href, title) {
                              if (href != null && href.isNotEmpty) {
                                urlLunch(href);
                              }
                            },
                            styleSheet: _buildMarkdownStyleSheet(),
                          ),
                          SizedBox(height: 32.h),
                        ],
                      ),
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
          Expanded(
            child: StreamBuilder<PrivacyPolicyModel>(
              initialData: privacyPolicyRxObj.dataFetcher.valueOrNull,
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
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────
  //  Error State
  // ────────────────────────────────────────────────
  Widget _buildErrorState() {
    return RefreshIndicator(
      color: _accentColor,
      backgroundColor: _cardBg,
      onRefresh: () async {
        await privacyPolicyRxObj.getPrivacyPolicy();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 80.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.redAccent.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.cloud_off_rounded,
                  color: Colors.redAccent,
                  size: 28,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Unable to Load Privacy Policy',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'We could not retrieve the privacy policy from the server. Please check your internet connection and try again.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: _mutedText,
                  fontSize: 13.5.sp,
                  height: 1.45,
                ),
              ),
              SizedBox(height: 20.h),
              ElevatedButton.icon(
                onPressed: () => privacyPolicyRxObj.getPrivacyPolicy(),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accentColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 11.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────
  //  Empty State
  // ────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return RefreshIndicator(
      color: _accentColor,
      backgroundColor: _cardBg,
      onRefresh: () async {
        await privacyPolicyRxObj.getPrivacyPolicy();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 80.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _borderColor,
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.article_outlined,
                  color: _mutedText,
                  size: 28,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'No Policy Content Available',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'The privacy policy is currently unavailable. Please check back later.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: _mutedText,
                  fontSize: 13.5.sp,
                  height: 1.45,
                ),
              ),
              SizedBox(height: 20.h),
              ElevatedButton.icon(
                onPressed: () => privacyPolicyRxObj.getPrivacyPolicy(),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Refresh'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _cardBg,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  side: const BorderSide(color: _borderColor, width: 1),
                  padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 11.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────
  //  Markdown Style Sheet
  // ────────────────────────────────────────────────
  MarkdownStyleSheet _buildMarkdownStyleSheet() {
    return MarkdownStyleSheet(
      p: GoogleFonts.inter(
        color: _mutedText,
        fontSize: 14.sp,
        height: 1.6,
      ),
      h1: GoogleFonts.inter(
        color: Colors.white,
        fontSize: 22.sp,
        fontWeight: FontWeight.w700,
        height: 1.4,
      ),
      h2: GoogleFonts.inter(
        color: Colors.white,
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        height: 1.4,
      ),
      h3: GoogleFonts.inter(
        color: Colors.white,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      h4: GoogleFonts.inter(
        color: Colors.white,
        fontSize: 15.sp,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      strong: GoogleFonts.inter(
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
      em: GoogleFonts.inter(
        fontStyle: FontStyle.italic,
        color: _mutedText,
      ),
      a: GoogleFonts.inter(
        color: _accentColor,
        fontWeight: FontWeight.w600,
        decoration: TextDecoration.underline,
        decorationColor: _accentColor,
      ),
      listBullet: GoogleFonts.inter(
        color: _accentColor,
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
      ),
      listBulletPadding: EdgeInsets.only(right: 8.w),
      blockSpacing: 14.h,
      blockquote: GoogleFonts.inter(
        color: Colors.white.withValues(alpha: 0.8),
        fontStyle: FontStyle.italic,
      ),
      blockquoteDecoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(8.r),
        border: const Border(
          left: BorderSide(color: _accentColor, width: 3),
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────
  //  Shimmer Skeleton Loader
  // ────────────────────────────────────────────────
  Widget _buildShimmerLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.white.withValues(alpha: 0.05),
      highlightColor: Colors.white.withValues(alpha: 0.1),
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
