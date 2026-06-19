import 'dart:convert';
import 'package:dhikru_linda_flutter/features/profile/model/change_password_model.dart';
import 'package:dhikru_linda_flutter/networks/dio/dio.dart';
import 'package:dhikru_linda_flutter/networks/endpoints.dart';
import 'package:dhikru_linda_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';

final class ChangePasswordApi {
  static final ChangePasswordApi _singleton = ChangePasswordApi._internal();
  ChangePasswordApi._internal();
  static ChangePasswordApi get instance => _singleton;

  Future<ChangePasswordModel> changePasswordApi({
    required String oldPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      final Map<String, dynamic> formDataMap = {
        "old_password": oldPassword,
        "new_password": newPassword,
        "new_password_confirmation": newPasswordConfirmation,
      };

      FormData data = FormData.fromMap(formDataMap);

      Response response = await postHttp(Endpoints.changePassword(), data);

      if (response.statusCode == 200) {
        final resData = ChangePasswordModel.fromRawJson(json.encode(response.data));
        return resData;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
