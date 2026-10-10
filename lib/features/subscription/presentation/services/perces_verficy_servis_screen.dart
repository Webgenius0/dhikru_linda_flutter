import 'package:dio/dio.dart';

import '../log/presces_log.dart';

/// Sends the Google Play purchase token to your backend for verification.
class PurchaseVerifyService {
  // TODO: backend developer-এর দেওয়া আসল endpoint অনুযায়ী ঠিক করুন
  static const String _verifyUrl =
      'https://feranpage.thesyndicates.team/api/subscription/verify-google';

  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json', 'Accept-Language': 'en'},
    ),
  );

  /// Returns true only if the backend confirms the purchase is valid
  /// and the subscription is activated for this user.
  static Future<bool> verifyGooglePurchase({
    required String authToken,
    required String productId,
    required String purchaseToken,
    String? purchaseId,
  }) async {
    PLog.section('BACKEND VERIFY REQUEST');

    final stopwatch = Stopwatch()..start();

    PLog.kv('Request', {
      'URL': _verifyUrl,
      'Method': 'POST',
      'platform': 'google',
      'product_id': productId,
      'purchase_id': purchaseId,
      'purchase_token': PLog.mask(purchaseToken),
      'auth_token': PLog.mask(authToken),
    });

    try {
      final response = await _dio.post(
        _verifyUrl,
        data: {
          'platform': 'google',
          'product_id': productId,
          'purchase_token': purchaseToken,
          'purchase_id': purchaseId,
        },
        options: Options(headers: {'Authorization': 'Bearer $authToken'}),
      );

      stopwatch.stop();
      PLog.kv('Response', {
        'HTTP status': response.statusCode,
        'Time': '${stopwatch.elapsedMilliseconds} ms',
        'Body': response.data,
      });

      final body = response.data;
      final httpOk = response.statusCode == 200 || response.statusCode == 201;

      if (!httpOk) {
        PLog.error('Backend returned non-success HTTP status: ${response.statusCode}');
        return false;
      }

      if (body is Map && body['success'] == false) {
        PLog.error(
          'Backend said success=false. message: ${body['message']}',
        );
        return false;
      }

      PLog.success('Backend verified the purchase');
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
        PLog.warn('$code → backend/server error. Send the response body above to backend developer.');
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        PLog.warn('Timeout → slow network or server not responding.');
      } else if (e.type == DioExceptionType.connectionError) {
        PLog.warn('Connection error → no internet or wrong host.');
      }

      PLog.error('Verify request failed', e, st);
      return false;
    } catch (e, st) {
      PLog.error('Unexpected verify error', e, st);
      return false;
    }
  }
}