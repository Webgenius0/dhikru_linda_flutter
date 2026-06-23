import 'dart:convert';
import 'package:dhikru_linda_flutter/features/auth/forgot_password/model/forgot_password_verify_otp_model.dart';
import 'package:dhikru_linda_flutter/helpers/toast.dart';
import 'package:dhikru_linda_flutter/networks/dio/dio.dart';
import 'package:dhikru_linda_flutter/networks/endpoints.dart';
import 'package:dhikru_linda_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';

final class ForgotPasswordVerifyOtpApi {
  static final ForgotPasswordVerifyOtpApi _singleton = ForgotPasswordVerifyOtpApi._internal();
  ForgotPasswordVerifyOtpApi._internal();
  static ForgotPasswordVerifyOtpApi get instance => _singleton;

  Future<ForgotPasswordVerifyOtpModel> forgotPasswordVerifyOtpApi({
    required String email,
    required String otp,
  }) async {
    try {
      final Map<String, dynamic> data = {
        "email": email,
        "otp": otp,
      };

      Response response = await postHttp(Endpoints.forgetPasswordVerifyOtp(), data);

      if (response.statusCode == 200) {
        final verifyModel = ForgotPasswordVerifyOtpModel.fromRawJson(json.encode(response.data));
        ToastUtil.showShortToast(verifyModel.message ?? "OTP Verified Successfully");
        return verifyModel;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
