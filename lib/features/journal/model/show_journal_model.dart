import 'dart:convert';
import 'package:dhikru_linda_flutter/features/journal/model/send_journal_message_model.dart';

class ShowJournalModel {
    bool? success;
    String? message;
    Data? data;

    ShowJournalModel({
        this.success,
        this.message,
        this.data,
    });

    ShowJournalModel copyWith({
        bool? success,
        String? message,
        Data? data,
    }) => 
        ShowJournalModel(
            success: success ?? this.success,
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory ShowJournalModel.fromRawJson(String str) => ShowJournalModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ShowJournalModel.fromJson(Map<String, dynamic> json) => ShowJournalModel(
        success: json["success"],
        message: json["message"]?.toString(),
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
    String? dreamContent;
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
    List<ChatMessage>? messages;
    DateTime? createdAt;

    Data({
        this.id,
        this.title,
        this.content,
        this.dreamContent,
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
        this.messages,
        this.createdAt,
    });

    Data copyWith({
        int? id,
        String? title,
        String? content,
        String? dreamContent,
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
        List<ChatMessage>? messages,
        DateTime? createdAt,
    }) => 
        Data(
            id: id ?? this.id,
            title: title ?? this.title,
            content: content ?? this.content,
            dreamContent: dreamContent ?? this.dreamContent,
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
            messages: messages ?? this.messages,
            createdAt: createdAt ?? this.createdAt,
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        dreamContent: json["dream_content"],
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
        messages: json["messages"] == null ? [] : List<ChatMessage>.from(json["messages"]!.map((x) => ChatMessage.fromJson(x))),
        createdAt: json["created_at"] == null ? null : DateTime.tryParse(json["created_at"].toString()),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "content": content,
        "dream_content": dreamContent,
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
        "messages": messages == null ? [] : List<dynamic>.from(messages!.map((x) => x.toJson())),
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
