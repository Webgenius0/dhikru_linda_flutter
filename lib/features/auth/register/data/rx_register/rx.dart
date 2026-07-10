// ignore_for_file: use_build_context_synchronously
import 'dart:developer';
import 'package:dhikru_linda_flutter/features/auth/register/model/register_model.dart';
import 'package:dhikru_linda_flutter/helpers/toast.dart';
import 'package:dhikru_linda_flutter/networks/rx_base.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'api.dart';

final class RegisterRx extends RxResponseInt<RegisterModel> {
  final api = RegisterApi.instance;

  RegisterRx({required super.empty, required super.dataFetcher});

  /// Exposed so the UI can listen to loading state via ValueListenableBuilder.
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  ValueStream get getFileData => dataFetcher.stream;

  Future<bool> registerRx({
    String ? name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    isLoading.value = true;
    try {
      final data = await api.registerApi(
        name: name,
        email: email,
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
        // 1. Check for specific field validation errors in the 'errors' object
        if (responseData.containsKey('errors')) {
          final errorMap = responseData['errors'];
          if (errorMap is Map && errorMap.isNotEmpty) {
            final firstErrorList = errorMap.values.first;
            if (firstErrorList is List && firstErrorList.isNotEmpty) {
              ToastUtil.showShortToast(firstErrorList.first.toString(), forceShow: true);
              log(error.toString());
              dataFetcher.sink.addError(error);
              return;
            }
          }
        }

        // 2. Fallback to the top-level server message
        final message = responseData['message'];
        if (message != null && message.toString().isNotEmpty) {
          ToastUtil.showShortToast(message.toString(), forceShow: true);
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
