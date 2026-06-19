import 'dart:convert';

class InsightsDataModel {
    bool? success;
    String? message;
    Data? data;

    InsightsDataModel({
        this.success,
        this.message,
        this.data,
    });

    InsightsDataModel copyWith({
        bool? success,
        String? message,
        Data? data,
    }) => 
        InsightsDataModel(
            success: success ?? this.success,
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory InsightsDataModel.fromRawJson(String str) => InsightsDataModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory InsightsDataModel.fromJson(Map<String, dynamic> json) => InsightsDataModel(
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
    MoodTrend? moodTrend;
    ThemeFrequency? themeFrequency;
    List<RecurringSymbol>? recurringSymbols;
    SubconsciousEvolution? subconsciousEvolution;

    Data({
        this.moodTrend,
        this.themeFrequency,
        this.recurringSymbols,
        this.subconsciousEvolution,
    });

    Data copyWith({
        MoodTrend? moodTrend,
        ThemeFrequency? themeFrequency,
        List<RecurringSymbol>? recurringSymbols,
        SubconsciousEvolution? subconsciousEvolution,
    }) => 
        Data(
            moodTrend: moodTrend ?? this.moodTrend,
            themeFrequency: themeFrequency ?? this.themeFrequency,
            recurringSymbols: recurringSymbols ?? this.recurringSymbols,
            subconsciousEvolution: subconsciousEvolution ?? this.subconsciousEvolution,
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        moodTrend: json["mood_trend"] == null ? null : MoodTrend.fromJson(json["mood_trend"]),
        themeFrequency: json["theme_frequency"] == null ? null : ThemeFrequency.fromJson(json["theme_frequency"]),
        recurringSymbols: json["recurring_symbols"] == null ? [] : List<RecurringSymbol>.from(json["recurring_symbols"]!.map((x) => RecurringSymbol.fromJson(x))),
        subconsciousEvolution: json["subconscious_evolution"] == null ? null : SubconsciousEvolution.fromJson(json["subconscious_evolution"]),
    );

    Map<String, dynamic> toJson() => {
        "mood_trend": moodTrend?.toJson(),
        "theme_frequency": themeFrequency?.toJson(),
        "recurring_symbols": recurringSymbols == null ? [] : List<dynamic>.from(recurringSymbols!.map((x) => x.toJson())),
        "subconscious_evolution": subconsciousEvolution?.toJson(),
    };
}

class MoodTrend {
    List<MoodTrendDatum>? data;
    String? description;

    MoodTrend({
        this.data,
        this.description,
    });

    MoodTrend copyWith({
        List<MoodTrendDatum>? data,
        String? description,
    }) => 
        MoodTrend(
            data: data ?? this.data,
            description: description ?? this.description,
        );

    factory MoodTrend.fromRawJson(String str) => MoodTrend.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory MoodTrend.fromJson(Map<String, dynamic> json) => MoodTrend(
        data: json["data"] == null ? [] : List<MoodTrendDatum>.from(json["data"]!.map((x) => MoodTrendDatum.fromJson(x))),
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "description": description,
    };
}

class MoodTrendDatum {
    String? day;
    int? score;

    MoodTrendDatum({
        this.day,
        this.score,
    });

    MoodTrendDatum copyWith({
        String? day,
        int? score,
    }) => 
        MoodTrendDatum(
            day: day ?? this.day,
            score: score ?? this.score,
        );

    factory MoodTrendDatum.fromRawJson(String str) => MoodTrendDatum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory MoodTrendDatum.fromJson(Map<String, dynamic> json) => MoodTrendDatum(
        day: json["day"],
        score: json["score"],
    );

    Map<String, dynamic> toJson() => {
        "day": day,
        "score": score,
    };
}

class RecurringSymbol {
    String? name;
    int? count;
    String? display;

    RecurringSymbol({
        this.name,
        this.count,
        this.display,
    });

    RecurringSymbol copyWith({
        String? name,
        int? count,
        String? display,
    }) => 
        RecurringSymbol(
            name: name ?? this.name,
            count: count ?? this.count,
            display: display ?? this.display,
        );

    factory RecurringSymbol.fromRawJson(String str) => RecurringSymbol.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory RecurringSymbol.fromJson(Map<String, dynamic> json) => RecurringSymbol(
        name: json["name"],
        count: json["count"],
        display: json["display"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "count": count,
        "display": display,
    };
}

class SubconsciousEvolution {
    String? title;
    String? timeframe;
    String? description;
    double? intensityScore;
    String? intensityLabel;

    SubconsciousEvolution({
        this.title,
        this.timeframe,
        this.description,
        this.intensityScore,
        this.intensityLabel,
    });

    SubconsciousEvolution copyWith({
        String? title,
        String? timeframe,
        String? description,
        double? intensityScore,
        String? intensityLabel,
    }) => 
        SubconsciousEvolution(
            title: title ?? this.title,
            timeframe: timeframe ?? this.timeframe,
            description: description ?? this.description,
            intensityScore: intensityScore ?? this.intensityScore,
            intensityLabel: intensityLabel ?? this.intensityLabel,
        );

    factory SubconsciousEvolution.fromRawJson(String str) => SubconsciousEvolution.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory SubconsciousEvolution.fromJson(Map<String, dynamic> json) => SubconsciousEvolution(
        title: json["title"],
        timeframe: json["timeframe"],
        description: json["description"],
        intensityScore: json["intensity_score"]?.toDouble(),
        intensityLabel: json["intensity_label"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "timeframe": timeframe,
        "description": description,
        "intensity_score": intensityScore,
        "intensity_label": intensityLabel,
    };
}

class ThemeFrequency {
    List<ThemeFrequencyDatum>? data;
    String? dominantThemeLabel;

    ThemeFrequency({
        this.data,
        this.dominantThemeLabel,
    });

    ThemeFrequency copyWith({
        List<ThemeFrequencyDatum>? data,
        String? dominantThemeLabel,
    }) => 
        ThemeFrequency(
            data: data ?? this.data,
            dominantThemeLabel: dominantThemeLabel ?? this.dominantThemeLabel,
        );

    factory ThemeFrequency.fromRawJson(String str) => ThemeFrequency.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ThemeFrequency.fromJson(Map<String, dynamic> json) => ThemeFrequency(
        data: json["data"] == null ? [] : List<ThemeFrequencyDatum>.from(json["data"]!.map((x) => ThemeFrequencyDatum.fromJson(x))),
        dominantThemeLabel: json["dominant_theme_label"],
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "dominant_theme_label": dominantThemeLabel,
    };
}

class ThemeFrequencyDatum {
    String? name;
    int? count;
    int? percentage;

    ThemeFrequencyDatum({
        this.name,
        this.count,
        this.percentage,
    });

    ThemeFrequencyDatum copyWith({
        String? name,
        int? count,
        int? percentage,
    }) => 
        ThemeFrequencyDatum(
            name: name ?? this.name,
            count: count ?? this.count,
            percentage: percentage ?? this.percentage,
        );

    factory ThemeFrequencyDatum.fromRawJson(String str) => ThemeFrequencyDatum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ThemeFrequencyDatum.fromJson(Map<String, dynamic> json) => ThemeFrequencyDatum(
        name: json["name"],
        count: json["count"],
        percentage: json["percentage"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "count": count,
        "percentage": percentage,
    };
}
