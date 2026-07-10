import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

const Color _fieldBg = Color(0xFF141B24);
const Color _borderColor = Color(0xFF252F3D);
const Color _mutedText = Color(0xFF8993A4);

class EditProfileDropdown<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<T> items;
  final String Function(T) displayText;
  final ValueChanged<T?> onChanged;

  const EditProfileDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.displayText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: _mutedText,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          height: 54.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: _fieldBg,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: _borderColor, width: 1),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              dropdownColor: const Color(0xFF1A2233),
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: _mutedText,
                size: 22.sp,
              ),
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
              ),
              items: items
                  .map(
                    (item) => DropdownMenuItem<T>(
                      value: item,
                      child: Text(
                        displayText(item),
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
