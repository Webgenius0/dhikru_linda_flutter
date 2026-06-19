import 'dart:convert';
import 'package:dhikru_linda_flutter/features/profile/model/terms_and_condition_model.dart';
import 'package:dhikru_linda_flutter/networks/dio/dio.dart';
import 'package:dhikru_linda_flutter/networks/endpoints.dart';
import 'package:dhikru_linda_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';

final class TermsAndConditionApi {
  static final TermsAndConditionApi _singleton = TermsAndConditionApi._internal();
  TermsAndConditionApi._internal();
  static TermsAndConditionApi get instance => _singleton;

  Future<TermsAndConditionModel> getTermsAndConditionApi() async {
    try {
      Response response = await getHttp(Endpoints.termsAndCondition());

      if (response.statusCode == 200) {
        final resData = TermsAndConditionModel.fromRawJson(json.encode(response.data));
        return resData;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
