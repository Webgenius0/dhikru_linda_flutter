import 'dart:convert';
import 'package:dhikru_linda_flutter/features/profile/model/privacy_policy_model.dart';
import 'package:dhikru_linda_flutter/networks/dio/dio.dart';
import 'package:dhikru_linda_flutter/networks/endpoints.dart';
import 'package:dhikru_linda_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';

final class PrivacyPolicyApi {
  static final PrivacyPolicyApi _singleton = PrivacyPolicyApi._internal();
  PrivacyPolicyApi._internal();
  static PrivacyPolicyApi get instance => _singleton;

  Future<PrivacyPolicyModel> getPrivacyPolicyApi() async {
    try {
      Response response = await getHttp(Endpoints.privacyPolicy());

      if (response.statusCode == 200) {
        final resData = PrivacyPolicyModel.fromRawJson(json.encode(response.data));
        return resData;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
