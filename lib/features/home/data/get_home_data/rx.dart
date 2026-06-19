import 'package:dhikru_linda_flutter/features/home/model/home_data_model.dart';
import 'package:dhikru_linda_flutter/helpers/toast.dart';
import 'package:dhikru_linda_flutter/networks/rx_base.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'api.dart';

final class HomeDataRx extends RxResponseInt<HomeDataModel> {
  final api = HomeDataApi.instance;

  HomeDataRx({required super.empty, required super.dataFetcher});

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  ValueStream<HomeDataModel> get getHomeDataStream => dataFetcher.stream;

  Future<void> getHomeData() async {
    isLoading.value = true;
    try {
      final data = await api.getHomeDataApi();
      handleSuccessWithReturn(data);
    } catch (error) {
      handleErrorWithReturn(error);
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
    ToastUtil.showShortToast("Failed to load dashboard data. Please try again.");
    dataFetcher.sink.addError(error);
    return false;
  }
}
