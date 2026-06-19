import 'dart:convert';

class TagsModel {
    bool? success;
    List<Datum>? data;

    TagsModel({
        this.success,
        this.data,
    });

    TagsModel copyWith({
        bool? success,
        List<Datum>? data,
    }) => 
        TagsModel(
            success: success ?? this.success,
            data: data ?? this.data,
        );

    factory TagsModel.fromRawJson(String str) => TagsModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory TagsModel.fromJson(Map<String, dynamic> json) => TagsModel(
        success: json["success"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    int? id;
    String? name;
    int? status;
    DateTime? createdAt;
    DateTime? updatedAt;

    Datum({
        this.id,
        this.name,
        this.status,
        this.createdAt,
        this.updatedAt,
    });

    Datum copyWith({
        int? id,
        String? name,
        int? status,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Datum(
            id: id ?? this.id,
            name: name ?? this.name,
            status: status ?? this.status,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
