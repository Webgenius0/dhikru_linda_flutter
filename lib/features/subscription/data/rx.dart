import 'package:dhikru_linda_flutter/features/subscription/model/get_subscrition/get_subscription_model.dart';
import 'package:dhikru_linda_flutter/helpers/toast.dart';
import 'package:dhikru_linda_flutter/networks/rx_base.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'api.dart';

final class GetSubscriptionRx extends RxResponseInt<GetSubscriptionModel> {
  final api = GetSubscriptionApi.instance;

  GetSubscriptionRx({required super.empty, required super.dataFetcher});

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  ValueStream<GetSubscriptionModel> get getSubscriptionStream =>
      dataFetcher.stream;

  Future<GetSubscriptionModel?> getSubscriptionStatus() async {
    isLoading.value = true;
    try {
      final data = await api.getSubscriptionStatusApi();
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
        final message = responseData['message'];
        if (message != null && message.toString().isNotEmpty) {
          ToastUtil.showShortToast(message.toString());
          dataFetcher.sink.addError(error);
          return false;
        }
      }
    }
    ToastUtil.showShortToast(
      "Failed to load subscription details. Please try again.",
    );
    dataFetcher.sink.addError(error);
    return false;
  }
}
