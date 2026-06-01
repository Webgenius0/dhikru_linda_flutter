import 'dart:io';
import 'package:dhikru_linda_flutter/features/auth/login/presentation/login_screen.dart';
import 'package:dhikru_linda_flutter/features/auth/register/presentation/register_screen.dart';
import 'package:dhikru_linda_flutter/features/auth/register/presentation/register_verify_screen.dart';
import 'package:dhikru_linda_flutter/features/auth/forget_password/presentation/forget_password_screen.dart';
import 'package:dhikru_linda_flutter/features/auth/forget_password/presentation/forget_password_verify_otp_screen.dart';
import 'package:dhikru_linda_flutter/features/auth/set_new_password/presentation/set_new_password.dart';
import 'package:dhikru_linda_flutter/navigation_menu.dart';
import 'package:flutter/cupertino.dart';

final class Routes {
  static final Routes _routes = Routes._internal();
  Routes._internal();
  static Routes get instance => _routes;
  // --------------- Auth Routes Start---------------
  static const String logInScreen = '/logInScreen';
  // --------------- Auth Routes End---------------

  static const String onboardingScreenOne = '/onboardingScreenOne';
  static const String onboardingScreenTwo = '/onboardingScreenTwo';
  static const String onboardingScreenThree = '/onboardingScreenThree';
  static const String chooseRoleScreen = '/chooseRoleScreen';
  static const String registerScreen = '/registerScreen';
  static const String registerVerifyScreen = '/registerVerifyScreen';
  static const String chooseRoleDemo = '/chooseRoleDemo';
  static const String orgAchievementsScreen = '/orgAchievementsScreen';
  static const String orgNotificationSettingScreen =
      '/orgNotificationSettingScreen';
  static const String editProfileScreen = '/editProfileScreen';
  static const String orgChangePasswordScren = '/orgChangePasswordScren';
  static const String forgetPasswordScreen = '/forgetPasswordScreen';
  static const String forgetPasswordVerifyOtpScreen = '/forgetPasswordVerifyOtpScreen';
  static const String setNewPassword = '/setNewPassword';
  static const String orgEmailSendScreen = '/orgEmailSendScreen';
  static const String orgPayoutScreen = '/orgPayoutScreen';
  static const String organiserProfileScreen = '/organiserProfileScreen';
  static const String allRecentEventsScreen = '/allRecentEventsScreen';
  static const String detailsAndPublishScreen = '/detailsAndPublishScreen';
  static const String createEventScreen = '/createEventScreen';
  static const String organizerCreateDetailsScreen =
      '/organizerCreateDetailsScreen';
  static const String clubAllMemberScreen = '/clubAllMemberScreen';
  static const String joinPendingRequestScreen = '/joinPendingRequestScreen';
  static const String createClubBasicInfoScreen = '/createClubBasicInfoScreen';
  static const String productDetailsScreen = '/productDetailsScreen';
  static const String cartScreen = '/cartScreen';
  static const String favoritesListScreen = '/favoritesListScreen';
  static const String userNavigationMenu = '/userNavigationMenu';
  static const String notificationOrganizerScreen =
      '/notificationOrganizerScreen';
}

final class RouteGenerator {
  static final RouteGenerator _routeGenerator = RouteGenerator._internal();
  RouteGenerator._internal();
  static RouteGenerator get instance => _routeGenerator;

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // ----------- Onboarding Routes -----------
      // case Routes.onboardingScreenOne:
      //   return Platform.isAndroid
      //       ? _FadedTransitionRoute(
      //           widget: OnboardingScreen(),
      //           settings: settings,
      //         )
      //       : CupertinoPageRoute(builder: (context) => OnboardingScreen());

      // ----------- Onboarding Routes -----------
      // case Routes.onboardingScreenTwo:
      //   return Platform.isAndroid
      //       ? _FadedTransitionRoute(
      //           widget: OnboardingScreenTwo(),
      //           settings: settings,
      //         )
      //       : CupertinoPageRoute(builder: (context) => OnboardingScreenTwo());

      // case Routes.onboardingScreenThree:
      //   return Platform.isAndroid
      //       ? _FadedTransitionRoute(
      //           widget: OnboardingScreenThree(),
      //           settings: settings,
      //         )
      //       : CupertinoPageRoute(builder: (context) => OnboardingScreenThree());

      // case Routes.orgAchievementsScreen:
      //   return Platform.isAndroid
      //       ? _FadedTransitionRoute(
      //           widget: OrgAchievementsScreen(),
      //           settings: settings,
      //         )
      //       : CupertinoPageRoute(builder: (context) => OrgAchievementsScreen());

      // ----------- Auth Routes start-----------
      case Routes.logInScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(widget: LoginScreen(), settings: settings)
            : CupertinoPageRoute(builder: (context) => LoginScreen());

      case Routes.userNavigationMenu:
        return Platform.isAndroid
            ? _FadedTransitionRoute(widget: const NavigationMenu(), settings: settings)
            : CupertinoPageRoute(builder: (context) => const NavigationMenu());

      // case Routes.chooseRoleScreen:
      //   return Platform.isAndroid
      //       ? _FadedTransitionRoute(
      //           widget: ChooseRoleScreen(),
      //           settings: settings,
      //         )
      //       : CupertinoPageRoute(builder: (context) => ChooseRoleScreen());

      case Routes.registerScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const RegisterScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(builder: (context) => const RegisterScreen());

      case Routes.registerVerifyScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const RegisterVerifyScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => const RegisterVerifyScreen(),
              );

      case Routes.forgetPasswordScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const ForgetPasswordScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => const ForgetPasswordScreen(),
              );

      case Routes.forgetPasswordVerifyOtpScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const ForgetPasswordVerifyOtpScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => const ForgetPasswordVerifyOtpScreen(),
              );

      case Routes.setNewPassword:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const SetNewPassword(),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => const SetNewPassword(),
              );

      // ----------- Auth Routes end-----------

      // case Routes.orgNotificationSettingScreen:
      //   return Platform.isAndroid
      //       ? _FadedTransitionRoute(
      //           widget: OrgNotificationSettingScreen(),
      //           settings: settings,
      //         )
      //       : CupertinoPageRoute(
      //           builder: (context) => OrgNotificationSettingScreen(),
      //         );
      // case Routes.editProfileScreen:
      //   return Platform.isAndroid
      //       ? _FadedTransitionRoute(
      //           widget: EditProfileScreen(),
      //           settings: settings,
      //         )
      //       : CupertinoPageRoute(builder: (context) => EditProfileScreen());

      // case Routes.orgChangePasswordScren:
      //   return Platform.isAndroid
      //       ? _FadedTransitionRoute(
      //           widget: OrgChangePasswordScren(),
      //           settings: settings,
      //         )
      //       : CupertinoPageRoute(
      //           builder: (context) => OrgChangePasswordScren(),
      //         );

      default:
        return null;
    }
  }
}

class _FadedTransitionRoute extends PageRouteBuilder {
  final Widget widget;
  @override
  final RouteSettings settings;

  _FadedTransitionRoute({required this.widget, required this.settings})
    : super(
        settings: settings,
        reverseTransitionDuration: const Duration(milliseconds: 1),
        pageBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return widget;
            },
        transitionDuration: const Duration(milliseconds: 1),
        transitionsBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              return FadeTransition(
                opacity: CurvedAnimation(parent: animation, curve: Curves.ease),
                child: child,
              );
            },
      );
}

class ScreenTitle extends StatelessWidget {
  final Widget widget;

  const ScreenTitle({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: .5, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.bounceIn,
      builder: (context, value, child) {
        return Opacity(opacity: value, child: child);
      },
      child: widget,
    );
  }
}
