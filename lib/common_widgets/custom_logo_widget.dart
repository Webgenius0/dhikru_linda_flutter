import 'package:dhikru_linda_flutter/assets_helper/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomLogoWidget extends StatelessWidget {
  final double? height;
  final double? width;

  const CustomLogoWidget({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    final logoWidth = width ?? 80.h;
    final logoHeight = height ?? 80.h;
    return SizedBox(
      width: logoWidth,
      height: logoHeight,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Image.asset(
          AppImages.logo,
          width: logoWidth,
          height: logoHeight,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
