import 'dart:convert';

class ChangePasswordModel {
    bool? success;
    String? message;
    List<dynamic>? data;
    int? code;

    ChangePasswordModel({
        this.success,
        this.message,
        this.data,
        this.code,
    });

    ChangePasswordModel copyWith({
        bool? success,
        String? message,
        List<dynamic>? data,
        int? code,
    }) => 
        ChangePasswordModel(
            success: success ?? this.success,
            message: message ?? this.message,
            data: data ?? this.data,
            code: code ?? this.code,
        );

    factory ChangePasswordModel.fromRawJson(String str) => ChangePasswordModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ChangePasswordModel.fromJson(Map<String, dynamic> json) => ChangePasswordModel(
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
