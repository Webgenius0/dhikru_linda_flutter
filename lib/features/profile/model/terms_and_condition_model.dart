import 'dart:convert';

class TermsAndConditionModel {
    bool? success;
    Data? data;

    TermsAndConditionModel({
        this.success,
        this.data,
    });

    TermsAndConditionModel copyWith({
        bool? success,
        Data? data,
    }) => 
        TermsAndConditionModel(
            success: success ?? this.success,
            data: data ?? this.data,
        );

    factory TermsAndConditionModel.fromRawJson(String str) => TermsAndConditionModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory TermsAndConditionModel.fromJson(Map<String, dynamic> json) => TermsAndConditionModel(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
    };
}

class Data {
    int? id;
    String? page;
    String? title;
    String? content;
    DateTime? createdAt;
    DateTime? updatedAt;

    Data({
        this.id,
        this.page,
        this.title,
        this.content,
        this.createdAt,
        this.updatedAt,
    });

    Data copyWith({
        int? id,
        String? page,
        String? title,
        String? content,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Data(
            id: id ?? this.id,
            page: page ?? this.page,
            title: title ?? this.title,
            content: content ?? this.content,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        page: json["page"],
        title: json["title"],
        content: json["content"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "page": page,
        "title": title,
        "content": content,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
