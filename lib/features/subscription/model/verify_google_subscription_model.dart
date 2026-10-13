import 'dart:io';

class GoogleVerifyRequest {
  final String platform;
  final String productId;
  final String purchaseToken;
  final String? purchaseId;
  final String? transactionId;
  final String? originalTransactionId;
  final String? basePlanId;

  GoogleVerifyRequest({
    String? platform,
    required this.productId,
    required this.purchaseToken,
    this.purchaseId,
    this.transactionId,
    this.originalTransactionId,
    this.basePlanId,
  }) : platform = platform ?? (Platform.isIOS ? 'apple' : 'google');

  Map<String, dynamic> toJson() {
    final isApple = platform == 'apple';
    final resolvedTxId = transactionId ?? purchaseId;
    return {
      'platform': platform,
      'product_id': productId,
      'purchase_token': purchaseToken,
      if (isApple && resolvedTxId != null) 'transaction_id': resolvedTxId,
      if (isApple && resolvedTxId != null) 'purchase_id': resolvedTxId,
      if (!isApple && resolvedTxId != null) 'purchase_id': resolvedTxId,
      if (originalTransactionId != null)
        'original_transaction_id': originalTransactionId,
      if (basePlanId != null) 'base_plan_id': basePlanId,
    };
  }
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
      isPremium: data['is_premium'] == true || json['is_premium'] == true,
      platform: data['platform']?.toString() ?? json['platform']?.toString(),
      productId: data['product_id']?.toString() ?? json['product_id']?.toString(),
      basePlanId: data['base_plan_id']?.toString() ??
          json['base_plan_id']?.toString() ??
          data['plan_id']?.toString(),
      expiresAt: data['expires_at'] != null
          ? DateTime.tryParse(data['expires_at'].toString())
          : (json['expires_at'] != null
              ? DateTime.tryParse(json['expires_at'].toString())
              : null),
      code: json['code'] is int ? json['code'] as int : null,
    );
  }
}
