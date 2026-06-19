import 'dart:convert';
import 'package:dhikru_linda_flutter/features/home/model/get_profile_model.dart';
import 'package:dhikru_linda_flutter/networks/dio/dio.dart';
import 'package:dhikru_linda_flutter/networks/endpoints.dart';
import 'package:dhikru_linda_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';

final class GetProfileApi {
  static final GetProfileApi _singleton = GetProfileApi._internal();
  GetProfileApi._internal();
  static GetProfileApi get instance => _singleton;

  Future<GetProfileModel> getProfileApi() async {
    try {
      Response response = await getHttp(
        Endpoints.getProfile(),
      );

      if (response.statusCode == 200) {
        final data = GetProfileModel.fromRawJson(json.encode(response.data));
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
