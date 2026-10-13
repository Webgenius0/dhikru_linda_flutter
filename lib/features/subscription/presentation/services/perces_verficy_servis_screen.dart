import 'dart:io';
import 'package:dhikru_linda_flutter/features/subscription/data/api.dart';
import 'package:dhikru_linda_flutter/features/subscription/model/verify_google_subscription_model.dart';
import 'package:dhikru_linda_flutter/networks/endpoints.dart';
import 'package:dio/dio.dart';

import '../log/presces_log.dart';

/// Sends the Google Play purchase token to your backend for verification.
class PurchaseVerifyService {
  /// Returns full VerifyResponse if needed by caller
  static Future<VerifyResponse> verifySubscription({
    required String productId,
    required String purchaseToken,
    String? purchaseId,
    String? authToken,
    String? basePlanId,
    String? platform,
  }) async {
    return GetSubscriptionApi.instance.verifyGoogleSubscriptionApi(
      productId: productId,
      purchaseToken: purchaseToken,
      purchaseId: purchaseId,
      authToken: authToken,
      basePlanId: basePlanId,
      platform: platform,
    );
  }

  /// Returns true only if the backend confirms the purchase is valid
  /// and the subscription is activated for this user.
  static Future<bool> verifyGooglePurchase({
    required String authToken,
    required String productId,
    required String purchaseToken,
    String? purchaseId,
    String? basePlanId,
    String? platform,
  }) async {
    PLog.section('BACKEND VERIFY REQUEST');

    final stopwatch = Stopwatch()..start();
    final verifyUrl = "$url${Endpoints.verifyGoogleSubscription()}";
    final devicePlatform = platform ?? (Platform.isIOS ? 'apple' : 'google');

    PLog.kv('Request', {
      'URL': verifyUrl,
      'Method': 'POST',
      'platform': devicePlatform,
      'product_id': productId,
      'base_plan_id': basePlanId ?? 'unspecified',
      'purchase_id': purchaseId,
      'purchase_token': PLog.mask(purchaseToken),
      'auth_token': PLog.mask(authToken),
    });

    try {
      final response = await GetSubscriptionApi.instance.verifyGoogleSubscriptionApi(
        productId: productId,
        purchaseToken: purchaseToken,
        purchaseId: purchaseId,
        authToken: authToken,
        basePlanId: basePlanId,
        platform: devicePlatform,
      );

      stopwatch.stop();
      PLog.kv('Response', {
        'Success': response.success,
        'IsPremium': response.isPremium,
        'BasePlanId': response.basePlanId,
        'ExpiresAt': response.expiresAt?.toIso8601String(),
        'Time': '${stopwatch.elapsedMilliseconds} ms',
        'Message': response.message,
      });

      if (!response.success || !response.isPremium) {
        PLog.error('Backend returned success=false or is_premium=false: ${response.message}');
        return false;
      }

      PLog.success('Backend verified the purchase successfully!');
      return true;
    } on DioException catch (e, st) {
      stopwatch.stop();
      PLog.kv('Dio error', {
        'Type': e.type,
        'HTTP status': e.response?.statusCode,
        'Message': e.message,
        'Response body': e.response?.data,
        'Time': '${stopwatch.elapsedMilliseconds} ms',
      });

      final code = e.response?.statusCode;
      if (code == 401) {
        PLog.warn('401 → login token expired/invalid. Check _getAuthToken().');
      } else if (code == 403) {
        PLog.warn(
          '403 → backend may not have Play Console permission yet '
          '(service account permission can take a few hours).',
        );
      } else if (code == 404) {
        PLog.warn('404 → endpoint URL is wrong or not deployed yet.');
      } else if (code == 422) {
        PLog.warn('422 → backend validation failed. Check request fields above.');
      } else if (code != null && code >= 500) {
        PLog.warn('$code → backend/server error. Send response body to backend developer.');
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        PLog.warn('Timeout → slow network or server not responding.');
      } else if (e.type == DioExceptionType.connectionError) {
        PLog.warn('Connection error → no internet or wrong host.');
      }

      PLog.error('Verify request failed', e, st);
      return false;
    } catch (e, st) {
      stopwatch.stop();
      PLog.error('Unexpected verify error', e, st);
      return false;
    }
  }
}