import 'dart:convert';
import 'package:dhikru_linda_flutter/features/home/model/home_data_model.dart';
import 'package:dhikru_linda_flutter/networks/dio/dio.dart';
import 'package:dhikru_linda_flutter/networks/endpoints.dart';
import 'package:dhikru_linda_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';

final class HomeDataApi {
  static final HomeDataApi _singleton = HomeDataApi._internal();
  HomeDataApi._internal();
  static HomeDataApi get instance => _singleton;

  Future<HomeDataModel> getHomeDataApi() async {
    try {
      Response response = await getHttp(Endpoints.homeData());

      if (response.statusCode == 200) {
        final resData = HomeDataModel.fromRawJson(json.encode(response.data));
        return resData;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
