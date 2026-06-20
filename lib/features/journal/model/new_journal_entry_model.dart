import 'dart:convert';

class NewJournalEntryModel {
    bool? success;
    String? message;
    Data? data;

    NewJournalEntryModel({
        this.success,
        this.message,
        this.data,
    });

    NewJournalEntryModel copyWith({
        bool? success,
        String? message,
        Data? data,
    }) => 
        NewJournalEntryModel(
            success: success ?? this.success,
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory NewJournalEntryModel.fromRawJson(String str) => NewJournalEntryModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory NewJournalEntryModel.fromJson(Map<String, dynamic> json) => NewJournalEntryModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    int? id;
    String? title;
    String? content;
    dynamic contentVoice;
    String? formattedDate;
    String? moodDisplay;
    String? summary;
    String? meaning;
    String? userResponse;
    String? mood;
    int? moodScore;
    List<String>? symbolTags;
    List<EmotionalLandscape>? emotionalLandscape;
    List<CareReflection>? careReflection;
    DateTime? createdAt;

    Data({
        this.id,
        this.title,
        this.content,
        this.contentVoice,
        this.formattedDate,
        this.moodDisplay,
        this.summary,
        this.meaning,
        this.userResponse,
        this.mood,
        this.moodScore,
        this.symbolTags,
        this.emotionalLandscape,
        this.careReflection,
        this.createdAt,
    });

    Data copyWith({
        int? id,
        String? title,
        String? content,
        dynamic contentVoice,
        String? formattedDate,
        String? moodDisplay,
        String? summary,
        String? meaning,
        String? userResponse,
        String? mood,
        int? moodScore,
        List<String>? symbolTags,
        List<EmotionalLandscape>? emotionalLandscape,
        List<CareReflection>? careReflection,
        DateTime? createdAt,
    }) => 
        Data(
            id: id ?? this.id,
            title: title ?? this.title,
            content: content ?? this.content,
            contentVoice: contentVoice ?? this.contentVoice,
            formattedDate: formattedDate ?? this.formattedDate,
            moodDisplay: moodDisplay ?? this.moodDisplay,
            summary: summary ?? this.summary,
            meaning: meaning ?? this.meaning,
            userResponse: userResponse ?? this.userResponse,
            mood: mood ?? this.mood,
            moodScore: moodScore ?? this.moodScore,
            symbolTags: symbolTags ?? this.symbolTags,
            emotionalLandscape: emotionalLandscape ?? this.emotionalLandscape,
            careReflection: careReflection ?? this.careReflection,
            createdAt: createdAt ?? this.createdAt,
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        contentVoice: json["content_voice"],
        formattedDate: json["formatted_date"],
        moodDisplay: json["mood_display"],
        summary: json["summary"],
        meaning: json["meaning"],
        userResponse: json["user_response"],
        mood: json["mood"],
        moodScore: json["mood_score"],
        symbolTags: json["symbol_tags"] == null ? [] : List<String>.from(json["symbol_tags"]!.map((x) => x)),
        emotionalLandscape: json["emotional_landscape"] == null ? [] : List<EmotionalLandscape>.from(json["emotional_landscape"]!.map((x) => EmotionalLandscape.fromJson(x))),
        careReflection: json["care_reflection"] == null ? [] : List<CareReflection>.from(json["care_reflection"]!.map((x) => CareReflection.fromJson(x))),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "content": content,
        "content_voice": contentVoice,
        "formatted_date": formattedDate,
        "mood_display": moodDisplay,
        "summary": summary,
        "meaning": meaning,
        "user_response": userResponse,
        "mood": mood,
        "mood_score": moodScore,
        "symbol_tags": symbolTags == null ? [] : List<dynamic>.from(symbolTags!.map((x) => x)),
        "emotional_landscape": emotionalLandscape == null ? [] : List<dynamic>.from(emotionalLandscape!.map((x) => x.toJson())),
        "care_reflection": careReflection == null ? [] : List<dynamic>.from(careReflection!.map((x) => x.toJson())),
        "created_at": createdAt?.toIso8601String(),
    };
}

class CareReflection {
    String? title;
    String? shortTitle;

    CareReflection({
        this.title,
        this.shortTitle,
    });

    CareReflection copyWith({
        String? title,
        String? shortTitle,
    }) => 
        CareReflection(
            title: title ?? this.title,
            shortTitle: shortTitle ?? this.shortTitle,
        );

    factory CareReflection.fromRawJson(String str) => CareReflection.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CareReflection.fromJson(Map<String, dynamic> json) => CareReflection(
        title: json["title"],
        shortTitle: json["short_title"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "short_title": shortTitle,
    };
}

class EmotionalLandscape {
    String? name;
    int? percentage;

    EmotionalLandscape({
        this.name,
        this.percentage,
    });

    EmotionalLandscape copyWith({
        String? name,
        int? percentage,
    }) => 
        EmotionalLandscape(
            name: name ?? this.name,
            percentage: percentage ?? this.percentage,
        );

    factory EmotionalLandscape.fromRawJson(String str) => EmotionalLandscape.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory EmotionalLandscape.fromJson(Map<String, dynamic> json) => EmotionalLandscape(
        name: json["name"],
        percentage: json["percentage"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "percentage": percentage,
    };
}
