// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:dhikru_linda_flutter/features/subscription/model/get_subscrition/get_subscription_model.dart';
// import 'package:dhikru_linda_flutter/helpers/toast.dart';
// import 'package:dhikru_linda_flutter/networks/api_acess.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
//
// class SubscriptionScreen extends StatefulWidget {
//   const SubscriptionScreen({super.key});
//
//   @override
//   State<SubscriptionScreen> createState() => _SubscriptionScreenState();
// }
//
// class _SubscriptionScreenState extends State<SubscriptionScreen> {
//   int _selectedPlanIndex = 0;
//   bool _isProcessing = false;
//   bool _hasSetInitialPlan = false;
//
//   final InAppPurchase _appPurchase = InAppPurchase.instance;
//   late StreamSubscription<List<PurchaseDetails>> _purchaseSubscription;
//   List<ProductDetails> _products = [];
//   bool _isStoreAvailable = false;
//   bool _isLoadingProducts = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // 1. Listen to In-App Purchase updates stream
//     final Stream<List<PurchaseDetails>> purchaseUpdated =
//         _appPurchase.purchaseStream;
//     _purchaseSubscription = purchaseUpdated.listen(
//       _listenToPurchaseUpdated,
//       onDone: () => _purchaseSubscription.cancel(),
//       onError: (error) {
//         debugPrint('❌ Billing Stream Error: $error');
//         ToastUtil.showShortToast('Billing error: $error');
//       },
//     );
//
//     // 2. Query Google Play Store products & status
//     getSubscriptionRxObj.getSubscriptionStatus();
//     _initStoreAndLoadProducts();
//   }
//
//   @override
//   void dispose() {
//     _purchaseSubscription.cancel();
//     super.dispose();
//   }
//
//   Future<void> _initStoreAndLoadProducts() async {
//     try {
//       setState(() => _isLoadingProducts = true);
//
//       debugPrint('========== Google Play Billing Check ==========');
//       final available = await _appPurchase.isAvailable();
//       _isStoreAvailable = available;
//       debugPrint('Billing Service Status: $available');
//
//       if (!available) {
//         debugPrint('❌ Google Play Billing is not available.');
//         if (mounted) setState(() => _isLoadingProducts = false);
//         return;
//       }
//
//       const productIds = <String>{'dreamtrace_ai_premium'};
//       debugPrint('================ Loading Subscription Products ================');
//       debugPrint('Product IDs: $productIds');
//
//       final response = await _appPurchase.queryProductDetails(productIds);
//
//       if (response.error != null) {
//         debugPrint('❌ Product Query Failed: ${response.error}');
//       } else {
//         if (mounted) {
//           setState(() {
//             _products = response.productDetails;
//           });
//         }
//         debugPrint('✅ Found ${_products.length} product(s) in Google Play Store.');
//         for (final product in _products) {
//           debugPrint('----------------------------------------');
//           debugPrint('Product ID: ${product.id}');
//           debugPrint('Title: ${product.title}');
//           debugPrint('Price: ${product.price}');
//           debugPrint('Description: ${product.description}');
//         }
//       }
//     } catch (e) {
//       debugPrint('❌ Failed to load store products: $e');
//     } finally {
//       if (mounted) setState(() => _isLoadingProducts = false);
//     }
//   }
//
//   Future<void> _listenToPurchaseUpdated(
//     List<PurchaseDetails> purchaseDetailsList,
//   ) async {
//     for (final purchaseDetails in purchaseDetailsList) {
//       debugPrint(
//         '🛒 Purchase Update: status=${purchaseDetails.status}, id=${purchaseDetails.productID}',
//       );
//
//       if (purchaseDetails.status == PurchaseStatus.pending) {
//         if (mounted) setState(() => _isProcessing = true);
//         ToastUtil.showShortToast('Google Play purchase pending...');
//       } else {
//         if (purchaseDetails.status == PurchaseStatus.error) {
//           if (mounted) setState(() => _isProcessing = false);
//           ToastUtil.showShortToast(
//             purchaseDetails.error?.message ?? 'Purchase failed',
//           );
//         } else if (purchaseDetails.status == PurchaseStatus.purchased ||
//             purchaseDetails.status == PurchaseStatus.restored) {
//           if (mounted) setState(() => _isProcessing = false);
//           ToastUtil.showLongToast(
//             '🎉 Purchase Successful! (${purchaseDetails.productID})',
//           );
//
//           debugPrint('================ PURCHASE DETAILS ================');
//           debugPrint('Product ID: ${purchaseDetails.productID}');
//           debugPrint('Purchase ID: ${purchaseDetails.purchaseID}');
//           debugPrint('Transaction Date: ${purchaseDetails.transactionDate}');
//           debugPrint(
//             'Verification Data: ${purchaseDetails.verificationData.serverVerificationData}',
//           );
//           debugPrint('Source: ${purchaseDetails.verificationData.source}');
//           debugPrint('==================================================');
//
//           // Refresh status from API
//           getSubscriptionRxObj.getSubscriptionStatus();
//         } else if (purchaseDetails.status == PurchaseStatus.canceled) {
//           if (mounted) setState(() => _isProcessing = false);
//           ToastUtil.showShortToast('Purchase was canceled');
//         }
//
//         if (purchaseDetails.pendingCompletePurchase) {
//           await _appPurchase.completePurchase(purchaseDetails);
//         }
//       }
//     }
//   }
//
//   Future<void> _buySelectedProduct() async {
//     if (_isProcessing) return;
//
//     if (!_isStoreAvailable) {
//       ToastUtil.showShortToast('In-App Billing is not available on this device');
//       return;
//     }
//
//     if (_products.isEmpty) {
//       ToastUtil.showShortToast('No subscription products found on Google Play');
//       return;
//     }
//
//     try {
//       setState(() => _isProcessing = true);
//
//       // Select chosen product from Google Play
//       ProductDetails productToBuy;
//       if (_products.length > 1 && _selectedPlanIndex < _products.length) {
//         productToBuy = _products[_selectedPlanIndex];
//       } else {
//         productToBuy = _products.first;
//       }
//
//       debugPrint(
//         '🚀 Launching Google Play purchase: ${productToBuy.id} (${productToBuy.price})',
//       );
//
//       final purchaseParam = PurchaseParam(productDetails: productToBuy);
//       final success = await _appPurchase.buyNonConsumable(
//         purchaseParam: purchaseParam,
//       );
//
//       if (!success) {
//         ToastUtil.showShortToast('Could not launch Google Play Billing sheet');
//         if (mounted) setState(() => _isProcessing = false);
//       }
//     } catch (e) {
//       debugPrint('❌ Error launching purchase: $e');
//       ToastUtil.showShortToast('Purchase error: $e');
//       if (mounted) setState(() => _isProcessing = false);
//     }
//   }
//
//   IconData _getBenefitIcon(String text) {
//     final lower = text.toLowerCase();
//     if (lower.contains('psychological') ||
//         lower.contains('interpretation') ||
//         lower.contains('meaning')) {
//       return Icons.psychology_rounded;
//     } else if (lower.contains('chat') ||
//         lower.contains('companion') ||
//         lower.contains('conversation') ||
//         lower.contains('conversational')) {
//       return Icons.chat_bubble_outline_rounded;
//     } else if (lower.contains('subconscious') ||
//         lower.contains('insight') ||
//         lower.contains('symbol') ||
//         lower.contains('detection') ||
//         lower.contains('emotion')) {
//       return Icons.insights_rounded;
//     } else if (lower.contains('unlimited') ||
//         lower.contains('dream') ||
//         lower.contains('log')) {
//       return Icons.all_inclusive_rounded;
//     } else if (lower.contains('meditation') ||
//         lower.contains('care') ||
//         lower.contains('reflection')) {
//       return Icons.spa_outlined;
//     } else {
//       return Icons.auto_awesome_rounded;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0D0D1A),
//       body: Stack(
//         children: [
//           // Background ambient gradient glow
//           Positioned(
//             top: -100,
//             left: -50,
//             right: -50,
//             child: Container(
//               height: 380,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 gradient: RadialGradient(
//                   colors: [
//                     const Color(0xFF7B6EF6).withValues(alpha: 0.28),
//                     const Color(0xFF9D7FF7).withValues(alpha: 0.12),
//                     Colors.transparent,
//                   ],
//                   stops: const [0.0, 0.45, 1.0],
//                 ),
//               ),
//             ),
//           ),
//
//           SafeArea(
//             bottom: false,
//             child: Column(
//               children: [
//                 // Top Navigation Bar
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 8,
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       GestureDetector(
//                         onTap: () => Navigator.maybePop(context),
//                         child: Container(
//                           width: 36,
//                           height: 36,
//                           alignment: Alignment.center,
//                           decoration: BoxDecoration(
//                             color: Colors.white.withValues(alpha: 0.1),
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                               color: Colors.white.withValues(alpha: 0.15),
//                               width: 1,
//                             ),
//                           ),
//                           child: const Icon(
//                             Icons.close_rounded,
//                             color: Colors.white,
//                             size: 18,
//                           ),
//                         ),
//                       ),
//                       // Store connection indicator badge
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 10,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: _isStoreAvailable
//                               ? const Color(0xFF4CAF50).withValues(alpha: 0.15)
//                               : Colors.amber.withValues(alpha: 0.15),
//                           borderRadius: BorderRadius.circular(16),
//                           border: Border.all(
//                             color: _isStoreAvailable
//                                 ? const Color(0xFF4CAF50).withValues(alpha: 0.4)
//                                 : Colors.amber.withValues(alpha: 0.4),
//                             width: 1,
//                           ),
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Container(
//                               width: 6,
//                               height: 6,
//                               decoration: BoxDecoration(
//                                 color: _isStoreAvailable
//                                     ? const Color(0xFF4CAF50)
//                                     : Colors.amber,
//                                 shape: BoxShape.circle,
//                               ),
//                             ),
//                             const SizedBox(width: 5),
//                             Text(
//                               _isStoreAvailable ? 'Store Ready' : 'Connecting...',
//                               style: TextStyle(
//                                 color: _isStoreAvailable
//                                     ? const Color(0xFF81C784)
//                                     : Colors.amber,
//                                 fontSize: 10.5.sp,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 // Main Scrollable Content
//                 Expanded(
//                   child: StreamBuilder<GetSubscriptionModel>(
//                     initialData: getSubscriptionRxObj.dataFetcher.valueOrNull,
//                     stream: getSubscriptionRxObj.getSubscriptionStream,
//                     builder: (context, snapshot) {
//                       final subData = snapshot.data?.data;
//                       final apiPlans = subData?.plans ?? [];
//                       final benefits = (subData?.benefits?.isNotEmpty ?? false)
//                           ? subData!.benefits!
//                           : [
//                               "Detailed Psychological Interpretation",
//                               "Conversational AI Chat Companion",
//                               "Subconscious Insights & Symbol Detection",
//                               "Unlimited Dreams Log",
//                             ];
//
//                       // Build plan display items from Google Play products or API plans
//                       final List<Map<String, dynamic>> displayPlans = [];
//                       if (_products.isNotEmpty) {
//                         for (int i = 0; i < _products.length; i++) {
//                           final p = _products[i];
//                           final isYearly = i == 1 ||
//                               p.title.toLowerCase().contains('year') ||
//                               p.description.toLowerCase().contains('year');
//                           displayPlans.add({
//                             'title': isYearly ? 'Yearly Plan' : 'Monthly Plan',
//                             'price': p.price,
//                             'billingText': isYearly
//                                 ? 'Billed annually, best value savings'
//                                 : 'Billed monthly, cancel anytime',
//                             'badge': isYearly ? 'BEST VALUE • SAVE 33%' : null,
//                             'product': p,
//                           });
//                         }
//                       } else if (apiPlans.isNotEmpty) {
//                         for (int i = 0; i < apiPlans.length; i++) {
//                           final plan = apiPlans[i];
//                           final isYearly =
//                               plan.period?.toLowerCase().contains('year') ??
//                               false;
//                           displayPlans.add({
//                             'title': plan.name ??
//                                 (isYearly ? 'Yearly Plan' : 'Monthly Plan'),
//                             'price':
//                                 '\$${(plan.price ?? 0).toStringAsFixed(2)} / ${plan.period ?? ''}',
//                             'billingText': isYearly
//                                 ? 'Billed annually, best value savings'
//                                 : 'Billed monthly, cancel anytime',
//                             'badge': isYearly ? 'BEST VALUE • SAVE 33%' : null,
//                             'product': null,
//                           });
//                         }
//                       } else {
//                         displayPlans.add({
//                           'title': 'Monthly Plan',
//                           'price': '\$4.99 / month',
//                           'billingText': 'Billed monthly, cancel anytime',
//                           'badge': null,
//                           'product': null,
//                         });
//                         displayPlans.add({
//                           'title': 'Yearly Plan',
//                           'price': '\$35.99 / year',
//                           'billingText': 'Billed annually, best value savings',
//                           'badge': 'BEST VALUE • SAVE 33%',
//                           'product': null,
//                         });
//                       }
//
//                       // Auto-select yearly plan if available on initial load
//                       if (!_hasSetInitialPlan && displayPlans.length > 1) {
//                         _hasSetInitialPlan = true;
//                         _selectedPlanIndex = 1;
//                       }
//
//                       return RefreshIndicator(
//                         color: const Color(0xFF7B6EF6),
//                         backgroundColor: const Color(0xFF131325),
//                         onRefresh: () async {
//                           await Future.wait([
//                             getSubscriptionRxObj.getSubscriptionStatus(),
//                             _initStoreAndLoadProducts(),
//                           ]);
//                         },
//                         child: SingleChildScrollView(
//                           physics: const BouncingScrollPhysics(
//                             parent: AlwaysScrollableScrollPhysics(),
//                           ),
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 22,
//                           ),
//                           child: Column(
//                             children: [
//                               const SizedBox(height: 8),
//
//                               // Header Badge
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 14,
//                                   vertical: 6,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   gradient: const LinearGradient(
//                                     colors: [
//                                       Color(0xFF7B6EF6),
//                                       Color(0xFF9D7FF7),
//                                     ],
//                                   ),
//                                   borderRadius: BorderRadius.circular(20),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: const Color(0xFF7B6EF6)
//                                           .withValues(alpha: 0.4),
//                                       blurRadius: 12,
//                                       offset: const Offset(0, 3),
//                                     ),
//                                   ],
//                                 ),
//                                 child: const Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Icon(
//                                       Icons.star_rounded,
//                                       color: Colors.amberAccent,
//                                       size: 16,
//                                     ),
//                                     SizedBox(width: 6),
//                                     Text(
//                                       'PREMIUM ACCESS',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 11,
//                                         fontWeight: FontWeight.w800,
//                                         letterSpacing: 1.2,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//
//                               const SizedBox(height: 14),
//
//                               // Title & Subtitle
//                               const Text(
//                                 'Unlock Full AI Potential',
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 26,
//                                   fontWeight: FontWeight.w800,
//                                   letterSpacing: -0.5,
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 'Gain deeper clarity with unlimited conversational AI, emotion breakdown & dream insights.',
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   color: const Color(0xFFAAAAAC),
//                                   fontSize: 13.5.sp,
//                                   height: 1.45,
//                                 ),
//                               ),
//
//                               const SizedBox(height: 20),
//
//                               // Features / Benefits Header
//                               const Align(
//                                 alignment: Alignment.centerLeft,
//                                 child: Text(
//                                   'INCLUDED FEATURES',
//                                   style: TextStyle(
//                                     color: Color(0xFF8888AA),
//                                     fontSize: 11,
//                                     fontWeight: FontWeight.w700,
//                                     letterSpacing: 1.4,
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 12),
//
//                               // Features / Benefits List Card
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 16,
//                                   vertical: 18,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xFF131325),
//                                   borderRadius: BorderRadius.circular(18),
//                                   border: Border.all(
//                                     color: const Color(0xFF252545),
//                                     width: 1,
//                                   ),
//                                 ),
//                                 child: Column(
//                                   children: List.generate(
//                                     benefits.length,
//                                     (index) {
//                                       final benefitText = benefits[index];
//                                       final isLast =
//                                           index == benefits.length - 1;
//
//                                       return Padding(
//                                         padding: EdgeInsets.only(
//                                           bottom: isLast ? 0 : 14.h,
//                                         ),
//                                         child: Row(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.center,
//                                           children: [
//                                             Container(
//                                               width: 36,
//                                               height: 36,
//                                               alignment: Alignment.center,
//                                               decoration: BoxDecoration(
//                                                 color: const Color(0xFF7B6EF6)
//                                                     .withValues(alpha: 0.16),
//                                                 borderRadius:
//                                                     BorderRadius.circular(10),
//                                                 border: Border.all(
//                                                   color: const Color(0xFF7B6EF6)
//                                                       .withValues(alpha: 0.3),
//                                                   width: 0.8,
//                                                 ),
//                                               ),
//                                               child: Icon(
//                                                 _getBenefitIcon(benefitText),
//                                                 color: const Color(0xFF9D7FF7),
//                                                 size: 18,
//                                               ),
//                                             ),
//                                             const SizedBox(width: 14),
//                                             Expanded(
//                                               child: Text(
//                                                 benefitText,
//                                                 style: TextStyle(
//                                                   color: Colors.white,
//                                                   fontSize: 14.sp,
//                                                   fontWeight: FontWeight.w600,
//                                                   letterSpacing: -0.1,
//                                                   height: 1.3,
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ),
//
//                               const SizedBox(height: 24),
//
//                               // Plans Header
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   const Text(
//                                     'CHOOSE YOUR PLAN',
//                                     style: TextStyle(
//                                       color: Color(0xFF6666AA),
//                                       fontSize: 11,
//                                       fontWeight: FontWeight.w700,
//                                       letterSpacing: 1.4,
//                                     ),
//                                   ),
//                                   if (_isLoadingProducts)
//                                     const SizedBox(
//                                       width: 12,
//                                       height: 12,
//                                       child: CircularProgressIndicator(
//                                         strokeWidth: 1.5,
//                                         color: Color(0xFF7B6EF6),
//                                       ),
//                                     ),
//                                 ],
//                               ),
//                               const SizedBox(height: 14),
//
//                               // Render plan options
//                               ...List.generate(displayPlans.length, (index) {
//                                 final plan = displayPlans[index];
//                                 return Padding(
//                                   padding: const EdgeInsets.only(
//                                     bottom: 12,
//                                   ),
//                                   child: _buildPlanCard(
//                                     index: index,
//                                     title: plan['title'] as String,
//                                     price: plan['price'] as String,
//                                     billingText: plan['billingText'] as String,
//                                     badge: plan['badge'] as String?,
//                                   ),
//                                 );
//                               }),
//
//                               const SizedBox(height: 24),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//
//                 // Bottom Action Button & Terms
//                 Container(
//                   padding: EdgeInsets.fromLTRB(
//                     20,
//                     12,
//                     20,
//                     MediaQuery.of(context).padding.bottom > 0
//                         ? MediaQuery.of(context).padding.bottom + 8
//                         : 16,
//                   ),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF0D0D1A),
//                     border: Border(
//                       top: BorderSide(
//                         color: Colors.white.withValues(alpha: 0.06),
//                         width: 1,
//                       ),
//                     ),
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       SizedBox(
//                         width: double.infinity,
//                         height: 52,
//                         child: ElevatedButton(
//                           onPressed: _isProcessing ? null : () => _buySelectedProduct(),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF7B6EF6),
//                             disabledBackgroundColor: const Color(0xFF7B6EF6),
//                             foregroundColor: Colors.white,
//                             disabledForegroundColor: Colors.white,
//                             elevation: 0,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(14),
//                             ),
//                             shadowColor: const Color(0xFF7B6EF6),
//                           ),
//                           child: _isProcessing
//                               ? const SizedBox(
//                                   width: 20,
//                                   height: 20,
//                                   child: CircularProgressIndicator(
//                                     color: Colors.white,
//                                     strokeWidth: 2,
//                                   ),
//                                 )
//                               : Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     const Icon(
//                                       Icons.lock_open_rounded,
//                                       size: 18,
//                                       color: Colors.white,
//                                     ),
//                                     const SizedBox(width: 8),
//                                     Flexible(
//                                       child: Text(
//                                         _products.isNotEmpty &&
//                                                 _selectedPlanIndex <
//                                                     _products.length
//                                             ? 'Subscribe (${_products[_selectedPlanIndex].price})'
//                                             : _selectedPlanIndex == 1
//                                                 ? 'Subscribe Yearly'
//                                                 : 'Subscribe Monthly',
//                                         style: const TextStyle(
//                                           fontSize: 15.5,
//                                           fontWeight: FontWeight.w700,
//                                           letterSpacing: 0.2,
//                                         ),
//                                         overflow: TextOverflow.ellipsis,
//                                         maxLines: 1,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         'Google Play Billing. Cancel anytime in Google Play Store settings.\nBy subscribing, you agree to our Terms & Privacy Policy.',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: const Color(0xFF666688),
//                           fontSize: 10.5.sp,
//                           height: 1.3,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPlanCard({
//     required int index,
//     required String title,
//     required String price,
//     required String billingText,
//     String? badge,
//   }) {
//     final isSelected = _selectedPlanIndex == index;
//
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _selectedPlanIndex = index;
//         });
//       },
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//         decoration: BoxDecoration(
//           color: isSelected ? const Color(0xFF1E173D) : const Color(0xFF131325),
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: isSelected
//                 ? const Color(0xFF9D7FF7)
//                 : const Color(0xFF252545),
//             width: isSelected ? 1.8 : 1,
//           ),
//           boxShadow: isSelected
//               ? [
//                   BoxShadow(
//                     color: const Color(0xFF7B6EF6).withValues(alpha: 0.22),
//                     blurRadius: 14,
//                     offset: const Offset(0, 4),
//                   ),
//                 ]
//               : null,
//         ),
//         child: Stack(
//           clipBehavior: Clip.none,
//           children: [
//             Row(
//               children: [
//                 // Custom Radio
//                 Container(
//                   width: 22,
//                   height: 22,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(
//                       color: isSelected
//                           ? const Color(0xFF9D7FF7)
//                           : const Color(0xFF555577),
//                       width: 2,
//                     ),
//                     color: isSelected
//                         ? const Color(0xFF7B6EF6)
//                         : Colors.transparent,
//                   ),
//                   child: isSelected
//                       ? const Center(
//                           child: Icon(
//                             Icons.check_rounded,
//                             size: 14,
//                             color: Colors.white,
//                           ),
//                         )
//                       : null,
//                 ),
//                 const SizedBox(width: 14),
//
//                 // Plan info
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             title,
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 15.sp,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                           Flexible(
//                             child: Text(
//                               price,
//                               textAlign: TextAlign.right,
//                               style: TextStyle(
//                                 color: isSelected
//                                     ? const Color(0xFFB4ACFF)
//                                     : Colors.white,
//                                 fontSize: 14.sp,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         billingText,
//                         style: TextStyle(
//                           color: const Color(0xFF8888AA),
//                           fontSize: 12.sp,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//
//             if (badge != null)
//               Positioned(
//                 top: -26,
//                 right: 0,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 10,
//                     vertical: 3,
//                   ),
//                   decoration: BoxDecoration(
//                     gradient: const LinearGradient(
//                       colors: [Color(0xFFFF8C00), Color(0xFFFF5252)],
//                     ),
//                     borderRadius: BorderRadius.circular(10),
//                     boxShadow: [
//                       BoxShadow(
//                         color: const Color(0xFFFF5252).withValues(alpha: 0.35),
//                         blurRadius: 8,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Text(
//                     badge,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 9.5,
//                       fontWeight: FontWeight.w800,
//                       letterSpacing: 0.6,
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'dart:async';
import 'package:dhikru_linda_flutter/features/subscription/presentation/services/perces_verficy_servis_screen.dart';
 import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dhikru_linda_flutter/features/subscription/model/get_subscrition/get_subscription_model.dart';
import 'package:dhikru_linda_flutter/helpers/toast.dart';
import 'package:dhikru_linda_flutter/networks/api_acess.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'log/presces_log.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int _selectedPlanIndex = 0;
  bool _isProcessing = false;
  bool _hasSetInitialPlan = false;

  final InAppPurchase _appPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _purchaseSubscription;
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
        ToastUtil.showShortToast('Billing error: $error');
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
  // TODO: আপনার app যেখান থেকে login token পড়ে (SharedPreferences / secure
  // storage / আপনার existing helper), সেটা এখানে return করুন।
  // যেমন: return await SharedPreferences.getInstance().then((p) => p.getString('token'));
  Future<String?> _getAuthToken() async {
    return null;
  }

  // ---------------------------------------------------------------------------
  // STORE + PRODUCTS
  // ---------------------------------------------------------------------------
  Future<void> _initStoreAndLoadProducts() async {
    PLog.section('GOOGLE PLAY STORE CHECK');
    try {
      if (mounted) setState(() => _isLoadingProducts = true);

      PLog.step('Checking if billing service is available');
      final available = await _appPurchase.isAvailable();
      if (mounted) setState(() => _isStoreAvailable = available);

      if (!available) {
        PLog.error(
          'Google Play Billing NOT available. Possible reasons: emulator without '
              'Play Store, old Play Store version, no Google account, or app not '
              'installed from a Play-enabled device.',
        );
        if (mounted) setState(() => _isLoadingProducts = false);
        return;
      }
      PLog.success('Billing service available');

      const productIds = <String>{'dreamtrace_ai_premium'};
      PLog.step('Querying product details: $productIds');

      final response = await _appPurchase.queryProductDetails(productIds);

      if (response.error != null) {
        PLog.error('Product query failed: ${response.error}');
      } else {
        if (mounted) {
          setState(() {
            _products = response.productDetails;
          });
        }
        PLog.success('Found ${_products.length} product(s) in Google Play');

        if (response.notFoundIDs.isNotEmpty) {
          PLog.warn(
            'Product IDs NOT found in Play Console: ${response.notFoundIDs}. '
                'Check product status is Active and app is published to a testing track.',
          );
        }

        for (final product in _products) {
          PLog.kv('Product', {
            'ID': product.id,
            'Title': product.title,
            'Price': product.price,
            'Raw price': product.rawPrice,
            'Currency': product.currencyCode,
            'Description': product.description,
          });
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
          ToastUtil.showShortToast('Google Play purchase pending...');
          break;

        case PurchaseStatus.error:
          PLog.error(
            'Purchase ERROR: code=${purchaseDetails.error?.code}, '
                'message=${purchaseDetails.error?.message}, '
                'details=${purchaseDetails.error?.details}',
          );
          if (mounted) setState(() => _isProcessing = false);
          ToastUtil.showShortToast(
            purchaseDetails.error?.message ?? 'Purchase failed',
          );
          if (purchaseDetails.pendingCompletePurchase) {
            PLog.step('Calling completePurchase for failed purchase');
            await _appPurchase.completePurchase(purchaseDetails);
          }
          break;

        case PurchaseStatus.canceled:
          PLog.warn('Purchase CANCELED by user');
          if (mounted) setState(() => _isProcessing = false);
          ToastUtil.showShortToast('Purchase was canceled');
          if (purchaseDetails.pendingCompletePurchase) {
            PLog.step('Calling completePurchase for canceled purchase');
            await _appPurchase.completePurchase(purchaseDetails);
          }
          break;

        case PurchaseStatus.purchased:
          PLog.success('Google Play says: PURCHASED');
          await _handleSuccessfulPurchase(purchaseDetails);
          break;

        case PurchaseStatus.restored:
          PLog.success('Google Play says: RESTORED');
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
      final verified = await _verifyPurchaseWithBackend(purchase);

      if (verified) {
        PLog.success('2/4 Backend verification PASSED');

        // Complete/acknowledge ONLY after the backend confirmed it
        if (purchase.pendingCompletePurchase) {
          PLog.step('3/4 Calling completePurchase (acknowledge to Google Play)');
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
      } else {
        // completePurchase NOT called: Play will deliver this purchase again
        // on next app start / restore, so verification can be retried.
        PLog.error(
          'Backend verification FAILED. completePurchase was NOT called, so '
              'this purchase can be retried (reopen app or tap Restore). '
              'NOTE: Google auto-refunds unacknowledged purchases after 3 days.',
        );
        ToastUtil.showLongToast(
          'Purchase verification failed. Please tap "Restore purchases" or try again.',
        );
      }
    } catch (e, st) {
      PLog.error('Purchase handling crashed', e, st);
      ToastUtil.showShortToast('Something went wrong. Please try again.');
    } finally {
      _verifyingKeys.remove(key);
      if (mounted) setState(() => _isProcessing = false);
      PLog.info('Purchase handling finished in ${total.elapsedMilliseconds} ms');
    }
  }

  Future<bool> _verifyPurchaseWithBackend(PurchaseDetails purchase) async {
    PLog.step('Reading auth token');
    final authToken = await _getAuthToken();

    if (authToken == null || authToken.isEmpty) {
      PLog.error(
        'Auth token is missing → cannot verify. Fix _getAuthToken() so it '
            'returns the logged-in user\'s token.',
      );
      return false;
    }
    PLog.success('Auth token found: ${PLog.mask(authToken)}');

    return PurchaseVerifyService.verifyGooglePurchase(
      authToken: authToken,
      productId: purchase.productID,
      purchaseToken: purchase.verificationData.serverVerificationData,
      purchaseId: purchase.purchaseID,
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
      ToastUtil.showShortToast('Restore failed: $e');
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
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
        'Cannot buy: no products loaded from Google Play. Check product ID '
            'and that the subscription is Active in Play Console.',
      );
      ToastUtil.showShortToast('No subscription products found on Google Play');
      return;
    }

    try {
      setState(() => _isProcessing = true);

      // Select chosen product from Google Play
      ProductDetails productToBuy;
      if (_products.length > 1 && _selectedPlanIndex < _products.length) {
        productToBuy = _products[_selectedPlanIndex];
      } else {
        productToBuy = _products.first;
      }

      PLog.kv('Launching purchase', {
        'Selected index': _selectedPlanIndex,
        'Product ID': productToBuy.id,
        'Price': productToBuy.price,
      });

      final purchaseParam = PurchaseParam(productDetails: productToBuy);
      final success = await _appPurchase.buyNonConsumable(
        purchaseParam: purchaseParam,
      );

      if (!success) {
        PLog.error('buyNonConsumable returned false → Google Play sheet not launched');
        ToastUtil.showShortToast('Could not launch Google Play Billing sheet');
        if (mounted) setState(() => _isProcessing = false);
      } else {
        PLog.success('Google Play billing sheet launched, waiting for result in purchaseStream');
      }
    } catch (e, st) {
      PLog.error('Error launching purchase', e, st);
      ToastUtil.showShortToast('Purchase error: $e');
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
      body: Stack(
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
                    const Color(0xFF7B6EF6).withValues(alpha: 0.28),
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
                      // Store connection indicator badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _isStoreAvailable
                              ? const Color(0xFF4CAF50).withValues(alpha: 0.15)
                              : Colors.amber.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _isStoreAvailable
                                ? const Color(0xFF4CAF50).withValues(alpha: 0.4)
                                : Colors.amber.withValues(alpha: 0.4),
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
                                color: _isStoreAvailable
                                    ? const Color(0xFF4CAF50)
                                    : Colors.amber,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              _isStoreAvailable ? 'Store Ready' : 'Connecting...',
                              style: TextStyle(
                                color: _isStoreAvailable
                                    ? const Color(0xFF81C784)
                                    : Colors.amber,
                                fontSize: 10.5.sp,
                                fontWeight: FontWeight.w600,
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
                  child: StreamBuilder<GetSubscriptionModel>(
                    initialData: getSubscriptionRxObj.dataFetcher.valueOrNull,
                    stream: getSubscriptionRxObj.getSubscriptionStream,
                    builder: (context, snapshot) {
                      final subData = snapshot.data?.data;
                      final apiPlans = subData?.plans ?? [];
                      final benefits = (subData?.benefits?.isNotEmpty ?? false)
                          ? subData!.benefits!
                          : [
                        "Detailed Psychological Interpretation",
                        "Conversational AI Chat Companion",
                        "Subconscious Insights & Symbol Detection",
                        "Unlimited Dreams Log",
                      ];

                      // Build plan display items from Google Play products or API plans
                      final List<Map<String, dynamic>> displayPlans = [];
                      if (_products.isNotEmpty) {
                        for (int i = 0; i < _products.length; i++) {
                          final p = _products[i];
                          final isYearly = i == 1 ||
                              p.title.toLowerCase().contains('year') ||
                              p.description.toLowerCase().contains('year');
                          displayPlans.add({
                            'title': isYearly ? 'Yearly Plan' : 'Monthly Plan',
                            'price': p.price,
                            'billingText': isYearly
                                ? 'Billed annually, best value savings'
                                : 'Billed monthly, cancel anytime',
                            'badge': isYearly ? 'BEST VALUE • SAVE 33%' : null,
                            'product': p,
                          });
                        }
                      } else if (apiPlans.isNotEmpty) {
                        for (int i = 0; i < apiPlans.length; i++) {
                          final plan = apiPlans[i];
                          final isYearly =
                              plan.period?.toLowerCase().contains('year') ??
                                  false;
                          displayPlans.add({
                            'title': plan.name ??
                                (isYearly ? 'Yearly Plan' : 'Monthly Plan'),
                            'price':
                            '\$${(plan.price ?? 0).toStringAsFixed(2)} / ${plan.period ?? ''}',
                            'billingText': isYearly
                                ? 'Billed annually, best value savings'
                                : 'Billed monthly, cancel anytime',
                            'badge': isYearly ? 'BEST VALUE • SAVE 33%' : null,
                            'product': null,
                          });
                        }
                      } else {
                        displayPlans.add({
                          'title': 'Monthly Plan',
                          'price': '\$4.99 / month',
                          'billingText': 'Billed monthly, cancel anytime',
                          'badge': null,
                          'product': null,
                        });
                        displayPlans.add({
                          'title': 'Yearly Plan',
                          'price': '\$35.99 / year',
                          'billingText': 'Billed annually, best value savings',
                          'badge': 'BEST VALUE • SAVE 33%',
                          'product': null,
                        });
                      }

                      // Auto-select yearly plan if available on initial load
                      if (!_hasSetInitialPlan && displayPlans.length > 1) {
                        _hasSetInitialPlan = true;
                        _selectedPlanIndex = 1;
                        PLog.info('Auto-selected plan index 1 (yearly)');
                      }

                      return RefreshIndicator(
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
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF7B6EF6),
                                      Color(0xFF9D7FF7),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF7B6EF6)
                                          .withValues(alpha: 0.4),
                                      blurRadius: 12,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.star_rounded,
                                      color: Colors.amberAccent,
                                      size: 16,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'PREMIUM ACCESS',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 14),

                              // Title & Subtitle
                              const Text(
                                'Unlock Full AI Potential',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Gain deeper clarity with unlimited conversational AI, emotion breakdown & dream insights.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFFAAAAAC),
                                  fontSize: 13.5.sp,
                                  height: 1.45,
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Features / Benefits Header
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'INCLUDED FEATURES',
                                  style: TextStyle(
                                    color: Color(0xFF8888AA),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.4,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),

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
                                    color: const Color(0xFF252545),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  children: List.generate(
                                    benefits.length,
                                        (index) {
                                      final benefitText = benefits[index];
                                      final isLast =
                                          index == benefits.length - 1;

                                      return Padding(
                                        padding: EdgeInsets.only(
                                          bottom: isLast ? 0 : 14.h,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 36,
                                              height: 36,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF7B6EF6)
                                                    .withValues(alpha: 0.16),
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: const Color(0xFF7B6EF6)
                                                      .withValues(alpha: 0.3),
                                                  width: 0.8,
                                                ),
                                              ),
                                              child: Icon(
                                                _getBenefitIcon(benefitText),
                                                color: const Color(0xFF9D7FF7),
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

                              const SizedBox(height: 24),

                              // Plans Header
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'CHOOSE YOUR PLAN',
                                    style: TextStyle(
                                      color: Color(0xFF6666AA),
                                      fontSize: 11,
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
                              const SizedBox(height: 14),

                              // Render plan options
                              ...List.generate(displayPlans.length, (index) {
                                final plan = displayPlans[index];
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 12,
                                  ),
                                  child: _buildPlanCard(
                                    index: index,
                                    title: plan['title'] as String,
                                    price: plan['price'] as String,
                                    billingText: plan['billingText'] as String,
                                    badge: plan['badge'] as String?,
                                  ),
                                );
                              }),

                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Bottom Action Button & Terms
                Container(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    12,
                    20,
                    MediaQuery.of(context).padding.bottom > 0
                        ? MediaQuery.of(context).padding.bottom + 8
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
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isProcessing ? null : () => _buySelectedProduct(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7B6EF6),
                            disabledBackgroundColor: const Color(0xFF7B6EF6),
                            foregroundColor: Colors.white,
                            disabledForegroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            shadowColor: const Color(0xFF7B6EF6),
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
                              const Icon(
                                Icons.lock_open_rounded,
                                size: 18,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  _products.isNotEmpty &&
                                      _selectedPlanIndex <
                                          _products.length
                                      ? 'Subscribe (${_products[_selectedPlanIndex].price})'
                                      : _selectedPlanIndex == 1
                                      ? 'Subscribe Yearly'
                                      : 'Subscribe Monthly',
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
                      const SizedBox(height: 6),
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
                      const SizedBox(height: 4),
                      Text(
                        'Google Play Billing. Cancel anytime in Google Play Store settings.\nBy subscribing, you agree to our Terms & Privacy Policy.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF666688),
                          fontSize: 10.5.sp,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard({
    required int index,
    required String title,
    required String price,
    required String billingText,
    String? badge,
  }) {
    final isSelected = _selectedPlanIndex == index;

    return GestureDetector(
      onTap: () {
        PLog.info('Plan selected: index=$index, title=$title, price=$price');
        setState(() {
          _selectedPlanIndex = index;
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