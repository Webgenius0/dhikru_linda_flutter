import 'dart:convert';
import 'package:dhikru_linda_flutter/features/auth/register/model/register_model.dart';
import 'package:dhikru_linda_flutter/helpers/toast.dart';
import 'package:dhikru_linda_flutter/networks/dio/dio.dart';
import 'package:dhikru_linda_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';
import '/networks/endpoints.dart';

final class RegisterApi {
  static final RegisterApi _singleton = RegisterApi._internal();
  RegisterApi._internal();
  static RegisterApi get instance => _singleton;

  Future<RegisterModel> registerApi({
       String ? name,
    required String email,
    required String password,
    required String passwordConfirmation,
  
  }) async {
    try {
       final Map<String, dynamic> data = {
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirmation,
      };

      Response response = await postHttp(Endpoints.register(), data);

      if (response.statusCode == 201) {
        final data = RegisterModel.fromRawJson(json.encode(response.data));
        ToastUtil.showShortToast(response.data['message'], forceShow: true);
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

