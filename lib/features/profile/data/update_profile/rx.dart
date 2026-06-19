import 'dart:io';
import 'package:dhikru_linda_flutter/features/home/model/update_profile_model.dart';
import 'package:dhikru_linda_flutter/helpers/toast.dart';
import 'package:dhikru_linda_flutter/networks/rx_base.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'api.dart';

final class UpdateProfileRx extends RxResponseInt<UpdateProfileModel> {
  final api = UpdateProfileApi.instance;

  UpdateProfileRx({required super.empty, required super.dataFetcher});

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  ValueStream<UpdateProfileModel> get getUpdateProfileData => dataFetcher.stream;

  Future<bool> updateProfile({
    String? name,
    String? maritalStatus,
    int? age,
    String? gender,
    File? avatar,
  }) async {
    isLoading.value = true;
    try {
      final data = await api.updateProfileApi(
        name: name,
        maritalStatus: maritalStatus,
        age: age,
        gender: gender,
        avatar: avatar,
      );

      handleSuccessWithReturn(data);
      ToastUtil.showShortToast(data.message ?? "Profile updated successfully.");
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
        if (message != null && message.toString().isNotEmpty) {
          ToastUtil.showShortToast(message.toString());
          dataFetcher.sink.addError(error);
          return false;
        }
      }
    }
    ToastUtil.showShortToast("Failed to update profile. Please try again.");
    dataFetcher.sink.addError(error);
    return false;
  }
}
