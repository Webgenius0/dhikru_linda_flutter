import 'dart:convert';
import 'package:dhikru_linda_flutter/constants/app_constants.dart';
import 'package:dhikru_linda_flutter/features/auth/login/model/login_model.dart';
import 'package:dhikru_linda_flutter/helpers/di.dart';
import 'package:dhikru_linda_flutter/helpers/toast.dart';
import 'package:dhikru_linda_flutter/networks/dio/dio.dart';
import 'package:dhikru_linda_flutter/networks/endpoints.dart';
import 'package:dhikru_linda_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';

final class LoginApi {
  static final LoginApi _singleton = LoginApi._internal();
  LoginApi._internal();
  static LoginApi get instance => _singleton;

  Future<LoginModel> loginApi({
    required String email,
    required String password,
  }) async {
    try {
      Map<String, dynamic> formDataMap = {
        "email": email,
        "password": password,
      };

      FormData data = FormData.fromMap(formDataMap);

      Response response = await postHttp(Endpoints.login(), data);

      if (response.statusCode == 200) {
        final data = LoginModel.fromRawJson(json.encode(response.data));
        // Save token and login state
        if (data.data!.token != null) {
          appData.write(kKeyIsLoggedIn, true);
          appData.write(kKeyAccessToken, data.data!.token);
          DioSingleton.instance.update(data.data!.token!);
        }
        if (data.data != null) {
          appData.write(kKeyName, data.data!.user!.name);
          appData.write(kKeyEmail, data.data!.user!.email);
        }
        ToastUtil.showShortToast(data.message ?? "Logged in successfully.");
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      // Handle generic errors
      rethrow;
    }
  }
}
