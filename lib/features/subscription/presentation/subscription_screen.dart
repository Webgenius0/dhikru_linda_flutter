import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dhikru_linda_flutter/features/subscription/model/get_subscrition/get_subscription_model.dart';
import 'package:dhikru_linda_flutter/networks/api_acess.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int _selectedPlanIndex = 0;
  bool _isProcessing = false;
  bool _hasSetInitialPlan = false;

  @override
  void initState() {
    super.initState();
    getSubscriptionRxObj.getSubscriptionStatus();
  }

  String _formatDate(dynamic dateStr) {
    if (dateStr == null) return 'N/A';
    try {
      final dt = DateTime.parse(dateStr.toString()).toLocal();
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (_) {
      return dateStr.toString();
    }
  }

  String _formatPlatform(dynamic platform) {
    if (platform == null) return 'App Store';
    final p = platform.toString().toLowerCase();
    if (p == 'apple' || p == 'ios') return 'Apple App Store';
    if (p == 'google' || p == 'android') return 'Google Play Store';
    return platform.toString();
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

  Widget _buildInfoRow({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: const Color(0xFF8888AA),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFF8888AA),
            fontSize: 12.5.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActiveSubscriptionCard(Data subData) {
    String planName = 'Premium Plan';
    if (subData.productId != null && subData.plans != null) {
      final match = subData.plans!.firstWhere(
        (p) => p.id == subData.productId,
        orElse: () => Plan(name: subData.productId.toString()),
      );
      if (match.name != null && match.name!.isNotEmpty) {
        planName = match.name!;
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A1A35),
            Color(0xFF121226),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF7B6EF6).withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7B6EF6).withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7B6EF6), Color(0xFF9D7FF7)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.workspace_premium_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        planName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: Color(0xFF4CAF50),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Active',
                            style: TextStyle(
                              color: const Color(0xFF4CAF50),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF4CAF50).withValues(alpha: 0.4),
                    width: 1,
                  ),
                ),
                child: Text(
                  'PAID',
                  style: TextStyle(
                    color: const Color(0xFF4CAF50),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFF252545), height: 1),
          const SizedBox(height: 14),
          _buildInfoRow(
            label: 'Platform',
            value: _formatPlatform(subData.platform),
            icon: Icons.storefront_rounded,
          ),
          const SizedBox(height: 10),
          _buildInfoRow(
            label: 'Expires / Renews',
            value: _formatDate(subData.expiresAt),
            icon: Icons.calendar_today_rounded,
          ),
        ],
      ),
    );
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
                      final plans = subData?.plans ?? [];
                      final benefits = subData?.benefits ?? [];
                      final isPremium = subData?.isPremium ?? false;

                      // Auto-select yearly plan if available on initial load
                      if (!_hasSetInitialPlan && plans.isNotEmpty) {
                        _hasSetInitialPlan = true;
                        final yearlyIndex = plans.indexWhere(
                          (p) =>
                              p.period?.toLowerCase().contains('year') ?? false,
                        );
                        if (yearlyIndex != -1) {
                          _selectedPlanIndex = yearlyIndex;
                        }
                      }

                      return ValueListenableBuilder<bool>(
                        valueListenable: getSubscriptionRxObj.isLoading,
                        builder: (context, isLoading, child) {
                          if (isLoading && subData == null) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF7B6EF6),
                              ),
                            );
                          }

                          return RefreshIndicator(
                            color: const Color(0xFF7B6EF6),
                            backgroundColor: const Color(0xFF131325),
                            onRefresh: () =>
                                getSubscriptionRxObj.getSubscriptionStatus(),
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
                                      gradient: isPremium
                                          ? const LinearGradient(
                                              colors: [
                                                Color(0xFF2E7D32),
                                                Color(0xFF4CAF50),
                                              ],
                                            )
                                          : const LinearGradient(
                                              colors: [
                                                Color(0xFF7B6EF6),
                                                Color(0xFF9D7FF7),
                                              ],
                                            ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              (isPremium
                                                      ? const Color(0xFF4CAF50)
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
                                              ? Icons.check_circle_rounded
                                              : Icons.star_rounded,
                                          color: Colors.amberAccent,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          isPremium
                                              ? 'ACTIVE SUBSCRIPTION'
                                              : 'PREMIUM ACCESS',
                                          style: const TextStyle(
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
                                  Text(
                                    isPremium
                                        ? 'You are on Premium'
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
                                        ? 'You have full access to all companion & dream interpretation features.'
                                        : 'Gain deeper clarity with unlimited conversational AI, emotion breakdown & dream insights.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: const Color(0xFFAAAAAC),
                                      fontSize: 13.5.sp,
                                      height: 1.45,
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  // If Active Subscription, show Active Plan Details Card
                                  if (isPremium && subData != null) ...[
                                    _buildActiveSubscriptionCard(subData),
                                    const SizedBox(height: 24),
                                  ],

                                  // Features / Benefits Header
                                  if (benefits.isNotEmpty) ...[
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        isPremium
                                            ? 'YOUR PREMIUM BENEFITS'
                                            : 'INCLUDED FEATURES',
                                        style: const TextStyle(
                                          color: Color(0xFF8888AA),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1.4,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    // Features / Benefits List Card from API
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
                                                      color: (isPremium
                                                              ? const Color(
                                                                  0xFF4CAF50,
                                                                )
                                                              : const Color(
                                                                  0xFF7B6EF6,
                                                                ))
                                                          .withValues(
                                                            alpha: 0.16,
                                                          ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                      border: Border.all(
                                                        color: (isPremium
                                                                ? const Color(
                                                                    0xFF4CAF50,
                                                                  )
                                                                : const Color(
                                                                    0xFF7B6EF6,
                                                                  ))
                                                            .withValues(
                                                              alpha: 0.3,
                                                            ),
                                                        width: 0.8,
                                                      ),
                                                    ),
                                                    child: Icon(
                                                      isPremium
                                                          ? Icons
                                                              .check_circle_rounded
                                                          : _getBenefitIcon(
                                                              benefitText,
                                                            ),
                                                      color: isPremium
                                                          ? const Color(
                                                              0xFF66BB6A,
                                                            )
                                                          : const Color(
                                                              0xFF9D7FF7,
                                                            ),
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
                                                        fontWeight:
                                                            FontWeight.w600,
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
                                  ],

                                  // Plans Header & List if not premium
                                  if (!isPremium && plans.isNotEmpty) ...[
                                    const SizedBox(height: 24),
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'CHOOSE YOUR PLAN',
                                        style: TextStyle(
                                          color: Color(0xFF6666AA),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1.4,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 14),

                                    // Render API plans
                                    ...List.generate(plans.length, (index) {
                                      final plan = plans[index];
                                      final periodStr =
                                          plan.period?.toLowerCase() ?? '';
                                      final isYearly = periodStr.contains(
                                        'year',
                                      );

                                      final formattedPrice =
                                          '\$${(plan.price ?? 0).toStringAsFixed(2)} / ${plan.period ?? ''}';

                                      final billingText = isYearly
                                          ? 'Billed annually, best value savings'
                                          : 'Billed monthly, cancel anytime';

                                      // Only yearly plan gets the highlight badge
                                      final String? badge = isYearly
                                          ? 'BEST VALUE • SAVE 33%'
                                          : null;

                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 12,
                                        ),
                                        child: _buildPlanCard(
                                          index: index,
                                          title: plan.name ?? 'Plan',
                                          price: formattedPrice,
                                          billingText: billingText,
                                          badge: badge,
                                        ),
                                      );
                                    }),
                                  ],

                                  const SizedBox(height: 24),
                                ],
                              ),
                            ),
                          );
                        },
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
                  child: StreamBuilder<GetSubscriptionModel>(
                    initialData: getSubscriptionRxObj.dataFetcher.valueOrNull,
                    stream: getSubscriptionRxObj.getSubscriptionStream,
                    builder: (context, snapshot) {
                      final subData = snapshot.data?.data;
                      final plans = subData?.plans ?? [];
                      final isPremium = subData?.isPremium ?? false;

                      String buttonText = 'Unlock Access';
                      if (isPremium) {
                        buttonText = 'Close';
                      } else if (plans.isNotEmpty &&
                          _selectedPlanIndex < plans.length) {
                        final plan = plans[_selectedPlanIndex];
                        buttonText = 'Unlock ${plan.name ?? 'Access'}';
                      } else if (_selectedPlanIndex == 1) {
                        buttonText = 'Unlock Yearly Plan';
                      } else {
                        buttonText = 'Unlock Monthly Plan';
                      }

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: isPremium
                                  ? () => Navigator.maybePop(context)
                                  : _isProcessing
                                  ? null
                                  : () async {
                                      setState(() => _isProcessing = true);
                                      await Future.delayed(
                                        const Duration(milliseconds: 600),
                                      );
                                      if (mounted) {
                                        setState(() => _isProcessing = false);
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isPremium
                                    ? const Color(0xFF2E7D32)
                                    : const Color(0xFF7B6EF6),
                                disabledBackgroundColor: isPremium
                                    ? const Color(0xFF2E7D32)
                                    : const Color(0xFF7B6EF6),
                                foregroundColor: Colors.white,
                                disabledForegroundColor: Colors.white,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          isPremium
                                              ? Icons.check_circle_rounded
                                              : Icons.lock_open_rounded,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          buttonText,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            isPremium
                                ? 'Your subscription is managed through your app store account.'
                                : 'Recurring billing. Cancel anytime in account settings.\nBy subscribing, you agree to our Terms & Privacy Policy.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF666688),
                              fontSize: 10.5.sp,
                              height: 1.3,
                            ),
                          ),
                        ],
                      );
                    },
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
                          Text(
                            price,
                            style: TextStyle(
                              color: isSelected
                                  ? const Color(0xFFB4ACFF)
                                  : Colors.white,
                              fontSize: 14.5.sp,
                              fontWeight: FontWeight.w700,
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
