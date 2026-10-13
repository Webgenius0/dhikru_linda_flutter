import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:dhikru_linda_flutter/constants/app_constants.dart';
import 'package:dhikru_linda_flutter/features/subscription/data/api.dart';
import 'package:dhikru_linda_flutter/helpers/di.dart';
import 'package:dhikru_linda_flutter/networks/api_acess.dart';

class PurchaseManager {
  static final PurchaseManager _instance = PurchaseManager._internal();
  factory PurchaseManager() => _instance;
  PurchaseManager._internal();

  final InAppPurchase _iap = InAppPurchase.instance;
  final GetSubscriptionApi _subscriptionApi = GetSubscriptionApi.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  void initialize({void Function(bool isPremium)? onStatusChanged}) {
    final purchaseUpdated = _iap.purchaseStream;
    _subscription?.cancel();
    _subscription = purchaseUpdated.listen(
      (purchases) => _handlePurchaseUpdates(purchases, onStatusChanged: onStatusChanged),
      onDone: () => _subscription?.cancel(),
      onError: (error) => debugPrint("Purchase Stream Error: $error"),
    );
  }

  Future<void> _handlePurchaseUpdates(
    List<PurchaseDetails> purchaseDetailsList, {
    void Function(bool isPremium)? onStatusChanged,
  }) async {
    for (var purchase in purchaseDetailsList) {
      switch (purchase.status) {
        case PurchaseStatus.pending:
          break;

        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await _verifyAndAcknowledge(purchase, onStatusChanged: onStatusChanged);
          break;

        case PurchaseStatus.error:
        case PurchaseStatus.canceled:
          if (purchase.pendingCompletePurchase) {
            await _iap.completePurchase(purchase);
          }
          break;
      }
    }
  }

  Future<void> _verifyAndAcknowledge(
    PurchaseDetails purchase, {
    void Function(bool isPremium)? onStatusChanged,
  }) async {
    try {
      final purchaseToken = purchase.verificationData.serverVerificationData;
      final productId = purchase.productID;
      final purchaseId = purchase.purchaseID;
      final authToken = appData.read(kKeyAccessToken);

      final result = await _subscriptionApi.verifyGoogleSubscriptionApi(
        productId: productId,
        purchaseToken: purchaseToken,
        purchaseId: purchaseId,
        authToken: authToken,
      );

      if (result.success && result.isPremium) {
        if (purchase.pendingCompletePurchase) {
          await _iap.completePurchase(purchase);
        }
        await getSubscriptionRxObj.getSubscriptionStatus();
        onStatusChanged?.call(true);
      }
    } catch (e) {
      if (Platform.isIOS && purchase.pendingCompletePurchase) {
        final errStr = e.toString().toLowerCase();
        if (errStr.contains('400') ||
            errStr.contains('expired') ||
            errStr.contains('not active')) {
          await _iap.completePurchase(purchase);
        }
      }
      debugPrint("Verification failed: $e.");
    }
  }

  void dispose() {
    _subscription?.cancel();
  }
}
