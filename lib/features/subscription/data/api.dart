import 'dart:convert';
import 'dart:io';
import 'package:dhikru_linda_flutter/features/subscription/model/get_subscrition/get_subscription_model.dart';
import 'package:dhikru_linda_flutter/networks/dio/dio.dart';
import 'package:dhikru_linda_flutter/networks/endpoints.dart';
import 'package:dhikru_linda_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';

import 'package:dhikru_linda_flutter/constants/app_constants.dart';
import 'package:dhikru_linda_flutter/features/subscription/model/verify_google_subscription_model.dart';
import 'package:dhikru_linda_flutter/helpers/di.dart';

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

  Future<VerifyResponse> verifySubscriptionApi({
    required String productId,
    required String purchaseToken,
    String? purchaseId,
    String? transactionId,
    String? originalTransactionId,
    String? authToken,
    String? basePlanId,
    String? platform,
  }) async {
    try {
      final isApple = (platform == 'apple') || (platform == null && Platform.isIOS);
      final resolvedPlatform = isApple ? 'apple' : 'google';
      final resolvedTxId = transactionId ?? purchaseId;

      final request = GoogleVerifyRequest(
        platform: resolvedPlatform,
        productId: productId,
        purchaseToken: purchaseToken,
        purchaseId: resolvedTxId,
        transactionId: resolvedTxId,
        originalTransactionId: originalTransactionId,
        basePlanId: basePlanId,
      );

      final token = authToken ?? appData.read(kKeyAccessToken);
      final Options? options = token != null && token.toString().isNotEmpty
          ? Options(headers: {'Authorization': 'Bearer $token'})
          : null;

      final payload = request.toJson()..removeWhere((k, v) => v == null);
      final endpoint = isApple
          ? Endpoints.verifyAppleSubscription()
          : Endpoints.verifyGoogleSubscription();

      Response response = await DioSingleton.instance.dio.post(
        endpoint,
        data: payload,
        options: options,
      );

      final Map<String, dynamic> body = response.data is Map<String, dynamic>
          ? response.data
          : jsonDecode(response.data.toString());

      return VerifyResponse.fromJson(body);
    } catch (error) {
      rethrow;
    }
  }

  Future<VerifyResponse> verifyGoogleSubscriptionApi({
    required String productId,
    required String purchaseToken,
    String? purchaseId,
    String? transactionId,
    String? originalTransactionId,
    String? authToken,
    String? basePlanId,
    String? platform,
  }) {
    return verifySubscriptionApi(
      productId: productId,
      purchaseToken: purchaseToken,
      purchaseId: purchaseId,
      transactionId: transactionId,
      originalTransactionId: originalTransactionId,
      authToken: authToken,
      basePlanId: basePlanId,
      platform: platform,
    );
  }
}

