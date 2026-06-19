import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'features/home/presentation/home_screen.dart';
import 'features/journal/presentation/journal_screen.dart';
import 'features/insights/presentation/insights_screen.dart';
import 'features/profile/presentation/profile_screen.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _currentIndex = 0;

  static const Color activeColor = Color(0xFF9D87F5);
  static const Color inactiveColor = Color(0xFF9DB2CE);

  List<Widget> get _pages => [
    HomeScreen(onGoProfile: _goProfile, onGoJournal: _goJournal),
    JournalScreen(onGoHome: _goHome),
    InsightsScreen(onGoHome: _goHome),
    ProfileScreen(onGoHome: _goHome),
  ];

  void _goHome() {
    setState(() => _currentIndex = 0);
  }

  void _goJournal() {
    setState(() => _currentIndex = 1);
  }

  void _goProfile() {
    setState(() => _currentIndex = 3);
  }

  Future<bool> _onWillPop() async {
    final result = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text("Exit App"),
          content: const Text("Are you sure you want to leave the app?"),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Cancel"),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Exit"),
            ),
          ],
        );
      },
    );

    if (result == true) {
      SystemNavigator.pop(); // close app
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        await _onWillPop();
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: SafeArea(
          top: false,
          child: Scaffold(
            body: _pages[_currentIndex],

          bottomNavigationBar: CurvedNavigationBar(
            index: _currentIndex,
            height: 65,
            backgroundColor: Color(0xFF0A0B1A),

            color: const Color(0xFF191A28),

            buttonBackgroundColor: const Color(0xFF39345A),
            animationDuration: const Duration(milliseconds: 300),

            items: [
              _buildNavItem("Home", "assets/icons/home.png", 0),
              _buildNavItem("Journal", "assets/icons/Icon.png", 1),
              _buildNavItem("Insights", "assets/icons/Button.png", 2),
              _buildNavItem("Profile", "assets/icons/user.png", 3),
            ],

            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      ),
    ),
  );
  }

  CurvedNavigationBarItem _buildNavItem(
    String label,
    String iconPath,
    int index,
  ) {
    final bool isSelected = _currentIndex == index;

    return CurvedNavigationBarItem(
      child: Image.asset(
        iconPath,
        height: 24.h,
        color: isSelected ? activeColor : inactiveColor,
      ),
      label: label,
      labelStyle: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: isSelected ? activeColor : inactiveColor,
      ),
    );
  }
}
