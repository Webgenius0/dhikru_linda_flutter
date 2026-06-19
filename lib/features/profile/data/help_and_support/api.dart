import 'dart:convert';
import 'package:dhikru_linda_flutter/features/profile/model/help_and_support_model.dart';
import 'package:dhikru_linda_flutter/networks/dio/dio.dart';
import 'package:dhikru_linda_flutter/networks/endpoints.dart';
import 'package:dhikru_linda_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';

final class HelpAndSupportApi {
  static final HelpAndSupportApi _singleton = HelpAndSupportApi._internal();
  HelpAndSupportApi._internal();
  static HelpAndSupportApi get instance => _singleton;

  Future<HelpAndSupportModel> getHelpAndSupportApi() async {
    try {
      Response response = await getHttp(Endpoints.helpSupport());

      if (response.statusCode == 200) {
        final resData = HelpAndSupportModel.fromRawJson(json.encode(response.data));
        return resData;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
