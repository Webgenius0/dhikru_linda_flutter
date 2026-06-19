import 'dart:convert';
import 'package:dhikru_linda_flutter/features/insights/model/insight_data_model.dart';
import 'package:dhikru_linda_flutter/networks/dio/dio.dart';
import 'package:dhikru_linda_flutter/networks/endpoints.dart';
import 'package:dhikru_linda_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';

final class InsightsDataApi {
  static final InsightsDataApi _singleton = InsightsDataApi._internal();
  InsightsDataApi._internal();
  static InsightsDataApi get instance => _singleton;

  Future<InsightsDataModel> getInsightsDataApi() async {
    try {
      Response response = await getHttp(Endpoints.insights());

      if (response.statusCode == 200) {
        final resData = InsightsDataModel.fromRawJson(json.encode(response.data));
        return resData;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
