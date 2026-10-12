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
  final ValueNotifier<bool> isPremiumLocked = ValueNotifier(false);
  final ValueNotifier<String?> lockMessage = ValueNotifier(null);

  ValueStream<InsightsDataModel> get getInsightsDataStream => dataFetcher.stream;

  Future<void> getInsightsData() async {
    isLoading.value = true;
    try {
      final data = await api.getInsightsDataApi();
      isPremiumLocked.value = false;
      lockMessage.value = null;
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
      final statusCode = error.response?.statusCode;
      final responseData = error.response?.data;
      String? message;
      if (responseData is Map<String, dynamic>) {
        final rawMsg = responseData['message'];
        if (rawMsg != null && rawMsg.toString().isNotEmpty) {
          message = rawMsg.toString();
        }
      }

      // 403 Forbidden indicates a premium paywall, not an application crash or failure
      if (statusCode == 403) {
        isPremiumLocked.value = true;
        lockMessage.value = message ??
            "Insights and pattern analysis are premium features. Please upgrade to unlock.";
        dataFetcher.sink.addError(error);
        return false;
      }

      if (message != null && message.isNotEmpty) {
        ToastUtil.showShortToast(message);
        dataFetcher.sink.addError(error);
        return false;
      }
    }
    ToastUtil.showShortToast("Failed to load insights data. Please try again.");
    dataFetcher.sink.addError(error);
    return false;
  }
}
