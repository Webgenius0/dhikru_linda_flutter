import 'dart:convert';
import 'package:dhikru_linda_flutter/constants/app_constants.dart';
import 'package:dhikru_linda_flutter/features/auth/login/model/login_model.dart';
import 'package:dhikru_linda_flutter/helpers/di.dart';
import 'package:dhikru_linda_flutter/helpers/toast.dart';
import 'package:dhikru_linda_flutter/networks/dio/dio.dart';
import 'package:dhikru_linda_flutter/networks/endpoints.dart';
import 'package:dhikru_linda_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';

final class AppleSignInApi {
  static final AppleSignInApi _singleton = AppleSignInApi._internal();
  AppleSignInApi._internal();
  static AppleSignInApi get instance => _singleton;

  Future<LoginModel> appleLoginApi({
    required String accessToken,
  }) async {
    try {
      Map<String, dynamic> formDataMap = {
        "access_token": accessToken,
      };

      FormData data = FormData.fromMap(formDataMap);

      Response response = await postHttp(Endpoints.appleLogin(), data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = LoginModel.fromRawJson(json.encode(response.data));
        // Save token and login state
        if (data.data?.token != null) {
          appData.write(kKeyIsLoggedIn, true);
          appData.write(kKeyAccessToken, data.data!.token);
          DioSingleton.instance.update(data.data!.token!);
        }
        if (data.data?.user != null) {
          if (data.data!.user!.name != null) {
            appData.write(kKeyName, data.data!.user!.name);
          }
          if (data.data!.user!.email != null) {
            appData.write(kKeyEmail, data.data!.user!.email);
          }
        }
        ToastUtil.showShortToast(
          data.message ?? "Logged in with Apple successfully.",
          forceShow: true,
        );
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
