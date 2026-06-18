import 'dart:convert';

class ResendOtpModel {
  bool? success;
  String? message;
  List<dynamic>? data;
  int? code;

  ResendOtpModel({
    this.success,
    this.message,
    this.data,
    this.code,
  });

  factory ResendOtpModel.fromRawJson(String str) => ResendOtpModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ResendOtpModel.fromJson(Map<String, dynamic> json) => ResendOtpModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : List<dynamic>.from(json["data"].map((x) => x)),
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null ? null : List<dynamic>.from(data!.map((x) => x)),
    "code": code,
  };
}
