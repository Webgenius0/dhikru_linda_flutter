

import 'dart:async';
import 'dart:io';
import 'package:dhikru_linda_flutter/constants/app_constants.dart';
import 'package:dhikru_linda_flutter/features/subscription/presentation/services/perces_verficy_servis_screen.dart';
import 'package:dhikru_linda_flutter/helpers/di.dart';
import 'package:dhikru_linda_flutter/helpers/ui_helpers.dart';
import 'package:dhikru_linda_flutter/helpers/url_lunch.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dhikru_linda_flutter/features/subscription/model/get_subscrition/get_subscription_model.dart';
import 'package:dhikru_linda_flutter/helpers/toast.dart';
import 'package:dhikru_linda_flutter/networks/api_acess.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import 'log/presces_log.dart';

enum SubscriptionPlanType {
  monthly,
  yearly;

  String get googlePlayBasePlanId {
    switch (this) {
      case SubscriptionPlanType.monthly:
        return 'monthly';
      case SubscriptionPlanType.yearly:
        return 'annual';
    }
  }

  String get appleProductId {
    switch (this) {
      case SubscriptionPlanType.monthly:
        return 'dreamtrace_ai_monthly';
      case SubscriptionPlanType.yearly:
        return 'dreamtrace_ai_annual';
    }
  }

  String get backendPlanId {
    switch (this) {
      case SubscriptionPlanType.monthly:
        return 'monthly_premium';
      case SubscriptionPlanType.yearly:
        return 'yearly_premium';
    }
  }

  String get displayName {
    switch (this) {
      case SubscriptionPlanType.monthly:
        return 'Monthly Plan';
      case SubscriptionPlanType.yearly:
        return 'Yearly Plan';
    }
  }

  String get billingSubtitle {
    switch (this) {
      case SubscriptionPlanType.monthly:
        return 'Billed monthly, cancel anytime';
      case SubscriptionPlanType.yearly:
        return 'Billed annually, cancel anytime';
    }
  }

  String? get badgeText {
    switch (this) {
      case SubscriptionPlanType.monthly:
        return null;
      case SubscriptionPlanType.yearly:
        return 'BEST VALUE';
    }
  }
}

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  SubscriptionPlanType _selectedPlanType = SubscriptionPlanType.monthly;
  SubscriptionPlanType? _pendingPlanType;
  bool _isProcessing = false;

  final InAppPurchase _appPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _purchaseSubscription;

  // Platform-adaptive store getters
  String get _storeName => Platform.isIOS ? 'App Store' : 'Google Play';
  String get _paymentPlatformName =>
      Platform.isIOS ? 'Apple App Store' : 'Google Play Store';
  String get _manageSubscriptionUrl => Platform.isIOS
      ? 'https://apps.apple.com/account/subscriptions'
      : 'https://play.google.com/store/account/subscriptions';
  String get _manageSubscriptionTitle => 'Manage subscription on $_storeName';

  String _autoRenewDisclosure(bool isPremium) {
    if (isPremium) {
      return Platform.isIOS
          ? 'Managed via App Store. Cancel anytime in your App Store account settings at least 24 hours before the renewal date.'
          : 'Managed via Google Play. Cancel anytime in your Google Play account settings at least 24 hours before the renewal date.';
    } else {
      if (Platform.isIOS) {
        return 'Subscription auto-renews until cancelled. Cancel anytime in your App Store account settings at least 24 hours before the renewal date. Payment is charged to your Apple ID account at confirmation of purchase.';
      } else if (Platform.isAndroid) {
        return 'Subscription auto-renews until cancelled. Cancel anytime in your Google Play account settings at least 24 hours before the renewal date. Payment is charged to your Google Play account at confirmation of purchase.';
      } else {
        return 'Subscription auto-renews until cancelled. Cancel anytime in your App Store or Google Play account settings at least 24 hours before the renewal date. Payment is charged to your Apple ID / Google Play account at confirmation of purchase.';
      }
    }
  }

  String _formatDateTime(dynamic dateVal) {
    if (dateVal == null) return 'Expiration information unavailable';
    try {
      DateTime dt;
      if (dateVal is num) {
        final val = dateVal.toInt();
        dt = DateTime.fromMillisecondsSinceEpoch(
          val < 10000000000 ? val * 1000 : val,
          isUtc: true,
        ).toLocal();
      } else {
        final str = dateVal.toString().trim();
        if (str.isEmpty || str == 'null') {
          return 'Expiration information unavailable';
        }
        dt = DateTime.parse(str).toLocal();
      }
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      final day = dt.day;
      final month = months[dt.month - 1];
      final year = dt.year;
      final hourInt = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      return '$day $month $year, $hourInt:$minute $period';
    } catch (_) {
      return dateVal.toString();
    }
  }

  List<ProductDetails> _products = [];
  bool _isStoreAvailable = false;
  bool _isLoadingProducts = false;

  // Prevents verifying the same purchase twice if the stream emits it again
  final Set<String> _verifyingKeys = <String>{};

  @override
  void initState() {
    super.initState();
    PLog.section('SUBSCRIPTION SCREEN OPENED');

    // 1. Listen to In-App Purchase updates stream
    PLog.step('Attaching purchaseStream listener');
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _appPurchase.purchaseStream;
    _purchaseSubscription = purchaseUpdated.listen(
      _listenToPurchaseUpdated,
      onDone: () {
        PLog.warn('purchaseStream closed (onDone)');
        _purchaseSubscription.cancel();
      },
      onError: (error, st) {
        PLog.error('Billing stream error', error, st);
        ToastUtil.showShortToast(
            'Billing service encountered an issue. Please try again.');
      },
    );
    PLog.success('purchaseStream listener attached');

    // 2. Query Google Play Store products & status
    PLog.step('Requesting subscription status from backend');
    getSubscriptionRxObj.getSubscriptionStatus();
    _initStoreAndLoadProducts();
  }

  @override
  void dispose() {
    PLog.info('Subscription screen closed, cancelling purchaseStream listener');
    _purchaseSubscription.cancel();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // AUTH TOKEN
  // ---------------------------------------------------------------------------
  Future<String?> _getAuthToken() async {
    return appData.read(kKeyAccessToken);
  }


  // ---------------------------------------------------------------------------
  // STORE + PRODUCTS
  // ---------------------------------------------------------------------------
  Future<void> _initStoreAndLoadProducts() async {
    PLog.section(Platform.isIOS ? 'APPLE APP STORE CHECK' : 'GOOGLE PLAY STORE CHECK');
    try {
      if (mounted) setState(() => _isLoadingProducts = true);

      PLog.step('Checking if billing service is available');
      final available = await _appPurchase.isAvailable();
      if (mounted) setState(() => _isStoreAvailable = available);

      if (!available) {
        PLog.error(
          Platform.isIOS
              ? 'StoreKit is NOT available. Possible reasons: In-App Purchases restricted in Screen Time, or simulator/device cannot reach App Store.'
              : 'Google Play Billing NOT available. Possible reasons: emulator without Play Store, old Play Store version, no Google account, or app not installed from a Play-enabled device.',
        );
        if (mounted) setState(() => _isLoadingProducts = false);
        return;
      }
      PLog.success('Billing service available');

      final Set<String> productIds = Platform.isIOS
          ? const <String>{
              'dreamtrace_ai_monthly',
              'dreamtrace_ai_annual',
            }
          : const <String>{
              'dreamtrace_ai_premium',
            };
      PLog.step('Querying product details: $productIds on $_storeName');

      final response = await _appPurchase.queryProductDetails(productIds);

      if (response.error != null) {
        PLog.error('Product query failed: ${response.error}');
      } else {
        if (mounted) {
          setState(() {
            _products = response.productDetails;
          });
        }
        PLog.success('Found ${_products.length} product(s) in $_storeName');

        if (response.notFoundIDs.isNotEmpty) {
          PLog.warn(
            'Product IDs NOT found in $_storeName: ${response.notFoundIDs}. '
            '${Platform.isIOS ? "Check that products are in App Store Connect with matching IDs, Paid Apps Agreement is active, and a Sandbox account is configured." : "Check product status is Active and app is published to a testing track."}',
          );
        }

        for (final product in _products) {
          final Map<String, dynamic> info = {
            'ID': product.id,
            'Title': product.title,
            'Price': product.price,
            'Raw price': product.rawPrice,
            'Currency': product.currencyCode,
            'Description': product.description,
          };
          if (product is GooglePlayProductDetails) {
            info['Offer token'] = product.offerToken != null ? PLog.mask(product.offerToken) : 'null';
            info['Subscription index'] = product.subscriptionIndex;
            final subIndex = product.subscriptionIndex;
            final offers = product.productDetails.subscriptionOfferDetails;
            if (subIndex != null && offers != null && subIndex < offers.length) {
              final offer = offers[subIndex];
              info['Base plan ID'] = offer.basePlanId;
              info['Offer ID'] = offer.offerId ?? 'base_plan';
              if (offer.pricingPhases.isNotEmpty) {
                final phase = offer.pricingPhases.first;
                info['Billing period'] = phase.billingPeriod;
                info['Formatted price'] = phase.formattedPrice;
              }
            }
          }
          PLog.kv('Product offer', info);
        }

        final monthlyP = _findProductForPlan(SubscriptionPlanType.monthly);
        final yearlyP = _findProductForPlan(SubscriptionPlanType.yearly);
        if (Platform.isIOS) {
          PLog.info(
            'Apple StoreKit resolution: Monthly (dreamtrace_ai_monthly) found: ${monthlyP != null} (${monthlyP?.price ?? "N/A"}), '
            'Annual (dreamtrace_ai_annual) found: ${yearlyP != null} (${yearlyP?.price ?? "N/A"})',
          );
        } else {
          PLog.info(
            'Google Play base plan resolution: Monthly (basePlanId: monthly) found: ${monthlyP != null} (${monthlyP?.price ?? "N/A"}), '
            'Annual (basePlanId: annual) found: ${yearlyP != null} (${yearlyP?.price ?? "N/A"})',
          );
        }
      }
    } catch (e, st) {
      PLog.error('Failed to load store products', e, st);
    } finally {
      if (mounted) setState(() => _isLoadingProducts = false);
    }
  }

  // ---------------------------------------------------------------------------
  // PURCHASE STREAM HANDLING
  // ---------------------------------------------------------------------------
  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList,
      ) async {
    PLog.section(
      'PURCHASE STREAM UPDATE (${purchaseDetailsList.length} item(s))',
    );

    for (final purchaseDetails in purchaseDetailsList) {
      PLog.kv('Purchase event', {
        'Status': purchaseDetails.status,
        'Product ID': purchaseDetails.productID,
        'Purchase ID': purchaseDetails.purchaseID,
        'Pending complete': purchaseDetails.pendingCompletePurchase,
        'Source': purchaseDetails.verificationData.source,
        'Token': PLog.mask(
          purchaseDetails.verificationData.serverVerificationData,
        ),
      });

      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          PLog.info('Purchase is PENDING (waiting for payment/approval)');
          if (mounted) setState(() => _isProcessing = true);
          ToastUtil.showShortToast('$_storeName purchase pending...');
          break;

        case PurchaseStatus.error:
          _pendingPlanType = null;
          PLog.error(
            'Purchase ERROR: code=${purchaseDetails.error?.code}, '
                'message=${purchaseDetails.error?.message}, '
                'details=${purchaseDetails.error?.details}',
          );
          if (mounted) setState(() => _isProcessing = false);
          ToastUtil.showShortToast('Purchase could not be completed. Please try again.');
          if (purchaseDetails.pendingCompletePurchase) {
            PLog.step('Calling completePurchase for failed purchase');
            await _appPurchase.completePurchase(purchaseDetails);
          }
          break;

        case PurchaseStatus.canceled:
          _pendingPlanType = null;
          PLog.warn('Purchase CANCELED by user');
          if (mounted) setState(() => _isProcessing = false);
          ToastUtil.showShortToast('Purchase was canceled');
          if (purchaseDetails.pendingCompletePurchase) {
            PLog.step('Calling completePurchase for canceled purchase');
            await _appPurchase.completePurchase(purchaseDetails);
          }
          break;

        case PurchaseStatus.purchased:
          PLog.success('$_storeName says: PURCHASED');
          await _handleSuccessfulPurchase(purchaseDetails);
          break;

        case PurchaseStatus.restored:
          _pendingPlanType = null;
          PLog.success('$_storeName says: RESTORED');
          await _handleSuccessfulPurchase(purchaseDetails);
          break;
      }
    }
  }

  Future<void> _handleSuccessfulPurchase(PurchaseDetails purchase) async {
    final key = purchase.purchaseID ??
        purchase.verificationData.serverVerificationData;

    // Same purchase already being verified -> skip
    if (_verifyingKeys.contains(key)) {
      PLog.warn('Duplicate event for purchase $key, already verifying → skipped');
      return;
    }
    _verifyingKeys.add(key);

    if (mounted) setState(() => _isProcessing = true);

    final total = Stopwatch()..start();
    PLog.section('HANDLING SUCCESSFUL PURCHASE');

    try {
      PLog.kv('Purchase details', {
        'Product ID': purchase.productID,
        'Purchase ID': purchase.purchaseID,
        'Transaction date': purchase.transactionDate,
        'Source': purchase.verificationData.source,
        'Local verification': PLog.mask(
          purchase.verificationData.localVerificationData,
        ),
      });

      PLog.step('1/4 Verifying purchase with backend');
      final result = await _verifyPurchaseWithBackend(purchase);

      if (result.isSuccess) {
        PLog.success('2/4 Backend verification PASSED');

        // Complete/acknowledge ONLY after the backend confirmed it
        if (purchase.pendingCompletePurchase) {
          PLog.step('3/4 Calling completePurchase (acknowledge to $_storeName)');
          await _appPurchase.completePurchase(purchase);
          PLog.success('3/4 completePurchase done');
        } else {
          PLog.info('3/4 completePurchase not needed (already completed)');
        }

        PLog.step('4/4 Refreshing subscription status from backend');
        await getSubscriptionRxObj.getSubscriptionStatus();
        final planCount =
            getSubscriptionRxObj.dataFetcher.valueOrNull?.data?.plans?.length;
        PLog.success('4/4 Status refreshed (plans in response: $planCount)');

        PLog.success('🎉 PREMIUM ACTIVATED (${total.elapsedMilliseconds} ms)');
        ToastUtil.showLongToast('🎉 Premium activated!');
      } else if (result.isExpiredOrInactive) {
        PLog.warn(
          'Purchase (${purchase.purchaseID}) is expired or inactive according to backend. '
          'Completing purchase to clear stale transaction from $_storeName queue.',
        );
        if (purchase.pendingCompletePurchase) {
          await _appPurchase.completePurchase(purchase);
          PLog.info('Stale purchase completed and cleared.');
        }

        if (_pendingPlanType != null) {
          ToastUtil.showLongToast(
            result.message?.isNotEmpty == true
                ? result.message!
                : 'Subscription is no longer active or has expired.',
          );
        }
      } else {
        // completePurchase NOT called: Store will deliver this purchase again
        // on next app start / restore, so verification can be retried.
        PLog.error(
          'Backend verification FAILED. completePurchase was NOT called, so '
          'this purchase can be retried (reopen app or tap Restore). '
          'NOTE: Google auto-refunds unacknowledged purchases after 3 days.',
        );
        if (_pendingPlanType != null) {
          ToastUtil.showLongToast(
            'Purchase verification failed. Please tap "Restore purchases" or try again.',
          );
        }
      }
    } catch (e, st) {
      PLog.error('Purchase handling crashed', e, st);
      ToastUtil.showShortToast('Something went wrong. Please try again.');
    } finally {
      _pendingPlanType = null;
      _verifyingKeys.remove(key);
      if (mounted) setState(() => _isProcessing = false);
      PLog.info('Purchase handling finished in ${total.elapsedMilliseconds} ms');
    }
  }

  Future<PurchaseVerificationResult> _verifyPurchaseWithBackend(
      PurchaseDetails purchase) async {
    PLog.step('Reading auth token');
    final authToken = await _getAuthToken();

    if (authToken == null || authToken.isEmpty) {
      PLog.error(
        'Auth token is missing → cannot verify. Fix _getAuthToken() so it '
        'returns the logged-in user\'s token.',
      );
      return PurchaseVerificationResult.failure('Authentication token missing');
    }
    PLog.success('Auth token found: ${PLog.mask(authToken)}');

    // Determine plan type: from user selection or infer from productID
    String? effectiveBasePlanId;
    if (_pendingPlanType != null) {
      effectiveBasePlanId = _pendingPlanType!.googlePlayBasePlanId;
    } else if (purchase.productID.contains('annual') ||
        purchase.productID.contains('yearly')) {
      effectiveBasePlanId = 'annual';
    } else if (purchase.productID.contains('monthly')) {
      effectiveBasePlanId = 'monthly';
    }

    PLog.info(
      'Initiating backend purchase verification with basePlanId: $effectiveBasePlanId',
    );

    return PurchaseVerifyService.verifyPurchase(
      authToken: authToken,
      productId: purchase.productID,
      purchaseToken: purchase.verificationData.serverVerificationData,
      purchaseId: purchase.purchaseID,
      transactionId: purchase.purchaseID,
      basePlanId: effectiveBasePlanId,
      platform: Platform.isIOS ? 'apple' : 'google',
    );
  }

  Future<void> _restorePurchases() async {
    if (_isProcessing) {
      PLog.warn('Restore tapped but already processing → ignored');
      return;
    }
    PLog.section('RESTORE PURCHASES TAPPED');

    if (!_isStoreAvailable) {
      PLog.error('Restore blocked: store not available');
      ToastUtil.showShortToast('In-App Billing is not available on this device');
      return;
    }
    try {
      setState(() => _isProcessing = true);
      PLog.step('Calling restorePurchases()');
      await _appPurchase.restorePurchases();
      PLog.info('restorePurchases() called, waiting for stream results (3s)');
      // Results arrive through purchaseStream (status = restored)
      await Future.delayed(const Duration(seconds: 3));
    } catch (e, st) {
      PLog.error('Restore failed', e, st);
      ToastUtil.showShortToast('Failed to restore purchases. Please try again.');
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  // ---------------------------------------------------------------------------
  // PLAN LOOKUP HELPERS
  // ---------------------------------------------------------------------------
  ProductDetails? _findProductForPlan(SubscriptionPlanType planType) {
    if (Platform.isIOS) {
      final appleId = planType.appleProductId;
      for (final p in _products) {
        if (p.id == appleId) {
          return p;
        }
      }
      return null;
    }

    final targetBasePlanId = planType.googlePlayBasePlanId.toLowerCase();
    final targetPeriod = planType == SubscriptionPlanType.monthly ? 'P1M' : 'P1Y';

    // 1. Direct match on basePlanId from subscriptionOfferDetails
    for (final p in _products) {
      if (p is GooglePlayProductDetails) {
        final subIndex = p.subscriptionIndex;
        final offers = p.productDetails.subscriptionOfferDetails;
        if (subIndex != null && offers != null && subIndex < offers.length) {
          final offer = offers[subIndex];
          if (offer.basePlanId.toLowerCase() == targetBasePlanId) {
            return p;
          }
        }
      }
    }

    // 2. Match by pricing phase billing period ('P1M' or 'P1Y')
    for (final p in _products) {
      if (p is GooglePlayProductDetails) {
        final subIndex = p.subscriptionIndex;
        final offers = p.productDetails.subscriptionOfferDetails;
        if (subIndex != null && offers != null && subIndex < offers.length) {
          final offer = offers[subIndex];
          if (offer.pricingPhases.isNotEmpty) {
            final period = offer.pricingPhases.first.billingPeriod.toUpperCase();
            if (period.contains(targetPeriod)) {
              return p;
            }
          }
        }
      }
    }

    // 3. Fallback partial match on basePlanId
    for (final p in _products) {
      if (p is GooglePlayProductDetails) {
        final subIndex = p.subscriptionIndex;
        final offers = p.productDetails.subscriptionOfferDetails;
        if (subIndex != null && offers != null && subIndex < offers.length) {
          final bId = offers[subIndex].basePlanId.toLowerCase();
          if (planType == SubscriptionPlanType.monthly &&
              (bId.contains('month') || bId.contains('p1m'))) {
            return p;
          }
          if (planType == SubscriptionPlanType.yearly &&
              (bId.contains('year') || bId.contains('annual') || bId.contains('p1y'))) {
            return p;
          }
        }
      }
    }

    return null;
  }

  String? _getOfferToken(GooglePlayProductDetails gpProduct) {
    if (gpProduct.offerToken != null && gpProduct.offerToken!.isNotEmpty) {
      return gpProduct.offerToken;
    }
    final subIndex = gpProduct.subscriptionIndex;
    final offers = gpProduct.productDetails.subscriptionOfferDetails;
    if (subIndex != null && offers != null && subIndex < offers.length) {
      return offers[subIndex].offerIdToken;
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // BUY
  // ---------------------------------------------------------------------------
  Future<void> _buySelectedProduct() async {
    PLog.section('SUBSCRIBE BUTTON TAPPED');

    if (_isProcessing) {
      PLog.warn('Already processing → tap ignored');
      return;
    }

    if (!_isStoreAvailable) {
      PLog.error('Cannot buy: store not available');
      ToastUtil.showShortToast('In-App Billing is not available on this device');
      return;
    }

    if (_products.isEmpty) {
      PLog.error(
        'Cannot buy: no products loaded from $_storeName. Check product ID '
            'and that the subscription is Active in store console.',
      );
      ToastUtil.showShortToast('No subscription products found on $_storeName');
      return;
    }

    try {
      setState(() => _isProcessing = true);

      // Select chosen product based on explicit plan selection
      final selectedPlan = _selectedPlanType;
      PLog.info('Initiating purchase for plan: ${selectedPlan.displayName}');

      final matchedProduct = _findProductForPlan(selectedPlan);
      if (matchedProduct == null) {
        _pendingPlanType = null;
        PLog.error(
          Platform.isIOS
              ? 'Could not find store product for Apple product ID "${selectedPlan.appleProductId}". Available products: ${_products.length}'
              : 'Could not find store product for basePlanId "${selectedPlan.googlePlayBasePlanId}". Available products: ${_products.length}',
        );
        ToastUtil.showShortToast(
          Platform.isIOS
              ? 'Selected plan (${selectedPlan.displayName}) is currently unavailable from App Store'
              : 'Selected plan (${selectedPlan.googlePlayBasePlanId}) is currently unavailable',
        );
        if (mounted) setState(() => _isProcessing = false);
        return;
      }

      PurchaseParam purchaseParam;
      if (Platform.isAndroid) {
        if (matchedProduct is! GooglePlayProductDetails) {
          PLog.error('Matched product is not GooglePlayProductDetails on Android');
          if (mounted) setState(() => _isProcessing = false);
          return;
        }

        final targetBasePlanId = selectedPlan.googlePlayBasePlanId;
        final offerToken = _getOfferToken(matchedProduct);
        if (offerToken == null || offerToken.isEmpty) {
          _pendingPlanType = null;
          PLog.error('Missing offer token for Android subscription: basePlanId "$targetBasePlanId"');
          ToastUtil.showShortToast('Could not retrieve offer details for ${selectedPlan.displayName}');
          if (mounted) setState(() => _isProcessing = false);
          return;
        }

        // Diagnostic validation of base plan id from offer details
        String resolvedBasePlanId = targetBasePlanId;
        final subIndex = matchedProduct.subscriptionIndex;
        final offers = matchedProduct.productDetails.subscriptionOfferDetails;
        if (subIndex != null && offers != null && subIndex < offers.length) {
          resolvedBasePlanId = offers[subIndex].basePlanId;
        }

        PLog.kv('Launching Android Google Play Purchase', {
          'Plan': selectedPlan.displayName,
          'Base Plan ID': resolvedBasePlanId,
          'Product ID': matchedProduct.id,
          'Offer Token': '${offerToken.substring(0, offerToken.length > 15 ? 15 : offerToken.length)}...',
          'Price': matchedProduct.price,
        });

        purchaseParam = GooglePlayPurchaseParam(
          productDetails: matchedProduct,
          offerToken: offerToken,
        );
      } else {
        PLog.kv('Launching Apple App Store Purchase', {
          'Plan': selectedPlan.displayName,
          'Product ID': matchedProduct.id,
          'Price': matchedProduct.price,
        });
        purchaseParam = PurchaseParam(productDetails: matchedProduct);
      }

      _pendingPlanType = selectedPlan;
      final success = await _appPurchase.buyNonConsumable(
        purchaseParam: purchaseParam,
      );

      if (!success) {
        _pendingPlanType = null;
        PLog.error('buyNonConsumable returned false → $_storeName sheet not launched');
        ToastUtil.showShortToast('Could not launch $_storeName Billing sheet');
        if (mounted) setState(() => _isProcessing = false);
      } else {
        PLog.success('$_storeName billing sheet launched, waiting for result in purchaseStream');
      }
    } catch (e, st) {
      _pendingPlanType = null;
      PLog.error('Error launching purchase', e, st);
      ToastUtil.showShortToast('Purchase could not be completed. Please try again.');
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  IconData _getBenefitIcon(String text) {
    final lower = text.toLowerCase();
    if (lower.contains('psychological') ||
        lower.contains('interpretation') ||
        lower.contains('meaning')) {
      return Icons.psychology_rounded;
    } else if (lower.contains('chat') ||
        lower.contains('companion') ||
        lower.contains('conversation') ||
        lower.contains('conversational')) {
      return Icons.chat_bubble_outline_rounded;
    } else if (lower.contains('subconscious') ||
        lower.contains('insight') ||
        lower.contains('symbol') ||
        lower.contains('detection') ||
        lower.contains('emotion')) {
      return Icons.insights_rounded;
    } else if (lower.contains('unlimited') ||
        lower.contains('dream') ||
        lower.contains('log')) {
      return Icons.all_inclusive_rounded;
    } else if (lower.contains('meditation') ||
        lower.contains('care') ||
        lower.contains('reflection')) {
      return Icons.spa_outlined;
    } else {
      return Icons.auto_awesome_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: StreamBuilder<GetSubscriptionModel>(
        initialData: getSubscriptionRxObj.dataFetcher.valueOrNull,
        stream: getSubscriptionRxObj.getSubscriptionStream,
        builder: (context, snapshot) {
          final subData = snapshot.data?.data;
          final isPremium = subData?.isPremium ?? false;
          final benefits = (subData?.benefits?.isNotEmpty ?? false)
              ? subData!.benefits!
              : [
                  "Detailed Psychological Interpretation",
                  "Conversational AI Chat Companion",
                  "Subconscious Insights & Symbol Detection",
                  "Unlimited Dreams Log",
                ];

          // Resolve Monthly Plan details
          final monthlyProduct = _findProductForPlan(SubscriptionPlanType.monthly);
          final monthlyPrice = monthlyProduct != null
              ? monthlyProduct.price
              : (_isLoadingProducts ? 'Loading...' : 'Price unavailable');

          // Resolve Yearly Plan details
          final yearlyProduct = _findProductForPlan(SubscriptionPlanType.yearly);
          final yearlyPrice = yearlyProduct != null
              ? yearlyProduct.price
              : (_isLoadingProducts ? 'Loading...' : 'Price unavailable');

          final selectedProduct = _findProductForPlan(_selectedPlanType);
          final bool isSelectedProductLoaded = selectedProduct != null;

          return Stack(
            children: [
              // Background ambient gradient glow
              Positioned(
                top: -100,
                left: -50,
                right: -50,
                child: Container(
                  height: 380,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        (isPremium
                                ? const Color(0xFFFFD700)
                                : const Color(0xFF7B6EF6))
                            .withValues(alpha: 0.28),
                        const Color(0xFF9D7FF7).withValues(alpha: 0.12),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.45, 1.0],
                    ),
                  ),
                ),
              ),

              SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    // Top Navigation Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.maybePop(context),
                            child: Container(
                              width: 36,
                              height: 36,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  width: 1,
                                ),
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                          // Show PRO ACTIVE badge only when premium is active
                          if (isPremium)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFD700).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFFFFD700).withValues(alpha: 0.5),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFFD700),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'PRO ACTIVE',
                                    style: TextStyle(
                                      color: const Color(0xFFFFD700),
                                      fontSize: 10.5.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Main Scrollable Content
                    Expanded(
                      child: RefreshIndicator(
                        color: const Color(0xFF7B6EF6),
                        backgroundColor: const Color(0xFF131325),
                        onRefresh: () async {
                          PLog.section('PULL TO REFRESH');
                          await Future.wait([
                            getSubscriptionRxObj.getSubscriptionStatus(),
                            _initStoreAndLoadProducts(),
                          ]);
                        },
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 8),

                              // Header Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: isPremium
                                        ? const [
                                            Color(0xFFFFD700),
                                            Color(0xFFFF9900),
                                          ]
                                        : const [
                                            Color(0xFF7B6EF6),
                                            Color(0xFF9D7FF7),
                                          ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: (isPremium
                                              ? const Color(0xFFFFD700)
                                              : const Color(0xFF7B6EF6))
                                          .withValues(alpha: 0.4),
                                      blurRadius: 12,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isPremium
                                          ? Icons.workspace_premium_rounded
                                          : Icons.star_rounded,
                                      color: isPremium ? Colors.black : Colors.amberAccent,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      isPremium ? 'PRO ACCESS ACTIVE' : 'PREMIUM ACCESS',
                                      style: TextStyle(
                                        color: isPremium ? Colors.black : Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 14),

                              // Title & Subtitle
                              Text(
                                isPremium
                                    ? 'You Are A Premium Member'
                                    : 'Unlock Full AI Potential',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                isPremium
                                    ? 'Your subscription is active with full access to AI interpretations, symbol insights & unlimited logs.'
                                    : 'Gain deeper clarity with unlimited conversational AI, emotion breakdown & dream insights.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFFAAAAAC),
                                  fontSize: 13.5.sp,
                                  height: 1.45,
                                ),
                              ),

                                SizedBox(height: 10.h),

                              if (isPremium) ...[
                                Builder(
                                  builder: (context) {
                                    final isTestSub =
                                        kDebugMode && (subData?.isTest == true);
                                    final isAutoRenew =
                                        subData?.autoRenewing ?? true;
                                    final statusRaw =
                                        subData?.status?.toLowerCase() ??
                                            'active';
                                    final isCanceledSub = statusRaw ==
                                            'canceled' ||
                                        (!isAutoRenew && statusRaw != 'pending');

                                    final isYearlySub = (subData?.basePlanId
                                                ?.toString()
                                                .toLowerCase()
                                                .contains('year') ==
                                            true) ||
                                        (subData?.basePlanId
                                                ?.toString()
                                                .toLowerCase()
                                                .contains('annual') ==
                                            true);
                                    final planName = isYearlySub
                                        ? 'Annual Plan'
                                        : 'Monthly Plan';

                                    final String? priceDisplay = () {
                                      if (isYearlySub && yearlyProduct != null) {
                                        return yearlyProduct.price;
                                      }
                                      if (!isYearlySub && monthlyProduct != null) {
                                        return monthlyProduct.price;
                                      }
                                      return null;
                                    }();

                                    String badgeText = 'ACTIVE';
                                    Color badgeColor = const Color(0xFF4CAF50);
                                    Color badgeTextColor = const Color(0xFF81C784);

                                    if (isTestSub) {
                                      badgeText = 'TEST SUBSCRIPTION';
                                      badgeColor = const Color(0xFFFFB74D);
                                      badgeTextColor = const Color(0xFFFFCC80);
                                    } else if (isCanceledSub) {
                                      badgeText = 'CANCELED';
                                      badgeColor = const Color(0xFFFF8A65);
                                      badgeTextColor = const Color(0xFFFFAB91);
                                    } else if (statusRaw == 'pending') {
                                      badgeText = 'PENDING';
                                      badgeColor = const Color(0xFF29B6F6);
                                      badgeTextColor = const Color(0xFF81D4FA);
                                    }

                                    return Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [Color(0xFF1B1438), Color(0xFF0F0B26)],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: const Color(0xFFFFD700).withValues(alpha: 0.35),
                                          width: 1.5,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFFFFD700).withValues(alpha: 0.15),
                                            blurRadius: 20,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.all(8),
                                                      decoration: BoxDecoration(
                                                        color: const Color(0xFFFFD700).withValues(alpha: 0.15),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: const Icon(
                                                        Icons.workspace_premium_rounded,
                                                        color: Color(0xFFFFD700),
                                                        size: 24,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          const Text(
                                                            'DreamTrace AI Premium',
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w800,
                                                            ),
                                                          ),
                                                          Text(
                                                            subData?.productId?.toString() ?? 'dreamtrace_ai_premium',
                                                            style: const TextStyle(
                                                              color: Color(0xFF8888AA),
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: badgeColor.withValues(alpha: 0.2),
                                                  borderRadius: BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: badgeColor,
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      width: 6,
                                                      height: 6,
                                                      decoration: BoxDecoration(
                                                        color: badgeColor,
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Text(
                                                      badgeText,
                                                      style: TextStyle(
                                                        color: badgeTextColor,
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.w800,
                                                        letterSpacing: 0.5,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          const Divider(color: Color(0xFF2A2250), height: 1),
                                          const SizedBox(height: 14),

                                          // Subscription Plan
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Subscription Plan',
                                                style: TextStyle(color: Color(0xFF8888AA), fontSize: 13),
                                              ),
                                              Text(
                                                planName,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),

                                          // Subscription Price Paid
                                          if (priceDisplay != null) ...[
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(
                                                  'Subscription Price',
                                                  style: TextStyle(color: Color(0xFF8888AA), fontSize: 13),
                                                ),
                                                Text(
                                                  priceDisplay,
                                                  style: const TextStyle(
                                                    color: Color(0xFFFFD700),
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                          ],

                                          // Status Banner for Canceled / Test Subscriptions
                                          if (isCanceledSub) ...[
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(
                                                  'Subscription Status',
                                                  style: TextStyle(color: Color(0xFF8888AA), fontSize: 13),
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    'Canceled — access available until ${subData?.expiresAt != null ? _formatDateTime(subData?.expiresAt) : 'expiry'}',
                                                    textAlign: TextAlign.end,
                                                    style: const TextStyle(
                                                      color: Color(0xFFFFAB91),
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                          ],

                                          // Purchase Date
                                          if (subData?.purchaseAt != null) ...[
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(
                                                  'Purchase Date',
                                                  style: TextStyle(color: Color(0xFF8888AA), fontSize: 13),
                                                ),
                                                const SizedBox(width: 8),
                                                Flexible(
                                                  child: Text(
                                                    _formatDateTime(subData?.purchaseAt),
                                                    textAlign: TextAlign.end,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                          ],

                                          // Next Renewal Date or Expiration Date
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                isAutoRenew ? 'Next Renewal Date' : 'Expiration Date',
                                                style: const TextStyle(color: Color(0xFF8888AA), fontSize: 13),
                                              ),
                                              const SizedBox(width: 8),
                                              Flexible(
                                                child: Text(
                                                  _formatDateTime(subData?.expiresAt),
                                                  textAlign: TextAlign.end,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),

                                          // Auto-Renewal Status
                                          if (subData?.autoRenewing != null) ...[
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(
                                                  'Auto-Renewal',
                                                  style: TextStyle(color: Color(0xFF8888AA), fontSize: 13),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  isAutoRenew ? 'Enabled' : 'Disabled',
                                                  style: TextStyle(
                                                    color: isAutoRenew ? const Color(0xFF81C784) : const Color(0xFFFF8A65),
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                          ],

                                          // Test Mode Indicator
                                          if (isTestSub) ...[
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(
                                                  'Environment',
                                                  style: TextStyle(color: Color(0xFF8888AA), fontSize: 13),
                                                ),
                                                const SizedBox(width: 8),
                                                Flexible(
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                    decoration: BoxDecoration(
                                                      color: const Color(0xFFFFCC80).withValues(alpha: 0.15),
                                                      borderRadius: BorderRadius.circular(6),
                                                      border: Border.all(
                                                        color: const Color(0xFFFFCC80).withValues(alpha: 0.4),
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      Platform.isIOS ? 'StoreKit Sandbox' : 'Google Play Tester',
                                                      textAlign: TextAlign.end,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        color: Color(0xFFFFCC80),
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                          ],

                                          // Transaction ID
                                          if (subData?.transactionId != null) ...[
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(
                                                  'Transaction ID',
                                                  style: TextStyle(color: Color(0xFF8888AA), fontSize: 13),
                                                ),
                                                const SizedBox(width: 8),
                                                Flexible(
                                                  child: Text(
                                                    subData?.transactionId?.toString() ?? '',
                                                    textAlign: TextAlign.end,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: const Color(0xFFB4ACFF),
                                                      fontSize: 12.sp,
                                                      fontFamily: 'monospace',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 4.h),
                                          ],

                                          // Payment Platform
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Payment Platform',
                                                style: TextStyle(color: Color(0xFF8888AA), fontSize: 13),
                                              ),
                                              const SizedBox(width: 8),
                                              Flexible(
                                                child: Text(
                                                  _paymentPlatformName,
                                                  textAlign: TextAlign.end,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                  SizedBox(height: 5.h),
                              ],

                              // Features / Benefits Header
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  isPremium ? 'YOUR UNLOCKED BENEFITS' : 'INCLUDED FEATURES',
                                  style: const TextStyle(
                                    color: Color(0xFF8888AA),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.4,
                                  ),
                                ),
                              ),
                                SizedBox(height: 5.h),

                              // Features / Benefits List Card
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 18,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF131325),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: isPremium
                                        ? const Color(0xFFFFD700).withValues(alpha: 0.25)
                                        : const Color(0xFF252545),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  children: List.generate(
                                    benefits.length,
                                    (index) {
                                      final benefitText = benefits[index];
                                      final isLast = index == benefits.length - 1;

                                      return Padding(
                                        padding: EdgeInsets.only(
                                          bottom: isLast ? 0 : 14.h,
                                        ),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 36,
                                              height: 36,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: (isPremium
                                                        ? const Color(0xFFFFD700)
                                                        : const Color(0xFF7B6EF6))
                                                    .withValues(alpha: 0.16),
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: (isPremium
                                                          ? const Color(0xFFFFD700)
                                                          : const Color(0xFF7B6EF6))
                                                      .withValues(alpha: 0.3),
                                                  width: 0.8,
                                                ),
                                              ),
                                              child: Icon(
                                                isPremium
                                                    ? Icons.check_circle_rounded
                                                    : _getBenefitIcon(benefitText),
                                                color: isPremium
                                                    ? const Color(0xFFFFD700)
                                                    : const Color(0xFF9D7FF7),
                                                size: 18,
                                              ),
                                            ),
                                            const SizedBox(width: 14),
                                            Expanded(
                                              child: Text(
                                                benefitText,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: -0.1,
                                                  height: 1.3,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),

                                SizedBox(height: 14.h),

                              if (!isPremium) ...[
                                // Plans Header
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                      Text(
                                      'CHOOSE YOUR PLAN',
                                      style: TextStyle(
                                        color: Color(0xFF6666AA),
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.4,
                                      ),
                                    ),
                                    if (_isLoadingProducts)
                                      const SizedBox(
                                        width: 12,
                                        height: 12,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 1.5,
                                          color: Color(0xFF7B6EF6),
                                        ),
                                      ),
                                  ],
                                ),
                                  SizedBox(height: 10.h),

                                // Render plan options
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _buildPlanCard(
                                    planType: SubscriptionPlanType.monthly,
                                    title: SubscriptionPlanType.monthly.displayName,
                                    price: monthlyPrice,
                                    billingText: SubscriptionPlanType.monthly.billingSubtitle,
                                    badge: SubscriptionPlanType.monthly.badgeText,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _buildPlanCard(
                                    planType: SubscriptionPlanType.yearly,
                                    title: SubscriptionPlanType.yearly.displayName,
                                    price: yearlyPrice,
                                    billingText: SubscriptionPlanType.yearly.billingSubtitle,
                                    badge: SubscriptionPlanType.yearly.badgeText,
                                  ),
                                ),

                                  SizedBox(height: 14.h),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Bottom Action Button & Terms
                    Container(
                      padding: EdgeInsets.fromLTRB(
                        20,
                        12,
                        20,
                        MediaQuery.of(context).padding.bottom > 0
                            ? MediaQuery.of(context).padding.bottom + 3
                            : 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D0D1A),
                        border: Border(
                          top: BorderSide(
                            color: Colors.white.withValues(alpha: 0.06),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 45.h,
                            child: ElevatedButton(
                              onPressed: _isProcessing
                                  ? null
                                  : (isPremium
                                      ? () {
                                          ToastUtil.showShortToast(
                                              'Your Premium subscription is currently active!');
                                        }
                                      : (!isSelectedProductLoaded
                                          ? null
                                          : () => _buySelectedProduct())),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isPremium
                                    ? const Color(0xFF2E7D32)
                                    : const Color(0xFF7B6EF6),
                                disabledBackgroundColor: isPremium
                                    ? const Color(0xFF2E7D32)
                                    : const Color(0xFF3B3860),
                                foregroundColor: Colors.white,
                                disabledForegroundColor: Colors.white70,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                shadowColor: isPremium
                                    ? const Color(0xFF4CAF50)
                                    : const Color(0xFF7B6EF6),
                              ),
                              child: _isProcessing
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          isPremium
                                              ? Icons.check_circle_rounded
                                              : Icons.lock_open_rounded,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                          SizedBox(width: 4.h),
                                        Flexible(
                                          child: Text(
                                            isPremium
                                                ? 'Subscription Active (PRO)'
                                                : (_isLoadingProducts
                                                    ? 'Loading plans...'
                                                    : (!isSelectedProductLoaded
                                                        ? 'Price unavailable'
                                                        : (_selectedPlanType == SubscriptionPlanType.yearly
                                                            ? 'Subscribe Yearly ($yearlyPrice)'
                                                            : 'Subscribe Monthly ($monthlyPrice)'))),
                                            style: const TextStyle(
                                              fontSize: 15.5,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 0.2,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                            SizedBox(height: 1.h),
                          if (isPremium) ...[
                            TextButton(
                              onPressed: () {
                                urlLunch(_manageSubscriptionUrl);
                              },
                              style: TextButton.styleFrom(
                                minimumSize: const Size(0, 32),
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                              ),
                              child: Text(
                                _manageSubscriptionTitle,
                                style: TextStyle(
                                  color: const Color(0xFFFFD700),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ] else ...[
                            TextButton(
                              onPressed: _isProcessing ? null : _restorePurchases,
                              style: TextButton.styleFrom(
                                minimumSize: const Size(0, 32),
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                              ),
                              child: Text(
                                'Restore purchases',
                                style: TextStyle(
                                  color: const Color(0xFF9D7FF7),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                            SizedBox(height: 2.h),
                          Text(
                            _autoRenewDisclosure(isPremium),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF666688),
                              fontSize: 10.5.sp,
                              height: 1.35,
                            ),
                          ),
                            SizedBox(height: 4.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  urlLunch(kTermsAndConditionsUrl);
                                },
                                child: Text(
                                  'Terms of Service',
                                  style: TextStyle(
                                    color: const Color(0xFF9D7FF7),
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                    decorationColor: const Color(0xFF9D7FF7),
                                  ),
                                ),
                              ),
                              Text(
                                '  •  ',
                                style: TextStyle(
                                  color: const Color(0xFF666688),
                                  fontSize: 11.sp,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  urlLunch(kPrivacyPolicyUrl);
                                },
                                child: Text(
                                  'Privacy Policy',
                                  style: TextStyle(
                                    color: const Color(0xFF9D7FF7),
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                    decorationColor: const Color(0xFF9D7FF7),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          UIHelper.verticalSpace(7.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPlanCard({
    required SubscriptionPlanType planType,
    required String title,
    required String price,
    required String billingText,
    String? badge,
  }) {
    final isSelected = _selectedPlanType == planType;

    return GestureDetector(
      onTap: () {
        PLog.info('Plan selected by user: ${planType.displayName} ($title), price: $price');
        setState(() {
          _selectedPlanType = planType;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E173D) : const Color(0xFF131325),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF9D7FF7)
                : const Color(0xFF252545),
            width: isSelected ? 1.8 : 1,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: const Color(0xFF7B6EF6).withValues(alpha: 0.22),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ]
              : null,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              children: [
                // Custom Radio
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF9D7FF7)
                          : const Color(0xFF555577),
                      width: 2,
                    ),
                    color: isSelected
                        ? const Color(0xFF7B6EF6)
                        : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Center(
                    child: Icon(
                      Icons.check_rounded,
                      size: 14,
                      color: Colors.white,
                    ),
                  )
                      : null,
                ),
                const SizedBox(width: 14),

                // Plan info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              price,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: isSelected
                                    ? const Color(0xFFB4ACFF)
                                    : Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        billingText,
                        style: TextStyle(
                          color: const Color(0xFF8888AA),
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            if (badge != null)
              Positioned(
                top: -26,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF8C00), Color(0xFFFF5252)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF5252).withValues(alpha: 0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}