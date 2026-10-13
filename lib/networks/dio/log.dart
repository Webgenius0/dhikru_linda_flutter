// import 'dart:convert';
// import 'dart:developer';

// import 'package:flutter/foundation.dart';

// import 'package:dio/dio.dart';
// import 'package:dhikru_linda_flutter/constants/app_constants.dart';
// import 'package:dhikru_linda_flutter/helpers/all_routes.dart';
// import 'package:dhikru_linda_flutter/helpers/di.dart';
// import 'package:dhikru_linda_flutter/helpers/navigation_service.dart';
// import 'package:dhikru_linda_flutter/helpers/toast.dart';

// import '../exception_handler/data_source.dart';

// final class Logger extends Interceptor {
//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
//     log("= = = Dio Request = = =");
//     log("${options.headers}");
//     log("${options.data}");
//     log("${options.contentType}");
//     log("${options.extra}");
//     log("${options.baseUrl}${options.path}");
//     return super.onRequest(options, handler);
//   }

//   @override
//   void onResponse(Response response, ResponseInterceptorHandler handler) {
//     log("= = = Dio Success Response = = =");
//     log(json.encode(response.data));
//     log("${response.requestOptions}");
//     log("${response.statusCode}");
//     log("${response.statusMessage}");
//     log("${response.headers}");
//     log("${response.extra}");

//     if (response.data is Map<String, dynamic>) {
//       final data = response.data as Map<String, dynamic>;
//       final code = data['code'];
//       final message = data['message']?.toString() ?? '';
//       final msgLower = message.toLowerCase();
//       final isPremiumRestriction = code == 403 ||
//           (data['success'] == false &&
//               (code == 403 ||
//                   msgLower.contains('premium') ||
//                   msgLower.contains('upgrade') ||
//                   msgLower.contains('companion') ||
//                   msgLower.contains('unlock')));

//       if (isPremiumRestriction) {
//         if (message.isNotEmpty) {
//           ToastUtil.showShortToast(message, forceShow: true);
//         }
//         NavigationService.navigateTo(Routes.subscriptionScreen);
//       }
//     }

//     return super.onResponse(response, handler);
//   }

//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) {
//     if (kDebugMode) {
//       log("= = = Dio Error Response = = =");
//       log('Error Response: ${err.response}');
//       log('Error Message: ${err.message}');
//       log('Error Type: ${err.type}');
//       log('Error: ${err.error}');
//       log('Error Req option: ${err.requestOptions}');
//     }

//     if (err.response?.statusCode == 401) {
//       final isLoggedIn = appData.read(kKeyIsLoggedIn) ?? false;
//       if (isLoggedIn) {
//         appData.write(kKeyIsLoggedIn, false);
//         appData.remove(kKeyAccessToken);
//         appData.remove(kKeyName);
//         appData.remove(kKeyEmail);
//         ToastUtil.showShortToast("Session expired. Please log in again.");
//         NavigationService.navigateToUntilReplacement(Routes.logInScreen);
//       }
//     } else if (err.response?.statusCode == 403) {
//       final responseData = err.response?.data;
//       String? msg;
//       if (responseData is Map<String, dynamic>) {
//         msg = responseData['message']?.toString();
//       }
//       if (msg != null && msg.isNotEmpty) {
//         ToastUtil.showShortToast(msg, forceShow: true);
//       }
//       NavigationService.navigateTo(Routes.subscriptionScreen);
//     } else if (err.response?.data is Map<String, dynamic>) {
//       final data = err.response!.data as Map<String, dynamic>;
//       final code = data['code'];
//       final message = data['message']?.toString() ?? '';
//       final msgLower = message.toLowerCase();
//       if (code == 403 ||
//           msgLower.contains('premium') ||
//           msgLower.contains('upgrade') ||
//           msgLower.contains('companion') ||
//           msgLower.contains('unlock')) {
//         if (message.isNotEmpty) {
//           ToastUtil.showShortToast(message, forceShow: true);
//         }
//         NavigationService.navigateTo(Routes.subscriptionScreen);
//       }
//     }

//     ErrorHandler.handle(err).failure;
//     return super.onError(err, handler);
//   }
// }

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../exception_handler/data_source.dart';
import '../stream_cleaner.dart';

final class Logger extends Interceptor {
  // ANSI color codes
  static const String _reset = '\x1B[0m';
  static const String _cyan = '\x1B[36m';
  static const String _green = '\x1B[32m';
  static const String _red = '\x1B[31m';
  static const String _yellow = '\x1B[33m';
  static const String _blue = '\x1B[34m';
  static const String _white = '\x1B[37m';
  static const String _magenta = '\x1B[35m';

  String _prettyPrintJson(dynamic json) {
    try {
      return const JsonEncoder.withIndent('  ').convert(json);
    } catch (e) {
      return json.toString();
    }
  }

  bool _isBinaryResponseData(Response response) {
    final data = response.data;
    return response.requestOptions.responseType == ResponseType.bytes ||
        data is Uint8List ||
        data is List<int>;
  }

  void _logResponseData(Response response, String prefixColor) {
    final data = response.data;
    if (data == null) {
      log('$prefixColor║$_white Response Data: null$_reset');
      return;
    }

    if (_isBinaryResponseData(response)) {
      log(
        '$prefixColor║$_yellow Response Data Type: $_white${data.runtimeType}$_reset',
      );
      return;
    }

    log('$prefixColor║$_yellow Response Data:$_reset');
    final prettyData = _prettyPrintJson(data);
    for (var line in prettyData.split('\n')) {
      log('$prefixColor║$_white   $line$_reset');
    }
  }

  String _formatFormData(FormData formData) {
    final buffer = StringBuffer();
    buffer.writeln('{');

    // Print form fields
    if (formData.fields.isNotEmpty) {
      buffer.writeln('  "fields": {');
      for (int i = 0; i < formData.fields.length; i++) {
        final field = formData.fields[i];
        buffer.write('    "${field.key}": "${field.value}"');
        if (i < formData.fields.length - 1 || formData.files.isNotEmpty) {
          buffer.writeln(',');
        } else {
          buffer.writeln();
        }
      }
      buffer.writeln('  }');
      if (formData.files.isNotEmpty) {
        buffer.writeln(',');
      }
    }

    // Print form files
    if (formData.files.isNotEmpty) {
      buffer.writeln('  "files": {');
      for (int i = 0; i < formData.files.length; i++) {
        final file = formData.files[i];
        buffer.write('    "${file.key}": {');
        buffer.write('"filename": "${file.value.filename}", ');
        buffer.write('"contentType": "${file.value.contentType}"');
        buffer.write('}');
        if (i < formData.files.length - 1) {
          buffer.writeln(',');
        } else {
          buffer.writeln();
        }
      }
      buffer.writeln('  }');
    }

    buffer.writeln('}');
    return buffer.toString();
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log(
      '$_cyan╔══════════════════════════════════════════════════════════════════════════════$_reset',
    );
    log('$_cyan║ $_blue📤 DIO REQUEST$_reset');
    log(
      '$_cyan╠══════════════════════════════════════════════════════════════════════════════$_reset',
    );
    log('$_cyan║$_white URL: ${options.baseUrl}${options.path}$_reset');
    log('$_cyan║$_white Method: $_yellow${options.method}$_reset');

    if (options.headers.isNotEmpty) {
      log('$_cyan║$_yellow Headers:$_reset');
      final prettyHeaders = _prettyPrintJson(options.headers);
      for (var line in prettyHeaders.split('\n')) {
        log('$_cyan║$_magenta   $line$_reset');
      }
    }

    if (options.data != null) {
      log('$_cyan║$_yellow Body:$_reset');
      String bodyString;
      if (options.data is FormData) {
        bodyString = _formatFormData(options.data as FormData);
      } else {
        bodyString = _prettyPrintJson(options.data);
      }
      for (var line in bodyString.split('\n')) {
        log('$_cyan║$_white   $line$_reset');
      }
    }

    if (options.contentType != null) {
      log('$_cyan║$_yellow Content-Type: $_white${options.contentType}$_reset');
    }

    log(
      '$_cyan╚══════════════════════════════════════════════════════════════════════════════$_reset',
    );
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log(
      '$_green╔══════════════════════════════════════════════════════════════════════════════$_reset',
    );
    log('$_green║ $_green✅ DIO SUCCESS RESPONSE$_reset');
    log(
      '$_green╠══════════════════════════════════════════════════════════════════════════════$_reset',
    );
    log(
      '$_green║$_white Status: $_blue${response.statusCode}$_white ${response.statusMessage}$_reset',
    );

    // Headers are a special type, just convert to string
    if (response.headers.toString().isNotEmpty) {
      log(
        '$_green║$_yellow Headers: $_magenta${response.headers.toString()}$_reset',
      );
    }

    _logResponseData(response, _green);

    log(
      '$_green╚══════════════════════════════════════════════════════════════════════════════$_reset',
    );
    return super.onResponse(response, handler);
  }

  static bool _isHandlingUnauth = false;

  void _handleUnauthenticatedSession() async {
    if (_isHandlingUnauth) return;
    _isHandlingUnauth = true;

    try {
      await totalDataClean();
      // NavigationService.navigateToReplacementUntil(Routes.loginScreen);
    } catch (e) {
      log('Error handling unauthenticated session: $e');
    } finally {
      Future.delayed(const Duration(seconds: 3), () {
        _isHandlingUnauth = false;
      });
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode;
    final responseData = err.response?.data;
    final String? message = responseData is Map
        ? responseData['message']?.toString()
        : null;

    final bool isUnauthenticated =
        statusCode == 401 ||
        message == "Unauthenticated." ||
        message == "token_not_valid" ||
        (message != null && message.toLowerCase().contains("unauthenticated"));

    if (isUnauthenticated) {
      _handleUnauthenticatedSession();
    }

    if (kDebugMode) {
      log(
        '$_red╔══════════════════════════════════════════════════════════════════════════════$_reset',
      );
      log('$_red║ $_red❌ DIO ERROR RESPONSE$_reset');
      log(
        '$_red╠══════════════════════════════════════════════════════════════════════════════$_reset',
      );
      log('$_red║$_yellow Error Type: $_magenta${err.type}$_reset');
      log('$_red║$_yellow Error Message: $_white${err.message}$_reset');

      if (err.response != null) {
        log(
          '$_red║$_yellow Status Code: $_magenta${err.response?.statusCode}$_reset',
        );
        final response = err.response!;
        if (_isBinaryResponseData(response)) {
          log(
            '$_red║$_yellow Response Data Type: $_white${response.data.runtimeType}$_reset',
          );
        } else {
          log('$_red║$_yellow Response Data:$_reset');
          final prettyData = _prettyPrintJson(response.data);
          for (var line in prettyData.split('\n')) {
            log('$_red║$_white   $line$_reset');
          }
        }
      }

      if (err.error != null) {
        log('$_red║$_yellow Error Details: $_white${err.error}$_reset');
      }

      log(
        '$_red║$_yellow Request URL: $_white${err.requestOptions.baseUrl}${err.requestOptions.path}$_reset',
      );
      log(
        '$_red╚══════════════════════════════════════════════════════════════════════════════$_reset',
      );
    }

    ErrorHandler.handle(err).failure;
    return super.onError(err, handler);
  }
}
