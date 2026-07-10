import 'dart:convert';
import 'package:dhikru_linda_flutter/helpers/di.dart';
import 'package:dhikru_linda_flutter/constants/app_constants.dart';
import 'package:dhikru_linda_flutter/helpers/toast.dart';
import 'package:dhikru_linda_flutter/networks/rx_base.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'api.dart';

final class DeleteAccountRx extends RxResponseInt<DeleteAccountModel> {
  final api = DeleteAccountApi.instance;

  DeleteAccountRx({required super.empty, required super.dataFetcher});

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  ValueStream get getFileData => dataFetcher.stream;

  Future<bool> deleteAccount() async {
    isLoading.value = true;
    try {
      DeleteAccountModel data = await api.deleteAccountApi();
      handleSuccessWithReturn(data);

      ToastUtil.showShortToast(data.message ?? "Account deleted successfully.", forceShow: true);

      await appData.write(kKeyIsLoggedIn, false);
      await appData.remove(kKeyAccessToken);
      await appData.remove(kKeyName);
      await appData.remove(kKeyEmail);

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
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        ToastUtil.showShortToast(
          "Network error. Please check your connection.",
          forceShow: true,
        );
        return false;
      }

      if (error.response != null) {
        final message = error.response!.data["message"];
        if (message is String) {
          ToastUtil.showShortToast(message, forceShow: true);
          return false;
        }

        if (message is Map) {
          final errorMessage =
              message.values.whereType<List>().map((e) => e.first).join("\n");
          ToastUtil.showShortToast(errorMessage, forceShow: true);
          return false;
        }

        // Handle specific HTTP status codes
        switch (error.response!.statusCode) {
          case 400:
            ToastUtil.showShortToast(
              "Invalid request. Please try again.",
              forceShow: true,
            );
            break;
          case 401:
            ToastUtil.showShortToast(
              "Unauthorized. Please log in again.",
              forceShow: true,
            );
            break;
          default:
            ToastUtil.showShortToast("Server error. Please try again later.", forceShow: true);
        }
        return false;
      }
    }

    final defaultMessage = "An unexpected error occurred. Please try again.";
    ToastUtil.showShortToast(defaultMessage, forceShow: true);
    return false;
  }
}

class DeleteAccountModel {
  bool? success;
  String? message;
  List<dynamic>? data;
  int? code;

  DeleteAccountModel({
    this.success,
    this.message,
    this.data,
    this.code,
  });

  DeleteAccountModel copyWith({
    bool? success,
    String? message,
    List<dynamic>? data,
    int? code,
  }) =>
      DeleteAccountModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
        code: code ?? this.code,
      );

  factory DeleteAccountModel.fromRawJson(String str) => DeleteAccountModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DeleteAccountModel.fromJson(Map<String, dynamic> json) => DeleteAccountModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? [] : List<dynamic>.from(json["data"]!.map((x) => x)),
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
        "code": code,
      };
}
