import 'dart:convert';

class GetAllJournalModel {
    bool? success;
    String? message;
    List<Datum>? data;

    GetAllJournalModel({
        this.success,
        this.message,
        this.data,
    });

    GetAllJournalModel copyWith({
        bool? success,
        String? message,
        List<Datum>? data,
    }) => 
        GetAllJournalModel(
            success: success ?? this.success,
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory GetAllJournalModel.fromRawJson(String str) => GetAllJournalModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory GetAllJournalModel.fromJson(Map<String, dynamic> json) => GetAllJournalModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    int? id;
    String? title;
    String? formattedDate;
    String? moodDisplay;
    String? summary;
    List<String>? symbolTags;

    Datum({
        this.id,
        this.title,
        this.formattedDate,
        this.moodDisplay,
        this.summary,
        this.symbolTags,
    });

    Datum copyWith({
        int? id,
        String? title,
        String? formattedDate,
        String? moodDisplay,
        String? summary,
        List<String>? symbolTags,
    }) => 
        Datum(
            id: id ?? this.id,
            title: title ?? this.title,
            formattedDate: formattedDate ?? this.formattedDate,
            moodDisplay: moodDisplay ?? this.moodDisplay,
            summary: summary ?? this.summary,
            symbolTags: symbolTags ?? this.symbolTags,
        );

    factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"],
        formattedDate: json["formatted_date"],
        moodDisplay: json["mood_display"],
        summary: json["summary"],
        symbolTags: json["symbol_tags"] == null ? [] : List<String>.from(json["symbol_tags"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "formatted_date": formattedDate,
        "mood_display": moodDisplay,
        "summary": summary,
        "symbol_tags": symbolTags == null ? [] : List<dynamic>.from(symbolTags!.map((x) => x)),
    };
}
