import 'package:dhikru_linda_flutter/assets_helper/app_icons.dart';
import 'package:dhikru_linda_flutter/features/home/presentation/home_screen.dart';
import 'package:dhikru_linda_flutter/features/journal/journal_screen.dart';
import 'package:dhikru_linda_flutter/features/profile/presentation/profile_screen.dart';
import 'package:dhikru_linda_flutter/features/insights/presentation/insights_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _selectedIndex = 0;

  void _goHome() {
    setState(() => _selectedIndex = 0);
  }

  List<Widget> get _screens => [
        const HomeScreen(),
        const JournalScreen(),
        InsightsScreen(onGoHome: _goHome),
        ProfileScreen(onGoHome: _goHome),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _screens[_selectedIndex],

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0D1216), // Dark background color from design
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomAppBar(
          padding: EdgeInsets.zero,
          color: Colors.transparent,
          elevation: 0,
          child: SizedBox(
            height: 70.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  icon: AppIcons.home,
                  activeIcon: AppIcons.home_selected,
                  label: 'Home'.tr,
                ),
                _buildNavItem(
                  index: 1,
                  icon: AppIcons.route,
                  activeIcon: AppIcons.route_selected,
                  label: 'Journal'.tr,
                ),

                _buildNavItem(
                  index: 2,
                  icon: AppIcons.social,
                  activeIcon: AppIcons.social_selected,
                  label: 'Insights'.tr,
                ),
                _buildNavItem(
                  index: 3,
                  icon: AppIcons.shop,
                  activeIcon: AppIcons.shop_selected,
                  label: 'Profile'.tr,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String icon,
    required String activeIcon,
    required String label,
  }) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              isSelected ? activeIcon : icon,
              color: isSelected
                  ? const Color(0xFF266FEF)
                  : const Color(0xFF8993A4),
              height: 24.h,
              width: 24.w,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.image_not_supported,
                  color: isSelected
                      ? const Color(0xFF266FEF)
                      : const Color(0xFF8993A4),
                  size: 24.sp,
                );
              },
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF266FEF)
                    : const Color(0xFF8993A4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
