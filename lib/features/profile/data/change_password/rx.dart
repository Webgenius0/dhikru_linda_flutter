import 'package:dhikru_linda_flutter/features/profile/model/change_password_model.dart';
import 'package:dhikru_linda_flutter/helpers/toast.dart';
import 'package:dhikru_linda_flutter/networks/rx_base.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'api.dart';

final class ChangePasswordRx extends RxResponseInt<ChangePasswordModel> {
  final api = ChangePasswordApi.instance;

  ChangePasswordRx({required super.empty, required super.dataFetcher});

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  ValueStream<ChangePasswordModel> get getChangePasswordData => dataFetcher.stream;

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    isLoading.value = true;
    try {
      final data = await api.changePasswordApi(
        oldPassword: oldPassword,
        newPassword: newPassword,
        newPasswordConfirmation: newPasswordConfirmation,
      );

      handleSuccessWithReturn(data);
      ToastUtil.showShortToast(data.message ?? "Password changed successfully.", forceShow: true);
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
        final message = responseData['message'];
        if (message != null) {
          if (message is Map && message.isNotEmpty) {
            final firstVal = message.values.first;
            if (firstVal is List && firstVal.isNotEmpty) {
              ToastUtil.showShortToast(firstVal.first.toString(), forceShow: true);
              dataFetcher.sink.addError(error);
              return false;
            } else {
              ToastUtil.showShortToast(firstVal.toString(), forceShow: true);
              dataFetcher.sink.addError(error);
              return false;
            }
          } else if (message.toString().isNotEmpty) {
            ToastUtil.showShortToast(message.toString(), forceShow: true);
            dataFetcher.sink.addError(error);
            return false;
          }
        }
      }
    }
    ToastUtil.showShortToast("Failed to change password. Please try again.", forceShow: true);
    dataFetcher.sink.addError(error);
    return false;
  }
}
