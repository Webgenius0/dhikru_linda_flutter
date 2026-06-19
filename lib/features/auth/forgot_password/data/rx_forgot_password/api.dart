import 'dart:convert';
import 'package:dhikru_linda_flutter/features/auth/forgot_password/model/forgot_password_model.dart';
import 'package:dhikru_linda_flutter/helpers/toast.dart';
import 'package:dhikru_linda_flutter/networks/dio/dio.dart';
import 'package:dhikru_linda_flutter/networks/endpoints.dart';
import 'package:dhikru_linda_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';

final class ForgotPasswordApi {
  static final ForgotPasswordApi _singleton = ForgotPasswordApi._internal();
  ForgotPasswordApi._internal();
  static ForgotPasswordApi get instance => _singleton;

  Future<ForgetPasswordModel> forgotPasswordApi({
    required String email,
  }) async {
    try {
      Map<String, dynamic> formDataMap = {
        "email": email,
      };

      FormData data = FormData.fromMap(formDataMap);

      Response response = await postHttp(Endpoints.forgotPassword(), data);

      if (response.statusCode == 200) {
        final data =
            ForgetPasswordModel.fromRawJson(json.encode(response.data));
        ToastUtil.showShortToast(data.message ?? "OTP Code Sent Successfully");
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
