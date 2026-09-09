import 'package:dhikru_linda_flutter/features/journal/model/send_journal_message_model.dart';
import 'package:dhikru_linda_flutter/helpers/toast.dart';
import 'package:dhikru_linda_flutter/networks/rx_base.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'api.dart';

final class SendJournalMessageRx
    extends RxResponseInt<SendJournalMessageModel> {
  final api = SendJournalMessageApi.instance;

  SendJournalMessageRx({required super.empty, required super.dataFetcher});

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  ValueStream<SendJournalMessageModel> get getSendJournalMessageStream =>
      dataFetcher.stream;

  Future<SendJournalMessageModel?> sendMessage({
    required int journalId,
    required String message,
  }) async {
    isLoading.value = true;
    try {
      final data = await api.sendMessageApi(
        journalId: journalId,
        message: message,
      );
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
    debugPrint("=== sendJournalMessage error: $error");
    if (error is DioException) {
      debugPrint(
        "=== sendJournalMessage response status: ${error.response?.statusCode}",
      );
      debugPrint(
        "=== sendJournalMessage response data: ${error.response?.data}",
      );
      final responseData = error.response?.data;
      if (responseData is Map<String, dynamic>) {
        final message = responseData['message'];
        final errors = responseData['errors'];

        if (errors is Map<String, dynamic>) {
          List<String> allErrors = [];
          errors.forEach((key, value) {
            if (value is List) {
              allErrors.addAll(value.map((e) => e.toString()));
            } else {
              allErrors.add(value.toString());
            }
          });
          if (allErrors.isNotEmpty) {
            ToastUtil.showShortToast(allErrors.join("\n"), forceShow: true);
            dataFetcher.sink.addError(error);
            return false;
          }
        }

        if (message != null && message.toString().isNotEmpty) {
          ToastUtil.showShortToast(message.toString(), forceShow: true);
          dataFetcher.sink.addError(error);
          return false;
        }
      }
    }
    ToastUtil.showShortToast(
      "Failed to send message. Please try again.",
      forceShow: true,
    );
    dataFetcher.sink.addError(error);
    return false;
  }
}
