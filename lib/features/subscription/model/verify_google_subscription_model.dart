import 'dart:io';

class GoogleVerifyRequest {
  final String platform;
  final String productId;
  final String purchaseToken;
  final String? purchaseId;
  final String? basePlanId;

  GoogleVerifyRequest({
    String? platform,
    required this.productId,
    required this.purchaseToken,
    this.purchaseId,
    this.basePlanId,
  }) : platform = platform ?? (Platform.isIOS ? 'apple' : 'google');

  Map<String, dynamic> toJson() => {
        'platform': platform,
        'product_id': productId,
        'purchase_token': purchaseToken,
        'purchase_id': purchaseId,
        'base_plan_id': basePlanId,
      };
}

class VerifyResponse {
  final bool success;
  final String message;
  final bool isPremium;
  final String? platform;
  final String? productId;
  final String? basePlanId;
  final DateTime? expiresAt;
  final int? code;

  VerifyResponse({
    required this.success,
    required this.message,
    required this.isPremium,
    this.platform,
    this.productId,
    this.basePlanId,
    this.expiresAt,
    this.code,
  });

  factory VerifyResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return VerifyResponse(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      isPremium: data['is_premium'] == true,
      platform: data['platform']?.toString(),
      productId: data['product_id']?.toString(),
      basePlanId: data['base_plan_id']?.toString() ?? data['plan_id']?.toString(),
      expiresAt: data['expires_at'] != null
          ? DateTime.tryParse(data['expires_at'].toString())
          : null,
      code: json['code'] is int ? json['code'] as int : null,
    );
  }
}
