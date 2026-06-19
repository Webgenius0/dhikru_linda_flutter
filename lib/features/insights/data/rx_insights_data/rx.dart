import 'package:dhikru_linda_flutter/features/insights/model/insight_data_model.dart';
import 'package:dhikru_linda_flutter/helpers/toast.dart';
import 'package:dhikru_linda_flutter/networks/rx_base.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'api.dart';

final class InsightsDataRx extends RxResponseInt<InsightsDataModel> {
  final api = InsightsDataApi.instance;

  InsightsDataRx({required super.empty, required super.dataFetcher});

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  ValueStream<InsightsDataModel> get getInsightsDataStream => dataFetcher.stream;

  Future<void> getInsightsData() async {
    isLoading.value = true;
    try {
      final data = await api.getInsightsDataApi();
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
    ToastUtil.showShortToast("Failed to load insights data. Please try again.");
    dataFetcher.sink.addError(error);
    return false;
  }
}
