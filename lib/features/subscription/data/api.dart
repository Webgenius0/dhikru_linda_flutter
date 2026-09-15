import 'dart:convert';
import 'package:dhikru_linda_flutter/features/subscription/model/get_subscrition/get_subscription_model.dart';
import 'package:dhikru_linda_flutter/networks/dio/dio.dart';
import 'package:dhikru_linda_flutter/networks/endpoints.dart';
import 'package:dhikru_linda_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';

final class GetSubscriptionApi {
  static final GetSubscriptionApi _singleton = GetSubscriptionApi._internal();
  GetSubscriptionApi._internal();
  static GetSubscriptionApi get instance => _singleton;

  Future<GetSubscriptionModel> getSubscriptionStatusApi() async {
    try {
      Response response = await getHttp(Endpoints.getSubscriptionStatus());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = response.data is Map<String, dynamic>
            ? GetSubscriptionModel.fromJson(response.data)
            : GetSubscriptionModel.fromRawJson(json.encode(response.data));
        return resData;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
