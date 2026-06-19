// ignore_for_file: constant_identifier_names, unnecessary_string_interpolations

const String url = "https://stevenchris.thesyndicates.team/api";
const String imageUrl = "${url}";

final class NetworkConstants {
  NetworkConstants._();
  static const ACCEPT = "Accept";
  static const APP_KEY = "App-Key";
  static const ACCEPT_LANGUAGE = "Accept-Language";
  static const ACCEPT_LANGUAGE_VALUE = "pt";
  static const APP_KEY_VALUE = String.fromEnvironment("APP_KEY_VALUE");
  static const ACCEPT_TYPE = "application/json";
  static const AUTHORIZATION = "Authorization";
  static const CONTENT_TYPE = "content-Type";
}

final class Endpoints {
  Endpoints._();

  // -------------------Register start-------------------
  static String register() => "/user/register";
  // -------------------Register end-------------------

  // -------------------Register Verify otp start-------------------
   static String registerVerifyOtp() => "/user/verify-otp";
  // -------------------Register Verify otp end-------------------

  // -------------------Login start-------------------
  static String login() => "/user/login";
  // -------------------Login end-------------------

  // -------------------Logout start-------------------
  static String logout() => "/user/logout";
  // -------------------Logout end-------------------


  // -------------------Resend OTP start-------------------
   static String resendOtp() => "/user/resend-otp";
  // -------------------Resend OTP end-------------------

  // -------------------Forget Password start-----------------
  static String forgotPassword() => "/user/forget-password";
  // -------------------Forget Password end-------------------


  // -------------------Reset Password start-----------------
   static String resetPassword() => "/user/reset-password";
  // -------------------Reset Password end-------------------

  // -------------------Delete Account start-----------------
  static String deleteAccount() => "/user/account/delete";
  // -------------------Delete Account end-------------------

  // -------------------Get Profile start-------------------
  static String getProfile() => "/user/me";
  // -------------------Get Profile end-------------------

  // -------------------Update Profile start-----------------
  static String updateProfile() => "/profile/update";
  // -------------------Update Profile end-------------------

  // -------------------Change Password start----------------
  static String changePassword() => "/change-password";
  // -------------------Change Password end------------------

  // -------------------Help Support start-------------------
  static String helpSupport() => "/help-support";
  // -------------------Help Support end-------------------

  // -------------------Privacy Policy start-----------------
  static String privacyPolicy() => "/pages/privacy";
  // -------------------Privacy Policy end-------------------

  // -------------------Terms and Condition start-----------------
  static String termsAndCondition() => "/pages/terms";
  // -------------------Terms and Condition end-------------------

  // -------------------Home start-----------------
  static String homeData() => "/home";
  // -------------------Home end-------------------


}
