import 'package:dhikru_linda_flutter/features/journal/model/show_journal_model.dart';
import 'package:dhikru_linda_flutter/helpers/toast.dart';
import 'package:dhikru_linda_flutter/networks/rx_base.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'api.dart';

final class ShowJournalRx extends RxResponseInt<ShowJournalModel> {
  final api = ShowJournalApi.instance;

  ShowJournalRx({required super.empty, required super.dataFetcher});

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  ValueStream<ShowJournalModel> get getShowJournalStream => dataFetcher.stream;

  Future<void> showJournalDetails({required int journalId}) async {
    isLoading.value = true;
    try {
      final data = await api.showJournalApi(journalId: journalId);
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
    ToastUtil.showShortToast("Failed to load journal details. Please try again.");
    dataFetcher.sink.addError(error);
    return false;
  }
}
