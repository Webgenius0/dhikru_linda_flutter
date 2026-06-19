import 'package:dhikru_linda_flutter/features/auth/forgot_password/data/rx_forgot_password/rx.dart';
import 'package:dhikru_linda_flutter/features/auth/forgot_password/model/forgot_password_model.dart';
import 'package:dhikru_linda_flutter/features/auth/login/data/rx_login/rx.dart';
import 'package:dhikru_linda_flutter/features/auth/login/model/login_model.dart';
import 'package:dhikru_linda_flutter/features/auth/logout/rx.dart';
import 'package:dhikru_linda_flutter/features/auth/register/data/rx_register/rx.dart';
import 'package:dhikru_linda_flutter/features/auth/register/data/rx_register_verify_otp/rx.dart';
import 'package:dhikru_linda_flutter/features/auth/register/data/rx_resend_otp/rx.dart';
import 'package:dhikru_linda_flutter/features/auth/register/model/register_model.dart';
import 'package:dhikru_linda_flutter/features/auth/register/model/register_verify_otp_model.dart';
import 'package:dhikru_linda_flutter/features/auth/register/model/resend_otp_model.dart';
import 'package:dhikru_linda_flutter/features/auth/set_new_password/data/rx.dart';
import 'package:dhikru_linda_flutter/features/auth/set_new_password/model/set_new_password_model.dart';
import 'package:dhikru_linda_flutter/features/auth/account_delete/data/rx.dart';
import 'package:dhikru_linda_flutter/features/home/data/get_profile_info/rx.dart';
import 'package:dhikru_linda_flutter/features/home/model/get_profile_model.dart';
import 'package:dhikru_linda_flutter/features/profile/data/update_profile/rx.dart';
import 'package:dhikru_linda_flutter/features/home/model/update_profile_model.dart';
import 'package:dhikru_linda_flutter/features/profile/data/change_password/rx.dart';
import 'package:dhikru_linda_flutter/features/profile/model/change_password_model.dart';
import 'package:dhikru_linda_flutter/features/profile/data/help_and_support/rx.dart';
import 'package:dhikru_linda_flutter/features/profile/model/help_and_support_model.dart';
import 'package:dhikru_linda_flutter/features/profile/data/privacy_policy/rx.dart';
import 'package:dhikru_linda_flutter/features/profile/model/privacy_policy_model.dart';
import 'package:dhikru_linda_flutter/features/profile/data/terms_and_condition/rx.dart';
import 'package:dhikru_linda_flutter/features/profile/model/terms_and_condition_model.dart';
import 'package:dhikru_linda_flutter/features/home/data/get_home_data/rx.dart';
import 'package:dhikru_linda_flutter/features/home/model/home_data_model.dart';
import 'package:dhikru_linda_flutter/features/insights/data/rx_insights_data/rx.dart';
import 'package:dhikru_linda_flutter/features/insights/model/insight_data_model.dart';
import 'package:dhikru_linda_flutter/features/journal/data/get_tags/rx.dart';
import 'package:dhikru_linda_flutter/features/journal/model/tags_model.dart';
import 'package:dhikru_linda_flutter/features/journal/data/get_all_journal/rx.dart';
import 'package:dhikru_linda_flutter/features/journal/model/get_all_journal_model.dart';
import 'package:rxdart/rxdart.dart';

// ------------- Register Api Access -----------------//
RegisterRx registerRxObj = RegisterRx(
  empty: RegisterModel(),
  dataFetcher: BehaviorSubject<RegisterModel>(),
);

// ------------- Register Verify Otp Api Access -----------------//
RegisterVerifyOtpRx registerVerifyOtpRxObj = RegisterVerifyOtpRx(
  empty: RegisterVerifyOtpModel(),
  dataFetcher: BehaviorSubject<RegisterVerifyOtpModel>(),
);

// ------------- Login Api Access -----------------//
LoginRx loginRxObj = LoginRx(
  empty: LoginModel(),
  dataFetcher: BehaviorSubject<LoginModel>(),
);

// _____________ LogOut Api Access _____________
LogOutRx logOutRxObj = LogOutRx(empty: {}, dataFetcher: BehaviorSubject<Map>());

// ------------- Resend OTP Api Access -------------
ResendOtpRx resendOtpRxObj = ResendOtpRx(
  empty: ResendOtpModel(),
  dataFetcher: BehaviorSubject<ResendOtpModel>(),
);


// _____________ Forgot Password Api Access _____________
ForgotPasswordRx forgotPasswordRxObj = ForgotPasswordRx(
  empty: ForgetPasswordModel(),
  dataFetcher: BehaviorSubject<ForgetPasswordModel>(),
);

// _____________ Reset Password Api Access _____________
ResetPasswordRx resetPasswordRxObj = ResetPasswordRx(
  empty: SetForgetPasswordModel(),
  dataFetcher: BehaviorSubject<SetForgetPasswordModel>(),
);

// ------------- Delete Account Api Access -------------
DeleteAccountRx deleteAccountRxObj = DeleteAccountRx(
  empty: DeleteAccountModel(),
  dataFetcher: BehaviorSubject<DeleteAccountModel>(),
);

// ------------- Get Profile Api Access -------------
GetProfileRx getProfileRxObj = GetProfileRx(
  empty: GetProfileModel(),
  dataFetcher: BehaviorSubject<GetProfileModel>(),
);


// //_________________Update Password Api Access ______________________//
// UpdatePasswordRx updatePasswordRxObj =
//     UpdatePasswordRx(empty: {}, dataFetcher: BehaviorSubject<Map>());

// //_________________Privacy Policy Api Access ______________________//
// PrivacyPolicyRx privacyPolicyRxObj = PrivacyPolicyRx(
//   empty: PrivacyPolicyModel(),
//   dataFetcher: BehaviorSubject<PrivacyPolicyModel>(),
// );

// //_________________Terms And Conditions Api Access ______________________//
// TermsAndConditionsRx termsAndConditionsRxObj = TermsAndConditionsRx(
//   empty: PrivacyPolicyModel(),
//   dataFetcher: BehaviorSubject<PrivacyPolicyModel>(),
// );

// ------------- Update Profile Api Access -------------
UpdateProfileRx updateProfileRxObj = UpdateProfileRx(
  empty: UpdateProfileModel(),
  dataFetcher: BehaviorSubject<UpdateProfileModel>(),
);

// ------------- Change Password Api Access -------------
ChangePasswordRx changePasswordRxObj = ChangePasswordRx(
  empty: ChangePasswordModel(),
  dataFetcher: BehaviorSubject<ChangePasswordModel>(),
);

// ------------- Help & Support Api Access -------------
HelpAndSupportRx helpAndSupportRxObj = HelpAndSupportRx(
  empty: HelpAndSupportModel(),
  dataFetcher: BehaviorSubject<HelpAndSupportModel>(),
);

// ------------- Privacy Policy Api Access -------------
PrivacyPolicyRx privacyPolicyRxObj = PrivacyPolicyRx(
  empty: PrivacyPolicyModel(),
  dataFetcher: BehaviorSubject<PrivacyPolicyModel>(),
);

// ------------- Terms and Condition Api Access -------------
TermsAndConditionRx termsAndConditionRxObj = TermsAndConditionRx(
  empty: TermsAndConditionModel(),
  dataFetcher: BehaviorSubject<TermsAndConditionModel>(),
);

// ------------- Home Data Api Access -------------
HomeDataRx homeDataRxObj = HomeDataRx(
  empty: HomeDataModel(),
  dataFetcher: BehaviorSubject<HomeDataModel>(),
);

// ------------- Insights Data Api Access -------------
InsightsDataRx insightsDataRxObj = InsightsDataRx(
  empty: InsightsDataModel(),
  dataFetcher: BehaviorSubject<InsightsDataModel>(),
);

// ------------- Tags Api Access -------------
TagsRx tagsRxObj = TagsRx(
  empty: TagsModel(),
  dataFetcher: BehaviorSubject<TagsModel>(),
);

// ------------- Get All Journal Api Access -------------
GetAllJournalRx getAllJournalRxObj = GetAllJournalRx(
  empty: GetAllJournalModel(),
  dataFetcher: BehaviorSubject<GetAllJournalModel>(),
);

