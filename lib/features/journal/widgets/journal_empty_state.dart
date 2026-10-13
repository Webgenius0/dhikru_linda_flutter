import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JournalEmptyState extends StatelessWidget {
  final bool isSearch;
  final bool isFilter;
  final String? searchQuery;
  final VoidCallback? onClearSearch;
  final VoidCallback? onClearFilter;
  final VoidCallback? onRecordDream;
  final Future<void> Function()? onRefresh;

  const JournalEmptyState({
    super.key,
    this.isSearch = false,
    this.isFilter = false,
    this.searchQuery,
    this.onClearSearch,
    this.onClearFilter,
    this.onRecordDream,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    // Determine content based on state
    final IconData icon;
    final String title;
    final String message;
    final Widget actionButton;

    if (isSearch) {
      icon = Icons.search_off_rounded;
      title = 'No Matching Dreams';
      message = (searchQuery != null && searchQuery!.trim().isNotEmpty)
          ? 'We couldn\'t find any dream journal entries matching "$searchQuery". Try using different keywords.'
          : 'No dream journal entries matched your search query.';
      actionButton = OutlinedButton.icon(
        onPressed: onClearSearch,
        icon: const Icon(Icons.close_rounded, size: 18, color: Color(0xFF9D87F5)),
        label: const Text(
          'Clear Search',
          style: TextStyle(
            color: Color(0xFF9D87F5),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFF453D80), width: 1.2),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: const Color(0xFF7B6EF6).withValues(alpha: 0.08),
        ),
      );
    } else if (isFilter) {
      icon = Icons.label_off_rounded;
      title = 'No Dreams in this Category';
      message =
          'You don\'t have any dreams tagged with this filter yet. Choose another category or view all your dreams.';
      actionButton = OutlinedButton.icon(
        onPressed: onClearFilter,
        icon: const Icon(Icons.apps_rounded, size: 18, color: Color(0xFF9D87F5)),
        label: const Text(
          'View All Dreams',
          style: TextStyle(
            color: Color(0xFF9D87F5),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFF453D80), width: 1.2),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: const Color(0xFF7B6EF6).withValues(alpha: 0.08),
        ),
      );
    } else {
      icon = Icons.auto_awesome_rounded;
      title = 'Your Dream Journal is Empty';
      message =
          'Every dream is a hidden portal into your subconscious mind. Record your first dream tonight to unlock deep psychological insights, emotions, and symbol interpretation.';
      actionButton = ElevatedButton.icon(
        onPressed: onRecordDream,
        icon: const Icon(Icons.notes_rounded, size: 20, color: Colors.white),
        label: const Text(
          'Log & Interpret a Dream',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7B6EF6),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      );
    }

    final content = Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 30.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Glowing circular icon container
            Container(
              width: 86.w,
              height: 86.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [
                    Color(0xFF282552),
                    Color(0xFF131326),
                  ],
                ),
                border: Border.all(
                  color: const Color(0xFF7B6EF6).withValues(alpha: 0.35),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7B6EF6).withValues(alpha: 0.2),
                    blurRadius: 28,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 38.w,
                  color: const Color(0xFF9D87F5),
                ),
              ),
            ),
            SizedBox(height: 24.h),

            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 19.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
            SizedBox(height: 10.h),

            // Description message
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 290.w),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF8888AA),
                  fontSize: 13.5.sp,
                  height: 1.45,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 26.h),

            // Action CTA
            actionButton,
          ],
        ),
      ),
    );

    if (onRefresh != null) {
      return RefreshIndicator(
        onRefresh: onRefresh!,
        color: const Color(0xFF9D87F5),
        backgroundColor: const Color(0xFF161628),
        child: content,
      );
    }

    return content;
  }
}
