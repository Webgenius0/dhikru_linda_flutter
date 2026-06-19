import 'dart:convert';

class UpdateProfileModel {
    bool? success;
    String? message;
    Data? data;
    int? code;

    UpdateProfileModel({
        this.success,
        this.message,
        this.data,
        this.code,
    });

    UpdateProfileModel copyWith({
        bool? success,
        String? message,
        Data? data,
        int? code,
    }) => 
        UpdateProfileModel(
            success: success ?? this.success,
            message: message ?? this.message,
            data: data ?? this.data,
            code: code ?? this.code,
        );

    factory UpdateProfileModel.fromRawJson(String str) => UpdateProfileModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory UpdateProfileModel.fromJson(Map<String, dynamic> json) => UpdateProfileModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        code: json["code"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
        "code": code,
    };
}

class Data {
    int? id;
    String? name;
    String? email;
    String? avatar;
    String? gender;
    String? maritalStatus;
    String? age;

    Data({
        this.id,
        this.name,
        this.email,
        this.avatar,
        this.gender,
        this.maritalStatus,
        this.age,
    });

    Data copyWith({
        int? id,
        String? name,
        String? email,
        String? avatar,
        String? gender,
        String? maritalStatus,
        String? age,
    }) => 
        Data(
            id: id ?? this.id,
            name: name ?? this.name,
            email: email ?? this.email,
            avatar: avatar ?? this.avatar,
            gender: gender ?? this.gender,
            maritalStatus: maritalStatus ?? this.maritalStatus,
            age: age ?? this.age,
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        avatar: json["avatar"],
        gender: json["gender"],
        maritalStatus: json["marital_status"],
        age: json["age"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "avatar": avatar,
        "gender": gender,
        "marital_status": maritalStatus,
        "age": age,
    };
}
