import 'dart:convert';
import 'dart:io';
import 'package:dhikru_linda_flutter/features/home/model/update_profile_model.dart';
import 'package:dhikru_linda_flutter/networks/dio/dio.dart';
import 'package:dhikru_linda_flutter/networks/endpoints.dart';
import 'package:dhikru_linda_flutter/networks/exception_handler/data_source.dart';
import 'package:dio/dio.dart';

final class UpdateProfileApi {
  static final UpdateProfileApi _singleton = UpdateProfileApi._internal();
  UpdateProfileApi._internal();
  static UpdateProfileApi get instance => _singleton;

  Future<UpdateProfileModel> updateProfileApi({
    String? name,
    String? maritalStatus,
    int? age,
    String? gender,
    File? avatar,
  }) async {
    try {
      Map<String, dynamic> formDataMap = {};
      if (name != null) formDataMap["name"] = name;
      if (maritalStatus != null) formDataMap["marital_status"] = maritalStatus;
      if (age != null) formDataMap["age"] = age.toString();
      if (gender != null) formDataMap["gender"] = gender;
      if (avatar != null) {
        formDataMap["avatar"] = await MultipartFile.fromFile(
          avatar.path,
          filename: avatar.path.split('/').last,
        );
      }

      FormData data = FormData.fromMap(formDataMap);

      Response response = await postHttp(Endpoints.updateProfile(), data);

      if (response.statusCode == 200) {
        final resData = UpdateProfileModel.fromRawJson(json.encode(response.data));
        return resData;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
