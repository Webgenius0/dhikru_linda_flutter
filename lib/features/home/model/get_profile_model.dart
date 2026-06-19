import 'dart:convert';

class GetProfileModel {
    bool? success;
    String? message;
    Data? data;
    int? code;

    GetProfileModel({
        this.success,
        this.message,
        this.data,
        this.code,
    });

    GetProfileModel copyWith({
        bool? success,
        String? message,
        Data? data,
        int? code,
    }) => 
        GetProfileModel(
            success: success ?? this.success,
            message: message ?? this.message,
            data: data ?? this.data,
            code: code ?? this.code,
        );

    factory GetProfileModel.fromRawJson(String str) => GetProfileModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory GetProfileModel.fromJson(Map<String, dynamic> json) => GetProfileModel(
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
    User? user;

    Data({
        this.user,
    });

    Data copyWith({
        User? user,
    }) => 
        Data(
            user: user ?? this.user,
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
    };
}

class User {
    int? id;
    String? avatar;
    String? name;
    String? email;
    dynamic age;
    dynamic maritalStatus;
    dynamic gender;
    String? role;
    String? status;
    bool? termsAndConditions;
    DateTime? createdAt;
    DateTime? updatedAt;

    User({
        this.id,
        this.avatar,
        this.name,
        this.email,
        this.age,
        this.maritalStatus,
        this.gender,
        this.role,
        this.status,
        this.termsAndConditions,
        this.createdAt,
        this.updatedAt,
    });

    User copyWith({
        int? id,
        String? avatar,
        String? name,
        String? email,
        dynamic age,
        dynamic maritalStatus,
        dynamic gender,
        String? role,
        String? status,
        bool? termsAndConditions,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        User(
            id: id ?? this.id,
            avatar: avatar ?? this.avatar,
            name: name ?? this.name,
            email: email ?? this.email,
            age: age ?? this.age,
            maritalStatus: maritalStatus ?? this.maritalStatus,
            gender: gender ?? this.gender,
            role: role ?? this.role,
            status: status ?? this.status,
            termsAndConditions: termsAndConditions ?? this.termsAndConditions,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        avatar: json["avatar"],
        name: json["name"],
        email: json["email"],
        age: json["age"],
        maritalStatus: json["marital_status"],
        gender: json["gender"],
        role: json["role"],
        status: json["status"],
        termsAndConditions: json["terms_and_conditions"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "avatar": avatar,
        "name": name,
        "email": email,
        "age": age,
        "marital_status": maritalStatus,
        "gender": gender,
        "role": role,
        "status": status,
        "terms_and_conditions": termsAndConditions,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
