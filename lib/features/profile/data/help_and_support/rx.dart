import 'package:dhikru_linda_flutter/features/profile/model/help_and_support_model.dart';
import 'package:dhikru_linda_flutter/helpers/toast.dart';
import 'package:dhikru_linda_flutter/networks/rx_base.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'api.dart';

final class HelpAndSupportRx extends RxResponseInt<HelpAndSupportModel> {
  final api = HelpAndSupportApi.instance;

  HelpAndSupportRx({required super.empty, required super.dataFetcher});

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  ValueStream<HelpAndSupportModel> get getHelpAndSupportData => dataFetcher.stream;

  Future<void> getHelpAndSupport() async {
    isLoading.value = true;
    try {
      final data = await api.getHelpAndSupportApi();
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
    ToastUtil.showShortToast("Failed to load help & support. Please try again.");
    dataFetcher.sink.addError(error);
    return false;
  }
}
