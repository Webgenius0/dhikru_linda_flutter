import 'dart:convert';
import 'package:dhikru_linda_flutter/features/journal/model/show_journal_model.dart';
import 'package:dhikru_linda_flutter/networks/dio/dio.dart';
import 'package:dhikru_linda_flutter/networks/endpoints.dart';
import 'package:dhikru_linda_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';

final class ShowJournalApi {
  static final ShowJournalApi _singleton = ShowJournalApi._internal();
  ShowJournalApi._internal();
  static ShowJournalApi get instance => _singleton;

  Future<ShowJournalModel> showJournalApi({required int journalId}) async {
    try {
      Response response = await getHttp(Endpoints.showJournal(journalId: journalId));

      if (response.statusCode == 200) {
        final resData = ShowJournalModel.fromRawJson(json.encode(response.data));
        return resData;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
