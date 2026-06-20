import 'dart:convert';
import 'package:dhikru_linda_flutter/features/journal/model/save_journal_response_model.dart';
import 'package:dhikru_linda_flutter/networks/dio/dio.dart';
import 'package:dhikru_linda_flutter/networks/endpoints.dart';
import 'package:dhikru_linda_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';

final class SaveJournalResponseApi {
  static final SaveJournalResponseApi _singleton = SaveJournalResponseApi._internal();
  SaveJournalResponseApi._internal();
  static SaveJournalResponseApi get instance => _singleton;

  Future<SaveJournalResponseModel> saveJournalResponseApi({
    required int journalId,
    required String userResponse,
  }) async {
    try {
      Map<String, dynamic> data = {
        "user_response": userResponse,
      };

      Response response = await postHttp(Endpoints.journalEntryResponse(journalId: journalId), data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = SaveJournalResponseModel.fromRawJson(json.encode(response.data));
        return resData;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
