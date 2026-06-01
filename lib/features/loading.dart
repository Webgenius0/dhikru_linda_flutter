// ignore_for_file: strict_top_level_inference

import 'package:dhikru_linda_flutter/constants/app_constants.dart';
import 'package:dhikru_linda_flutter/features/auth/login/presentation/login_screen.dart';
import 'package:dhikru_linda_flutter/helpers/di.dart';
import 'package:dhikru_linda_flutter/helpers/helper_methods.dart';
import 'package:dhikru_linda_flutter/splash_screen.dart';
import 'package:dhikru_linda_flutter/navigation_menu.dart';
import 'package:flutter/material.dart';

final class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  bool _isLoading = true;

  @override
  void initState() {
    loadInitialData();
    super.initState();
  }

  loadInitialData() async {
    _isLoading = true;
    await setInitValue();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SplashScreen();
    } else {
      bool isLoggedIn = appData.read(kKeyIsLoggedIn) ?? false;
      if (isLoggedIn) {
        return const NavigationMenu();
      } else {
        return const LoginScreen();
      }
    }
  }
}
