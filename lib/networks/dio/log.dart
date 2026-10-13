import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../exception_handler/data_source.dart';
import '../stream_cleaner.dart';

/// Interceptor that handles session expiration / unauthenticated responses.
/// Active in both debug and release builds to preserve core authentication flow.
final class AuthInterceptor extends Interceptor {
  static bool _isHandlingUnauth = false;

  void _handleUnauthenticatedSession() async {
    if (_isHandlingUnauth) return;
    _isHandlingUnauth = true;

    try {
      await totalDataClean();
    } catch (e) {
      if (kDebugMode) {
        log('Error handling unauthenticated session: $e');
      }
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

    ErrorHandler.handle(err).failure;
    return super.onError(err, handler);
  }
}

/// Secure Dio logging interceptor that runs only in debug mode and
/// masks sensitive tokens, passwords, and purchase credentials.
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

  static bool _isSensitiveKey(String key) {
    final normalized = key.toLowerCase().replaceAll(RegExp(r'[-_]'), '');
    const sensitiveKeys = {
      'authorization',
      'purchasetoken',
      'password',
      'passwordconfirmation',
      'token',
      'accesstoken',
      'refreshtoken',
      'authtoken',
      'bearer',
      'secret',
      'clientsecret',
    };
    return sensitiveKeys.contains(normalized);
  }

  /// Masks sensitive strings (tokens, passwords, keys) showing only the first
  /// 6 and last 6 characters (e.g. "Bearer eyJ0eX…Yq5TVw" or "abc123…xyz789").
  static String _maskSensitiveString(String value, {int show = 6}) {
    if (value.isEmpty) return value;

    final trimmed = value.trim();
    final bearerMatch = RegExp(r'^(Bearer\s+)(.+)$', caseSensitive: false).firstMatch(trimmed);
    if (bearerMatch != null) {
      final prefix = bearerMatch.group(1)!;
      final token = bearerMatch.group(2)!;
      return '$prefix${_maskSubString(token, show: show)}';
    }

    return _maskSubString(trimmed, show: show);
  }

  static String _maskSubString(String str, {int show = 6}) {
    if (str.length <= show) {
      return '***';
    }
    if (str.length <= show * 2) {
      final half = (str.length / 2).floor();
      return '${str.substring(0, half)}…';
    }
    return '${str.substring(0, show)}…${str.substring(str.length - show)}';
  }

  /// Recursively masks sensitive fields in Maps, Lists, or JSON strings.
  static dynamic _maskSensitiveData(dynamic data) {
    if (data == null) return null;

    if (data is Map) {
      final Map<String, dynamic> masked = {};
      data.forEach((key, value) {
        final keyStr = key.toString();
        if (_isSensitiveKey(keyStr)) {
          if (value is String) {
            masked[keyStr] = _maskSensitiveString(value);
          } else if (value is List) {
            masked[keyStr] = value
                .map((item) =>
                    item != null ? _maskSensitiveString(item.toString()) : null)
                .toList();
          } else if (value != null) {
            masked[keyStr] = _maskSensitiveString(value.toString());
          } else {
            masked[keyStr] = null;
          }
        } else {
          masked[keyStr] = _maskSensitiveData(value);
        }
      });
      return masked;
    } else if (data is List) {
      return data.map((item) => _maskSensitiveData(item)).toList();
    } else if (data is String) {
      final trimmed = data.trim();
      if ((trimmed.startsWith('{') && trimmed.endsWith('}')) ||
          (trimmed.startsWith('[') && trimmed.endsWith(']'))) {
        try {
          final decoded = json.decode(data);
          final masked = _maskSensitiveData(decoded);
          return const JsonEncoder.withIndent('  ').convert(masked);
        } catch (_) {
          return data;
        }
      }
      return data;
    }
    return data;
  }

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
    final maskedData = _maskSensitiveData(data);
    final prettyData = _prettyPrintJson(maskedData);
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
        final isSensitive = _isSensitiveKey(field.key);
        final val = isSensitive ? _maskSensitiveString(field.value) : field.value;
        buffer.write('    "${field.key}": "$val"');
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
    if (!kDebugMode) return super.onRequest(options, handler);

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
      final maskedHeaders = _maskSensitiveData(options.headers);
      final prettyHeaders = _prettyPrintJson(maskedHeaders);
      for (var line in prettyHeaders.split('\n')) {
        log('$_cyan║$_magenta   $line$_reset');
      }
    }

    if (options.queryParameters.isNotEmpty) {
      log('$_cyan║$_yellow Query Parameters:$_reset');
      final maskedParams = _maskSensitiveData(options.queryParameters);
      final prettyParams = _prettyPrintJson(maskedParams);
      for (var line in prettyParams.split('\n')) {
        log('$_cyan║$_white   $line$_reset');
      }
    }

    if (options.data != null) {
      log('$_cyan║$_yellow Body:$_reset');
      String bodyString;
      if (options.data is FormData) {
        bodyString = _formatFormData(options.data as FormData);
      } else {
        final maskedBody = _maskSensitiveData(options.data);
        bodyString = _prettyPrintJson(maskedBody);
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
    if (!kDebugMode) return super.onResponse(response, handler);

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

    if (response.headers.map.isNotEmpty) {
      final maskedHeaders = _maskSensitiveData(response.headers.map);
      log('$_green║$_yellow Headers: $_magenta$maskedHeaders$_reset');
    }

    _logResponseData(response, _green);

    log(
      '$_green╚══════════════════════════════════════════════════════════════════════════════$_reset',
    );
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
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
          final maskedData = _maskSensitiveData(response.data);
          final prettyData = _prettyPrintJson(maskedData);
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

    return super.onError(err, handler);
  }
}
