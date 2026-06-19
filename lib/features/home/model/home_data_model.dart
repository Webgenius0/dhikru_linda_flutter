import 'dart:convert';

class HomeDataModel {
    bool? success;
    String? message;
    Data? data;

    HomeDataModel({
        this.success,
        this.message,
        this.data,
    });

    HomeDataModel copyWith({
        bool? success,
        String? message,
        Data? data,
    }) => 
        HomeDataModel(
            success: success ?? this.success,
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory HomeDataModel.fromRawJson(String str) => HomeDataModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory HomeDataModel.fromJson(Map<String, dynamic> json) => HomeDataModel(
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
    Stats? stats;
    List<RecentDream>? recentDreams;
    WeeklyInsight? weeklyInsight;

    Data({
        this.stats,
        this.recentDreams,
        this.weeklyInsight,
    });

    Data copyWith({
        Stats? stats,
        List<RecentDream>? recentDreams,
        WeeklyInsight? weeklyInsight,
    }) => 
        Data(
            stats: stats ?? this.stats,
            recentDreams: recentDreams ?? this.recentDreams,
            weeklyInsight: weeklyInsight ?? this.weeklyInsight,
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        stats: json["stats"] == null ? null : Stats.fromJson(json["stats"]),
        recentDreams: json["recent_dreams"] == null ? [] : List<RecentDream>.from(json["recent_dreams"]!.map((x) => RecentDream.fromJson(x))),
        weeklyInsight: json["weekly_insight"] == null ? null : WeeklyInsight.fromJson(json["weekly_insight"]),
    );

    Map<String, dynamic> toJson() => {
        "stats": stats?.toJson(),
        "recent_dreams": recentDreams == null ? [] : List<dynamic>.from(recentDreams!.map((x) => x.toJson())),
        "weekly_insight": weeklyInsight?.toJson(),
    };
}

class RecentDream {
    int? id;
    String? title;
    String? summary;
    String? moodDisplay;
    String? timeAgo;
    List<String>? emotionalTags;

    RecentDream({
        this.id,
        this.title,
        this.summary,
        this.moodDisplay,
        this.timeAgo,
        this.emotionalTags,
    });

    RecentDream copyWith({
        int? id,
        String? title,
        String? summary,
        String? moodDisplay,
        String? timeAgo,
        List<String>? emotionalTags,
    }) => 
        RecentDream(
            id: id ?? this.id,
            title: title ?? this.title,
            summary: summary ?? this.summary,
            moodDisplay: moodDisplay ?? this.moodDisplay,
            timeAgo: timeAgo ?? this.timeAgo,
            emotionalTags: emotionalTags ?? this.emotionalTags,
        );

    factory RecentDream.fromRawJson(String str) => RecentDream.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory RecentDream.fromJson(Map<String, dynamic> json) => RecentDream(
        id: json["id"],
        title: json["title"],
        summary: json["summary"],
        moodDisplay: json["mood_display"],
        timeAgo: json["time_ago"],
        emotionalTags: json["emotional_tags"] == null ? [] : List<String>.from(json["emotional_tags"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "summary": summary,
        "mood_display": moodDisplay,
        "time_ago": timeAgo,
        "emotional_tags": emotionalTags == null ? [] : List<dynamic>.from(emotionalTags!.map((x) => x)),
    };
}

class Stats {
    int? totalDreams;
    int? dreamsThisWeek;
    String? avgMood;

    Stats({
        this.totalDreams,
        this.dreamsThisWeek,
        this.avgMood,
    });

    Stats copyWith({
        int? totalDreams,
        int? dreamsThisWeek,
        String? avgMood,
    }) => 
        Stats(
            totalDreams: totalDreams ?? this.totalDreams,
            dreamsThisWeek: dreamsThisWeek ?? this.dreamsThisWeek,
            avgMood: avgMood ?? this.avgMood,
        );

    factory Stats.fromRawJson(String str) => Stats.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Stats.fromJson(Map<String, dynamic> json) => Stats(
        totalDreams: json["total_dreams"],
        dreamsThisWeek: json["dreams_this_week"],
        avgMood: json["avg_mood"],
    );

    Map<String, dynamic> toJson() => {
        "total_dreams": totalDreams,
        "dreams_this_week": dreamsThisWeek,
        "avg_mood": avgMood,
    };
}

class WeeklyInsight {
    MoodTrend? moodTrend;

    WeeklyInsight({
        this.moodTrend,
    });

    WeeklyInsight copyWith({
        MoodTrend? moodTrend,
    }) => 
        WeeklyInsight(
            moodTrend: moodTrend ?? this.moodTrend,
        );

    factory WeeklyInsight.fromRawJson(String str) => WeeklyInsight.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory WeeklyInsight.fromJson(Map<String, dynamic> json) => WeeklyInsight(
        moodTrend: json["mood_trend"] == null ? null : MoodTrend.fromJson(json["mood_trend"]),
    );

    Map<String, dynamic> toJson() => {
        "mood_trend": moodTrend?.toJson(),
    };
}

class MoodTrend {
    List<Datum>? data;
    String? description;

    MoodTrend({
        this.data,
        this.description,
    });

    MoodTrend copyWith({
        List<Datum>? data,
        String? description,
    }) => 
        MoodTrend(
            data: data ?? this.data,
            description: description ?? this.description,
        );

    factory MoodTrend.fromRawJson(String str) => MoodTrend.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory MoodTrend.fromJson(Map<String, dynamic> json) => MoodTrend(
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "description": description,
    };
}

class Datum {
    String? day;
    int? score;

    Datum({
        this.day,
        this.score,
    });

    Datum copyWith({
        String? day,
        int? score,
    }) => 
        Datum(
            day: day ?? this.day,
            score: score ?? this.score,
        );

    factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        day: json["day"],
        score: json["score"],
    );

    Map<String, dynamic> toJson() => {
        "day": day,
        "score": score,
    };
}
