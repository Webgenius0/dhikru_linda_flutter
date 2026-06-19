import 'dart:convert';
import 'package:dhikru_linda_flutter/features/journal/model/get_all_journal_model.dart';
import 'package:dhikru_linda_flutter/networks/dio/dio.dart';
import 'package:dhikru_linda_flutter/networks/endpoints.dart';
import 'package:dhikru_linda_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';

final class GetAllJournalApi {
  static final GetAllJournalApi _singleton = GetAllJournalApi._internal();
  GetAllJournalApi._internal();
  static GetAllJournalApi get instance => _singleton;

  Future<GetAllJournalModel> getAllJournalApi({int? tagId}) async {
    try {
      Response response = await getHttp(Endpoints.getAllJournal(tagId: tagId));

      if (response.statusCode == 200) {
        final resData = GetAllJournalModel.fromRawJson(json.encode(response.data));
        return resData;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
