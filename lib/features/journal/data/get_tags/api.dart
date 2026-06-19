import 'dart:convert';
import 'package:dhikru_linda_flutter/features/journal/model/tags_model.dart';
import 'package:dhikru_linda_flutter/networks/dio/dio.dart';
import 'package:dhikru_linda_flutter/networks/endpoints.dart';
import 'package:dhikru_linda_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';

final class TagsApi {
  static final TagsApi _singleton = TagsApi._internal();
  TagsApi._internal();
  static TagsApi get instance => _singleton;

  Future<TagsModel> getTagsApi() async {
    try {
      Response response = await getHttp(Endpoints.tags());

      if (response.statusCode == 200) {
        final resData = TagsModel.fromRawJson(json.encode(response.data));
        return resData;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
