// ignore_for_file: use_build_context_synchronously
import 'dart:developer';
import 'package:dhikru_linda_flutter/features/auth/set_new_password/model/set_new_password_model.dart';
import 'package:dhikru_linda_flutter/networks/rx_base.dart';
import 'package:flutter/foundation.dart';
import 'package:dhikru_linda_flutter/helpers/toast.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'api.dart';

final class ResetPasswordRx extends RxResponseInt<SetForgetPasswordModel> {
  final api = ResetPasswordApi.instance;

  ResetPasswordRx({required super.empty, required super.dataFetcher});

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  ValueStream get getFileData => dataFetcher.stream;

  Future<bool> resetPasswordRx({
    required String email,
    required String resetToken,
    required String password,
    required String passwordConfirmation,
  }) async {
    isLoading.value = true;
    try {
      final data = await api.resetPasswordApi(
        email: email,
        resetToken: resetToken,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      handleSuccessWithReturn(data);
      return true;
    } catch (error) {
      handleErrorWithReturn(error);
      return false;
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

        // 3. Fallback to top-level message
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
