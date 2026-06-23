import 'dart:convert';

class ForgotPasswordVerifyOtpModel {
  bool? success;
  String? message;
  ForgotPasswordVerifyOtpData? data;
  int? code;

  ForgotPasswordVerifyOtpModel({
    this.success,
    this.message,
    this.data,
    this.code,
  });

  ForgotPasswordVerifyOtpModel copyWith({
    bool? success,
    String? message,
    ForgotPasswordVerifyOtpData? data,
    int? code,
  }) =>
      ForgotPasswordVerifyOtpModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
        code: code ?? this.code,
      );

  factory ForgotPasswordVerifyOtpModel.fromRawJson(String str) =>
      ForgotPasswordVerifyOtpModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ForgotPasswordVerifyOtpModel.fromJson(Map<String, dynamic> json) {
    dynamic rawData = json["data"];
    ForgotPasswordVerifyOtpData? parsedData;
    if (rawData != null) {
      if (rawData is Map<String, dynamic>) {
        parsedData = ForgotPasswordVerifyOtpData.fromJson(rawData);
      } else if (rawData is String) {
        parsedData = ForgotPasswordVerifyOtpData(resetToken: rawData, token: rawData);
      }
    }
    return ForgotPasswordVerifyOtpModel(
      success: json["success"],
      message: json["message"],
      data: parsedData,
      code: json["code"],
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
        "code": code,
      };
}

class ForgotPasswordVerifyOtpData {
  String? token;
  String? resetToken;

  ForgotPasswordVerifyOtpData({
    this.token,
    this.resetToken,
  });

  ForgotPasswordVerifyOtpData copyWith({
    String? token,
    String? resetToken,
  }) =>
      ForgotPasswordVerifyOtpData(
        token: token ?? this.token,
        resetToken: resetToken ?? this.resetToken,
      );

  factory ForgotPasswordVerifyOtpData.fromRawJson(String str) =>
      ForgotPasswordVerifyOtpData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ForgotPasswordVerifyOtpData.fromJson(Map<String, dynamic> json) =>
      ForgotPasswordVerifyOtpData(
        token: json["token"],
        resetToken: json["reset_token"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "reset_token": resetToken,
      };
}
