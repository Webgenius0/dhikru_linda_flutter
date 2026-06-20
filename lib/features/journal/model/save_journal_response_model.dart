import 'dart:convert';

class SaveJournalResponseModel {
    bool? success;
    String? message;
    dynamic data;
    int? code;

    SaveJournalResponseModel({
        this.success,
        this.message,
        this.data,
        this.code,
    });

    factory SaveJournalResponseModel.fromRawJson(String str) => SaveJournalResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory SaveJournalResponseModel.fromJson(Map<String, dynamic> json) => SaveJournalResponseModel(
        success: json["success"],
        message: json["message"],
        data: json["data"],
        code: json["code"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data,
        "code": code,
    };
}
