import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';
import 'package:dhikru_linda_flutter/constants/app_constants.dart';
import 'package:dhikru_linda_flutter/helpers/all_routes.dart';
import 'package:dhikru_linda_flutter/helpers/di.dart';
import 'package:dhikru_linda_flutter/helpers/navigation_service.dart';
import 'package:dhikru_linda_flutter/helpers/toast.dart';

import '../exception_handler/data_source.dart';

final class Logger extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log("= = = Dio Request = = =");
    log("${options.headers}");
    log("${options.data}");
    log("${options.contentType}");
    log("${options.extra}");
    log("${options.baseUrl}${options.path}");
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log("= = = Dio Success Response = = =");
    log(json.encode(response.data));
    log("${response.requestOptions}");
    log("${response.statusCode}");
    log("${response.statusMessage}");
    log("${response.headers}");
    log("${response.extra}");

    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      final code = data['code'];
      final message = data['message']?.toString() ?? '';
      final msgLower = message.toLowerCase();
      final isPremiumRestriction = code == 403 ||
          (data['success'] == false &&
              (code == 403 ||
                  msgLower.contains('premium') ||
                  msgLower.contains('upgrade') ||
                  msgLower.contains('companion') ||
                  msgLower.contains('unlock')));

      if (isPremiumRestriction) {
        if (message.isNotEmpty) {
          ToastUtil.showShortToast(message, forceShow: true);
        }
        NavigationService.navigateTo(Routes.subscriptionScreen);
      }
    }

    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      log("= = = Dio Error Response = = =");
      log('Error Response: ${err.response}');
      log('Error Message: ${err.message}');
      log('Error Type: ${err.type}');
      log('Error: ${err.error}');
      log('Error Req option: ${err.requestOptions}');
    }

    if (err.response?.statusCode == 401) {
      final isLoggedIn = appData.read(kKeyIsLoggedIn) ?? false;
      if (isLoggedIn) {
        appData.write(kKeyIsLoggedIn, false);
        appData.remove(kKeyAccessToken);
        appData.remove(kKeyName);
        appData.remove(kKeyEmail);
        ToastUtil.showShortToast("Session expired. Please log in again.");
        NavigationService.navigateToUntilReplacement(Routes.logInScreen);
      }
    } else if (err.response?.statusCode == 403) {
      final responseData = err.response?.data;
      String? msg;
      if (responseData is Map<String, dynamic>) {
        msg = responseData['message']?.toString();
      }
      if (msg != null && msg.isNotEmpty) {
        ToastUtil.showShortToast(msg, forceShow: true);
      }
      NavigationService.navigateTo(Routes.subscriptionScreen);
    } else if (err.response?.data is Map<String, dynamic>) {
      final data = err.response!.data as Map<String, dynamic>;
      final code = data['code'];
      final message = data['message']?.toString() ?? '';
      final msgLower = message.toLowerCase();
      if (code == 403 ||
          msgLower.contains('premium') ||
          msgLower.contains('upgrade') ||
          msgLower.contains('companion') ||
          msgLower.contains('unlock')) {
        if (message.isNotEmpty) {
          ToastUtil.showShortToast(message, forceShow: true);
        }
        NavigationService.navigateTo(Routes.subscriptionScreen);
      }
    }

    ErrorHandler.handle(err).failure;
    return super.onError(err, handler);
  }
}
