import 'dart:convert';
import 'package:dhikru_linda_flutter/features/auth/register/model/resend_otp_model.dart';
import 'package:dhikru_linda_flutter/helpers/toast.dart';
import 'package:dhikru_linda_flutter/networks/dio/dio.dart';
import 'package:dhikru_linda_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';
import 'package:dhikru_linda_flutter/networks/endpoints.dart';

final class ResendOtpApi {
  static final ResendOtpApi _singleton = ResendOtpApi._internal();
  ResendOtpApi._internal();
  static ResendOtpApi get instance => _singleton;

  Future<ResendOtpModel> resendOtpApi({
    required String email,
  }) async {
    try {
      final Map<String, dynamic> data = {
        "email": email,
      };

      Response response = await postHttp(Endpoints.resendOtp(), data);

      if (response.statusCode == 200) {
        final resendModel = ResendOtpModel.fromRawJson(json.encode(response.data));
        ToastUtil.showShortToast(response.data['message'], forceShow: true);
        return resendModel;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
