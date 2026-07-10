// ignore_for_file: use_build_context_synchronously
import 'dart:developer';
import 'package:dhikru_linda_flutter/features/auth/register/model/register_verify_otp_model.dart';
import 'package:dhikru_linda_flutter/helpers/toast.dart';
import 'package:dhikru_linda_flutter/networks/rx_base.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'api.dart';

final class RegisterVerifyOtpRx extends RxResponseInt<RegisterVerifyOtpModel> {
  final api = RegisterVerifyOtpApi.instance;

  RegisterVerifyOtpRx({required super.empty, required super.dataFetcher});

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  ValueStream get getFileData => dataFetcher.stream;

  Future<bool> registerVerifyOtpRx({
    required String email,
    required String otp,
  }) async {
    isLoading.value = true;
    try {
      final data = await api.registerVerifyOtpApi(
        email: email,
        otp: otp,
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
