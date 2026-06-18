import 'dart:convert';
import 'package:dhikru_linda_flutter/features/auth/register/model/register_verify_otp_model.dart';
import 'package:dhikru_linda_flutter/helpers/toast.dart';
import 'package:dhikru_linda_flutter/networks/dio/dio.dart';
import 'package:dhikru_linda_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';
import 'package:dhikru_linda_flutter/networks/endpoints.dart';

final class RegisterVerifyOtpApi {
  static final RegisterVerifyOtpApi _singleton = RegisterVerifyOtpApi._internal();
  RegisterVerifyOtpApi._internal();
  static RegisterVerifyOtpApi get instance => _singleton;

  Future<RegisterVerifyOtpModel> registerVerifyOtpApi({
    required String email,
    required String otp,
  }) async {
    try {
      final Map<String, dynamic> data = {
        "email": email,
        "otp": otp,
      };

      Response response = await postHttp(Endpoints.registerVerifyOtp(), data);

      if (response.statusCode == 200) {
        final verifyModel = RegisterVerifyOtpModel.fromRawJson(json.encode(response.data));
        ToastUtil.showShortToast(response.data['message']);
        return verifyModel;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
