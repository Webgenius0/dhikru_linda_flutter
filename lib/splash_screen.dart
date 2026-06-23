import 'package:dhikru_linda_flutter/common_widgets/custom_logo_widget.dart';
import 'package:dhikru_linda_flutter/helpers/all_routes.dart';
import 'package:dhikru_linda_flutter/helpers/navigation_service.dart';
import 'package:dhikru_linda_flutter/helpers/helper_methods.dart';
import 'package:dhikru_linda_flutter/helpers/di.dart';
import 'package:dhikru_linda_flutter/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // --------------- Animation Controller ---------------
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // --------------- Fade Animation ---------------
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    // --------------- Scale Animation ---------------
    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // --------------- Start Animation ---------------
    _animationController.forward();

    // --------------- Initialize & Navigate ---------------
    setInitValue().then((_) {
      if (mounted) {
        bool isLoggedIn = appData.read(kKeyIsLoggedIn) ?? false;
        if (isLoggedIn) {
          NavigationService.navigateToReplacement(Routes.userNavigationMenu);
        } else {
          NavigationService.navigateToReplacement(Routes.logInScreen);
        }
      }
    });
  }

  @override
  void dispose() {
    // --------------- Dispose Controller ---------------
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF0D0B1F),

        // --------------- Splash Body ---------------
        body: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,

              // --------------- Logo Row ---------------
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomLogoWidget(
                    width: 46.w,
                    height: 46.w,
                  ),

                  SizedBox(width: 14.w),

                  // --------------- App Name ---------------
                  Text(
                    'Dream Trace',
                    style: GoogleFonts.cormorantGaramond(
                      color: Colors.white,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


