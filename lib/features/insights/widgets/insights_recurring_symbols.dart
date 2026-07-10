import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:dhikru_linda_flutter/networks/api_acess.dart';
import 'package:dhikru_linda_flutter/features/insights/model/insight_data_model.dart';

const Color _white = Colors.white;
const Color _mutedText = Color(0xFF8993A4);
const Color _accentPurple = Color(0xFF7C5CF6);
const Color _accentPurpleLight = Color(0xFF9D7FF7);

class InsightsRecurringSymbols extends StatelessWidget {
  final List<RecurringSymbol>? symbols;
  final void Function(int? tagId)? onGoJournal;

  const InsightsRecurringSymbols({super.key, this.symbols, this.onGoJournal});

  @override
  Widget build(BuildContext context) {
    if (symbols == null || symbols!.isEmpty) {
      return Text(
        'No recurring symbols detected yet.',
        style: GoogleFonts.inter(
          color: _mutedText.withOpacity(0.6),
          fontSize: 13.sp,
          fontWeight: FontWeight.w400,
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: symbols!.map((sym) {
          final tagText = sym.display ?? '#${sym.name ?? ''}';
          return GestureDetector(
            onTap: () {
              final tagsModel = tagsRxObj.dataFetcher.valueOrNull;
              if (tagsModel != null && tagsModel.data != null) {
                final tagsList = tagsModel.data ?? [];
                for (final tag in tagsList) {
                  if (tag.name?.toLowerCase() == sym.name?.toLowerCase() ||
                      tag.name?.toLowerCase() == sym.display?.toLowerCase() ||
                      sym.display?.toLowerCase().contains(
                            tag.name?.toLowerCase() ?? '',
                          ) ==
                          true) {
                    onGoJournal?.call(tag.id);
                    return;
                  }
                }
              }
              onGoJournal?.call(null);
            },
            child: Container(
              margin: EdgeInsets.only(right: 10.w),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: _accentPurple.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: _accentPurple.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                tagText,
                style: GoogleFonts.inter(
                  color: _accentPurpleLight,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class InsightsShimmerRecurringSymbols extends StatelessWidget {
  const InsightsShimmerRecurringSymbols({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.05),
      highlightColor: Colors.white.withOpacity(0.1),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: Row(
          children: List.generate(3, (index) {
            return Container(
              margin: EdgeInsets.only(right: 10.w),
              width: (80 + (index * 15)).w,
              height: 32.h,
              decoration: BoxDecoration(
                color: _white,
                borderRadius: BorderRadius.circular(20.r),
              ),
            );
          }),
        ),
      ),
    );
  }
}
