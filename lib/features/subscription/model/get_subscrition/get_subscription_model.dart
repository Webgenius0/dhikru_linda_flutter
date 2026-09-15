import 'dart:convert';

class GetSubscriptionModel {
  bool? success;
  String? message;
  Data? data;
  int? code;

  GetSubscriptionModel({this.success, this.message, this.data, this.code});

  GetSubscriptionModel copyWith({
    bool? success,
    String? message,
    Data? data,
    int? code,
  }) => GetSubscriptionModel(
    success: success ?? this.success,
    message: message ?? this.message,
    data: data ?? this.data,
    code: code ?? this.code,
  );

  factory GetSubscriptionModel.fromRawJson(String str) =>
      GetSubscriptionModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSubscriptionModel.fromJson(Map<String, dynamic> json) =>
      GetSubscriptionModel(
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
  bool? isPremium;
  dynamic platform;
  dynamic productId;
  dynamic expiresAt;
  dynamic transactionId;
  List<Plan>? plans;
  List<String>? benefits;

  Data({
    this.isPremium,
    this.platform,
    this.productId,
    this.expiresAt,
    this.transactionId,
    this.plans,
    this.benefits,
  });

  Data copyWith({
    bool? isPremium,
    dynamic platform,
    dynamic productId,
    dynamic expiresAt,
    dynamic transactionId,
    List<Plan>? plans,
    List<String>? benefits,
  }) => Data(
    isPremium: isPremium ?? this.isPremium,
    platform: platform ?? this.platform,
    productId: productId ?? this.productId,
    expiresAt: expiresAt ?? this.expiresAt,
    transactionId: transactionId ?? this.transactionId,
    plans: plans ?? this.plans,
    benefits: benefits ?? this.benefits,
  );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    isPremium: json["is_premium"] ?? false,
    platform: json["platform"],
    productId: json["product_id"],
    expiresAt: json["expires_at"],
    transactionId: json["transaction_id"],
    plans: json["plans"] is List
        ? List<Plan>.from((json["plans"] as List).map((x) => Plan.fromJson(x)))
        : [],
    benefits: json["benefits"] is List
        ? List<String>.from((json["benefits"] as List).map((x) => x.toString()))
        : [],
  );

  Map<String, dynamic> toJson() => {
    "is_premium": isPremium,
    "platform": platform,
    "product_id": productId,
    "expires_at": expiresAt,
    "transaction_id": transactionId,
    "plans": plans == null
        ? []
        : List<dynamic>.from(plans!.map((x) => x.toJson())),
    "benefits": benefits == null
        ? []
        : List<dynamic>.from(benefits!.map((x) => x)),
  };
}

class Plan {
  String? id;
  String? name;
  double? price;
  String? period;

  Plan({this.id, this.name, this.price, this.period});

  Plan copyWith({String? id, String? name, double? price, String? period}) =>
      Plan(
        id: id ?? this.id,
        name: name ?? this.name,
        price: price ?? this.price,
        period: period ?? this.period,
      );

  factory Plan.fromRawJson(String str) => Plan.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
    id: json["id"]?.toString(),
    name: json["name"]?.toString(),
    price: json["price"] != null
        ? (json["price"] is num
              ? (json["price"] as num).toDouble()
              : double.tryParse(json["price"].toString()))
        : null,
    period: json["period"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
    "period": period,
  };
}
