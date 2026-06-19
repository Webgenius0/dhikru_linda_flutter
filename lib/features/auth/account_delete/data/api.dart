import 'dart:convert';
import 'package:dhikru_linda_flutter/features/auth/account_delete/data/rx.dart';
import 'package:dhikru_linda_flutter/networks/dio/dio.dart';
import 'package:dhikru_linda_flutter/networks/endpoints.dart';
import 'package:dhikru_linda_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';

final class DeleteAccountApi {
  static final DeleteAccountApi _singleton = DeleteAccountApi._internal();
  DeleteAccountApi._internal();
  static DeleteAccountApi get instance => _singleton;

  Future<DeleteAccountModel> deleteAccountApi() async {
    try {
      Response response = await deleteHttp(Endpoints.deleteAccount());

      if (response.statusCode == 200) {
        final data = DeleteAccountModel.fromRawJson(json.encode(response.data));
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
