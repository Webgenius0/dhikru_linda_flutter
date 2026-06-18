import 'dart:developer';
import 'package:dhikru_linda_flutter/features/auth/login/model/login_model.dart';
import 'package:dhikru_linda_flutter/helpers/toast.dart';
import 'package:dhikru_linda_flutter/networks/rx_base.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'api.dart';

final class LoginRx extends RxResponseInt<LoginModel> {
  final api = LoginApi.instance;

  LoginRx({required super.empty, required super.dataFetcher});

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  ValueStream get getFileData => dataFetcher.stream;

  Future<LoginModel?> loginRx({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    try {
      final data = await api.loginApi(
        email: email,
        password: password,
      );

      handleSuccessWithReturn(data);
      return data;
    } catch (error) {
      handleErrorWithReturn(error);
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  handleErrorWithReturn(dynamic error) {
    if (error is DioException) {
      final responseData = error.response?.data;
      if (responseData is Map<String, dynamic>) {
        // 1. Check for root-level field validation errors
        if (responseData.containsKey('errors')) {
          final errorMap = responseData['errors'];
          if (errorMap is Map && errorMap.isNotEmpty) {
            final firstErrorList = errorMap.values.first;
            if (firstErrorList is List && firstErrorList.isNotEmpty) {
              ToastUtil.showShortToast(firstErrorList.first.toString());
              log(error.toString());
              dataFetcher.sink.addError(error);
              return;
            }
          }
        }

        // 2. Check for errors under 'data' object
        if (responseData.containsKey('data') &&
            responseData['data'] is Map<String, dynamic>) {
          final dataMap = responseData['data'];

          if (dataMap.containsKey('errors')) {
            final errorMap = dataMap['errors'];
            if (errorMap is Map && errorMap.isNotEmpty) {
              final firstErrorList = errorMap.values.first;
              if (firstErrorList is List && firstErrorList.isNotEmpty) {
                ToastUtil.showShortToast(firstErrorList.first.toString());
                log(error.toString());
                dataFetcher.sink.addError(error);
                return;
              }
            }
          }

          if (dataMap.containsKey('error')) {
            final errorMsg = dataMap['error'];
            if (errorMsg is String && errorMsg.isNotEmpty) {
              ToastUtil.showShortToast(errorMsg);
              log(error.toString());
              dataFetcher.sink.addError(error);
              return;
            }
          }
        }

        // 3. Fallback to top-level server message
        final message = responseData['message'];
        if (message != null && message.toString().isNotEmpty) {
          ToastUtil.showShortToast(message.toString());
          log(error.toString());
          dataFetcher.sink.addError(error);
          return;
        }
      }
    }
    log(error.toString());
    dataFetcher.sink.addError(error);
  }
}
