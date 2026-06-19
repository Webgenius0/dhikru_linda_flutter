import 'dart:convert';
import 'package:dhikru_linda_flutter/features/auth/set_new_password/model/set_new_password_model.dart';
import 'package:dhikru_linda_flutter/helpers/toast.dart';
import 'package:dhikru_linda_flutter/networks/dio/dio.dart';
import 'package:dhikru_linda_flutter/networks/endpoints.dart';
import 'package:dhikru_linda_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';

final class ResetPasswordApi {
  static final ResetPasswordApi _singleton = ResetPasswordApi._internal();
  ResetPasswordApi._internal();
  static ResetPasswordApi get instance => _singleton;

  Future<SetForgetPasswordModel> resetPasswordApi({
    required String email,
    required String resetToken,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final Map<String, dynamic> formDataMap = {
        "email": email,
        "reset_token": resetToken,
        "password": password,
        "password_confirmation": passwordConfirmation,
      };

      FormData data = FormData.fromMap(formDataMap);

      Response response = await postHttp(Endpoints.resetPassword(), data);

      if (response.statusCode == 200) {
        final resetModel = SetForgetPasswordModel.fromRawJson(json.encode(response.data));
        ToastUtil.showShortToast(resetModel.message ?? "Password reset successfully.");
        return resetModel;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
