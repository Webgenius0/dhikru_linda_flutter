import 'package:dhikru_linda_flutter/features/journal/model/new_journal_entry_model.dart';
import 'package:dhikru_linda_flutter/helpers/all_routes.dart';
import 'package:dhikru_linda_flutter/helpers/navigation_service.dart';
import 'package:dhikru_linda_flutter/helpers/toast.dart';
import 'package:dhikru_linda_flutter/networks/rx_base.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'api.dart';

final class NewJournalEntryRx extends RxResponseInt<NewJournalEntryModel> {
  final api = NewJournalEntryApi.instance;

  NewJournalEntryRx({required super.empty, required super.dataFetcher});

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  ValueStream<NewJournalEntryModel> get getNewJournalEntryStream => dataFetcher.stream;

  Future<bool> addNewJournalEntry({
    required String title,
    String? content,
    String? contentVoice,
    List<int>? tagIds,
  }) async {
    isLoading.value = true;
    try {
      final data = await api.addJournalEntryApi(
        title: title,
        content: content,
        contentVoice: contentVoice,
        tagIds: tagIds,
      );
      handleSuccessWithReturn(data);
      ToastUtil.showShortToast(data.message ?? "Dream logged successfully!");
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
      if (error.response?.statusCode == 403) {
        final resData = error.response?.data;
        if (resData is Map<String, dynamic> && resData['message'] != null) {
          ToastUtil.showShortToast(resData['message'].toString(), forceShow: true);
        }
        NavigationService.navigateTo(Routes.subscriptionScreen);
        dataFetcher.sink.addError(error);
        return false;
      }

      final responseData = error.response?.data;
      if (responseData is Map<String, dynamic>) {
        final message = responseData['message'];
        final errors = responseData['errors'];
        final code = responseData['code'];

        if (code == 403 ||
            (message != null &&
                (message.toString().toLowerCase().contains('premium') ||
                    message.toString().toLowerCase().contains('upgrade')))) {
          if (message != null && message.toString().isNotEmpty) {
            ToastUtil.showShortToast(message.toString(), forceShow: true);
          }
          NavigationService.navigateTo(Routes.subscriptionScreen);
          dataFetcher.sink.addError(error);
          return false;
        }

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
            ToastUtil.showShortToast(allErrors.join("\n"));
            dataFetcher.sink.addError(error);
            return false;
          }
        }

        if (message != null && message.toString().isNotEmpty) {
          ToastUtil.showShortToast(message.toString());
          dataFetcher.sink.addError(error);
          return false;
        }
      }
    }
    ToastUtil.showShortToast("Failed to save journal entry. Please try again.");
    dataFetcher.sink.addError(error);
    return false;
  }
}
