import 'dart:developer';
import 'package:dhikru_linda_flutter/features/auth/login/model/login_model.dart';
import 'package:dhikru_linda_flutter/helpers/toast.dart';
import 'package:dhikru_linda_flutter/networks/rx_base.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'api.dart';

final class AppleSignInRx extends RxResponseInt<LoginModel> {
  final api = AppleSignInApi.instance;

  AppleSignInRx({required super.empty, required super.dataFetcher});

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  ValueStream get getFileData => dataFetcher.stream;

  Future<LoginModel?> appleSignInRx({
    required String accessToken,
  }) async {
    isLoading.value = true;
    try {
      final data = await api.appleLoginApi(accessToken: accessToken);
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

        if (responseData.containsKey('data') &&
            responseData['data'] is Map<String, dynamic>) {
          final dataMap = responseData['data'];

          if (dataMap.containsKey('errors')) {
            final errorMap = dataMap['errors'];
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

          if (dataMap.containsKey('error')) {
            final errorMsg = dataMap['error'];
            if (errorMsg is String && errorMsg.isNotEmpty) {
              ToastUtil.showShortToast(errorMsg, forceShow: true);
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
