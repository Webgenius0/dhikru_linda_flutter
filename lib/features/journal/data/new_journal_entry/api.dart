import 'dart:convert';
import 'package:dhikru_linda_flutter/features/journal/model/new_journal_entry_model.dart';
import 'package:dhikru_linda_flutter/networks/dio/dio.dart';
import 'package:dhikru_linda_flutter/networks/endpoints.dart';
import 'package:dhikru_linda_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';

final class NewJournalEntryApi {
  static final NewJournalEntryApi _singleton = NewJournalEntryApi._internal();
  NewJournalEntryApi._internal();
  static NewJournalEntryApi get instance => _singleton;

  Future<NewJournalEntryModel> addJournalEntryApi({
    required String title,
    String? content,
    String? contentVoice,
    List<int>? tagIds,
  }) async {
    try {
      Map<String, dynamic> formDataMap = {
        "title": title,
      };

      if (content != null && content.isNotEmpty) {
        formDataMap["content"] = content;
      }
      if (contentVoice != null && contentVoice.isNotEmpty) {
        formDataMap["content_voice"] = contentVoice;
      }

      if (tagIds != null && tagIds.isNotEmpty) {
        for (int i = 0; i < tagIds.length; i++) {
          formDataMap["tag_ids[$i]"] = tagIds[i];
        }
      }

      FormData data = FormData.fromMap(formDataMap);

      Response response = await postHttp(Endpoints.journalEntry(), data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = NewJournalEntryModel.fromRawJson(json.encode(response.data));
        return resData;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
