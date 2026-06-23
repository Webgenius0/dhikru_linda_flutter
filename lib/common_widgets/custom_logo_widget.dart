import 'package:dhikru_linda_flutter/assets_helper/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomLogoWidget extends StatelessWidget {
  final double? height;
  final double? width;

  const CustomLogoWidget({Key? key, this.height, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: Image.asset(
        AppImages.logo,
        height: height ?? 80.h,
        width: width ?? 80.h,
        fit: BoxFit.cover,
      ),
    );
  }
}
