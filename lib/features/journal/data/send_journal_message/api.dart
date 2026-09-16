import 'dart:convert';
import 'package:dhikru_linda_flutter/features/journal/model/send_journal_message_model.dart';
import 'package:dhikru_linda_flutter/networks/dio/dio.dart';
import 'package:dhikru_linda_flutter/networks/endpoints.dart';
import 'package:dhikru_linda_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

final class SendJournalMessageApi {
  static final SendJournalMessageApi _singleton =
      SendJournalMessageApi._internal();
  SendJournalMessageApi._internal();
  static SendJournalMessageApi get instance => _singleton;

  Future<SendJournalMessageModel> sendMessageApi({
    required int journalId,
    required String message,
  }) async {
    try {
      Map<String, dynamic> data = {
        "message": message,
      };

      debugPrint("=== SEND MESSAGE API URL: ${Endpoints.sendJournalMessage(journalId: journalId)}");
      debugPrint("=== SEND MESSAGE API REQUEST BODY: $data");

      Response response = await postHttp(
        Endpoints.sendJournalMessage(journalId: journalId),
        data,
      );

      debugPrint("=== SEND MESSAGE API RESPONSE STATUS: ${response.statusCode}");
      debugPrint("=== SEND MESSAGE API RESPONSE BODY: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = response.data is Map<String, dynamic>
            ? SendJournalMessageModel.fromJson(response.data)
            : SendJournalMessageModel.fromRawJson(json.encode(response.data));
        return resData;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
