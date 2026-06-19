import 'dart:convert';

class SetForgetPasswordModel {
    bool? success;
    String? message;
    List<dynamic>? data;
    int? code;

    SetForgetPasswordModel({
        this.success,
        this.message,
        this.data,
        this.code,
    });

    SetForgetPasswordModel copyWith({
        bool? success,
        String? message,
        List<dynamic>? data,
        int? code,
    }) => 
        SetForgetPasswordModel(
            success: success ?? this.success,
            message: message ?? this.message,
            data: data ?? this.data,
            code: code ?? this.code,
        );

    factory SetForgetPasswordModel.fromRawJson(String str) => SetForgetPasswordModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory SetForgetPasswordModel.fromJson(Map<String, dynamic> json) => SetForgetPasswordModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? [] : List<dynamic>.from(json["data"]!.map((x) => x)),
        code: json["code"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
        "code": code,
    };
}
