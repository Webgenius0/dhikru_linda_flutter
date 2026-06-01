import 'package:dhikru_linda_flutter/assets_helper/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class TextFontStyle {
  TextFontStyle._();

  /*custom font use anywhere*/

  static final textStyle32RighteousW400 = GoogleFonts.righteous(
    color: Colors.black,
    fontSize: 32.sp,
    fontWeight: FontWeight.w400,
  );

  static final textStyle24RobotoW600 = GoogleFonts.roboto(
    color: Colors.black,
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    height: 1.5.h,
    letterSpacing: 0,
  );

  static final textStyle12UrbanistW600 = GoogleFonts.urbanist(
    color: Colors.black,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    height: 1.5.h,
    letterSpacing: 0,
  );

  static final textStyle13PoppinsW500 = GoogleFonts.poppins(
    color: Colors.black,
    fontSize: 13.sp,
    fontWeight: FontWeight.w500,
    height: 1.6.h,
    letterSpacing: 0,
  );

  static final textStyle14InterW400 = GoogleFonts.inter(
    color: AppColor.c282828,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    height: 1.5.h,
    letterSpacing: 0,
  );

  static final textStyle14InterW500 = GoogleFonts.inter(
    color: AppColor.cFFFFFF,
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    height: 1.5.h,
    letterSpacing: 0,
  );
  static final textStyle16InterW600 = GoogleFonts.inter(
    color: Colors.white,
    fontSize: 16.sp, 
    fontWeight: FontWeight.w600,
  );

  // static var textStyle32RighteousW400 = TextStyle(
  //     fontFamily: 'Righteous',
  //     fontFamilyFallback: const [
  //       'Righteous',
  //     ],
  //     color: AppColor.c000000,
  //     fontSize: 32.sp,
  //     height: 1.4,
  //     letterSpacing: 0,
  //     fontWeight: FontWeight.bold);

  // static var textStyle12PoppinsW300 = TextStyle(
  //     fontFamily: 'Poppins',
  //     fontFamilyFallback: const [
  //       'Open Sans',
  //       'Poppins',
  //       'Noto Sans',
  //     ],
  //     color: AppColor.cFFFFFF,
  //     fontSize: 12.sp,
  //     height: 1.50,
  //     fontWeight: FontWeight.w300);
}
