import 'dart:convert';

class HelpAndSupportModel {
    bool? success;
    List<Datum>? data;

    HelpAndSupportModel({
        this.success,
        this.data,
    });

    HelpAndSupportModel copyWith({
        bool? success,
        List<Datum>? data,
    }) => 
        HelpAndSupportModel(
            success: success ?? this.success,
            data: data ?? this.data,
        );

    factory HelpAndSupportModel.fromRawJson(String str) => HelpAndSupportModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory HelpAndSupportModel.fromJson(Map<String, dynamic> json) => HelpAndSupportModel(
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
    String? question;
    String? answer;
    String? status;
    DateTime? createdAt;
    DateTime? updatedAt;

    Datum({
        this.id,
        this.question,
        this.answer,
        this.status,
        this.createdAt,
        this.updatedAt,
    });

    Datum copyWith({
        int? id,
        String? question,
        String? answer,
        String? status,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Datum(
            id: id ?? this.id,
            question: question ?? this.question,
            answer: answer ?? this.answer,
            status: status ?? this.status,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        question: json["question"],
        answer: json["answer"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "answer": answer,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
