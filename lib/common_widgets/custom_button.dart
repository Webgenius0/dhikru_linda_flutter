
import 'package:dhikru_linda_flutter/assets_helper/app_colors.dart';
import 'package:dhikru_linda_flutter/assets_helper/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final Color? texColor;

  final bool? isBorder;
  final bool? isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.onPressed,
    this.isBorder = false,
    this.isLoading = false,
    this.texColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        height: 55.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(
            width: 1,
            color: isBorder! ? AppColor.c1570EF : Colors.transparent,
          ),
        ),
        child: Center(
          child: isLoading!
              ? SizedBox(
                  child: CircularProgressIndicator(
                    color: texColor ?? AppColor.cFFFFFF,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  text,
                  style: TextFontStyle.textStyle13PoppinsW500.copyWith(
                    fontWeight: FontWeight.w600,
                    color: texColor ?? AppColor.cFFFFFF,
                    fontSize: 14.sp,
                  ),
                ),
        ),
      ),
    );
  }
}
