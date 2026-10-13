import 'dart:io';
import 'package:dhikru_linda_flutter/features/subscription/data/api.dart';
import 'package:dhikru_linda_flutter/features/subscription/model/verify_google_subscription_model.dart';
import 'package:dhikru_linda_flutter/networks/endpoints.dart';
import 'package:dio/dio.dart';

import '../log/presces_log.dart';

enum VerifyStatus {
  success,
  expiredOrInactive,
  failed,
}

class PurchaseVerificationResult {
  final VerifyStatus status;
  final String? message;
  final VerifyResponse? response;

  bool get isSuccess => status == VerifyStatus.success;
  bool get isExpiredOrInactive => status == VerifyStatus.expiredOrInactive;

  const PurchaseVerificationResult({
    required this.status,
    this.message,
    this.response,
  });

  factory PurchaseVerificationResult.success(VerifyResponse response) =>
      PurchaseVerificationResult(
        status: VerifyStatus.success,
        message: response.message,
        response: response,
      );

  factory PurchaseVerificationResult.expired(String message) =>
      PurchaseVerificationResult(
        status: VerifyStatus.expiredOrInactive,
        message: message,
      );

  factory PurchaseVerificationResult.failure(String message) =>
      PurchaseVerificationResult(
        status: VerifyStatus.failed,
        message: message,
      );
}

/// Sends the In-App Purchase token to backend for verification.
class PurchaseVerifyService {
  /// Returns full VerifyResponse if needed by caller
  static Future<VerifyResponse> verifySubscription({
    required String productId,
    required String purchaseToken,
    String? purchaseId,
    String? transactionId,
    String? authToken,
    String? basePlanId,
    String? platform,
  }) async {
    return GetSubscriptionApi.instance.verifySubscriptionApi(
      productId: productId,
      purchaseToken: purchaseToken,
      purchaseId: purchaseId,
      transactionId: transactionId,
      authToken: authToken,
      basePlanId: basePlanId,
      platform: platform,
    );
  }

  /// Verifies the purchase and provides detailed status (success, expired, or failed).
  static Future<PurchaseVerificationResult> verifyPurchase({
    required String authToken,
    required String productId,
    required String purchaseToken,
    String? purchaseId,
    String? transactionId,
    String? basePlanId,
    String? platform,
  }) async {
    PLog.section('BACKEND VERIFY REQUEST');

    final stopwatch = Stopwatch()..start();
    final devicePlatform = platform ?? (Platform.isIOS ? 'apple' : 'google');
    final isApple = devicePlatform == 'apple';
    final verifyEndpoint = isApple
        ? Endpoints.verifyAppleSubscription()
        : Endpoints.verifyGoogleSubscription();
    final verifyUrl = "$url$verifyEndpoint";
    final resolvedTxId = transactionId ?? purchaseId;

    PLog.kv('Request', {
      'URL': verifyUrl,
      'Method': 'POST',
      'platform': devicePlatform,
      'product_id': productId,
      'base_plan_id': basePlanId ?? 'unspecified',
      'purchase_id': resolvedTxId,
      if (isApple) 'transaction_id': resolvedTxId,
      'purchase_token': PLog.mask(purchaseToken),
      'auth_token': PLog.mask(authToken),
    });

    try {
      final response = await GetSubscriptionApi.instance.verifySubscriptionApi(
        productId: productId,
        purchaseToken: purchaseToken,
        purchaseId: resolvedTxId,
        transactionId: resolvedTxId,
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
        final msgLower = response.message.toLowerCase();
        if (msgLower.contains('expired') || msgLower.contains('not active') || msgLower.contains('inactive')) {
          return PurchaseVerificationResult.expired(response.message);
        }
        return PurchaseVerificationResult.failure(response.message);
      }

      PLog.success('Backend verified the purchase successfully!');
      return PurchaseVerificationResult.success(response);
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
      final responseBody = e.response?.data;
      String responseMessage = '';
      if (responseBody is Map) {
        responseMessage = responseBody['message']?.toString() ?? '';
      } else if (responseBody is String) {
        responseMessage = responseBody;
      }

      final msgLower = responseMessage.toLowerCase();
      final isExpiredOrInactive = code == 400 &&
          (msgLower.contains('expired') ||
           msgLower.contains('not active') ||
           msgLower.contains('inactive') ||
           msgLower.contains('apple subscription'));

      if (isExpiredOrInactive) {
        PLog.warn('Subscription is expired or inactive according to backend ($responseMessage)');
        return PurchaseVerificationResult.expired(responseMessage);
      }

      if (code == 401) {
        PLog.warn('401 → login token expired/invalid. Check _getAuthToken().');
      } else if (code == 403) {
        PLog.warn(
          '403 → backend may not have store permissions yet.',
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
      return PurchaseVerificationResult.failure(
        responseMessage.isNotEmpty ? responseMessage : (e.message ?? 'Verification failed'),
      );
    } catch (e, st) {
      stopwatch.stop();
      PLog.error('Unexpected verify error', e, st);
      return PurchaseVerificationResult.failure(e.toString());
    }
  }

  /// Backward-compatible helper returning bool
  static Future<bool> verifyGooglePurchase({
    required String authToken,
    required String productId,
    required String purchaseToken,
    String? purchaseId,
    String? basePlanId,
    String? platform,
  }) async {
    final result = await verifyPurchase(
      authToken: authToken,
      productId: productId,
      purchaseToken: purchaseToken,
      purchaseId: purchaseId,
      basePlanId: basePlanId,
      platform: platform,
    );
    return result.isSuccess;
  }
}