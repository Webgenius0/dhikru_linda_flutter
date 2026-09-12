import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dhikru_linda_flutter/helpers/toast.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int _selectedPlanIndex = 0; // 0: Annual, 1: Monthly
  bool _isProcessing = false;

  final List<Map<String, dynamic>> _features = const [
    {
      'icon': Icons.auto_awesome_rounded,
      'title': 'Unlimited Dream Interpretations',
      'desc': 'Log and interpret unlimited dreams without daily caps.',
    },
    {
      'icon': Icons.chat_bubble_outline_rounded,
      'title': 'Conversational AI Companion',
      'desc': 'Interact, ask questions, and converse deeply about your dreams.',
    },
    {
      'icon': Icons.insights_rounded,
      'title': 'Deep Emotional Landscape',
      'desc': 'Uncover hidden subconscious emotions and psychological patterns.',
    },
    {
      'icon': Icons.spa_outlined,
      'title': 'Personalized Care & Meditations',
      'desc': 'Tailored reflection, breathing exercises, and journaling prompts.',
    },
    {
      'icon': Icons.all_inclusive_rounded,
      'title': 'Symbol Analysis & Pattern Tracking',
      'desc': 'Comprehensive tracking of recurring symbols, themes, and motifs.',
    },
  ];

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
            child: Column(
              children: [
                // Top Navigation Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.maybePop(context),
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.12),
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
                      GestureDetector(
                        onTap: () {
                          ToastUtil.showShortToast("Restoring previous purchases...");
                        },
                        child: Text(
                          'Restore',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 22),
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
                              colors: [Color(0xFF7B6EF6), Color(0xFF9D7FF7)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF7B6EF6).withValues(alpha: 0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
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

                        const SizedBox(height: 24),

                        // Features List Card
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
                            children: _features
                                .map(
                                  (f) => Padding(
                                    padding: const EdgeInsets.only(bottom: 14),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(7),
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
                                            f['icon'] as IconData,
                                            color: const Color(0xFF9D7FF7),
                                            size: 16,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                f['title'] as String,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                f['desc'] as String,
                                                style: const TextStyle(
                                                  color: Color(0xFF8888AA),
                                                  fontSize: 12,
                                                  height: 1.35,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Plans Header
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
                        const SizedBox(height: 12),

                        // Plan 1: Annual (Best Value)
                        _buildPlanCard(
                          index: 0,
                          title: 'Annual Plan',
                          price: '\$4.99 / month',
                          billingText: 'Billed annually at \$59.99/year',
                          badge: 'BEST VALUE • SAVE 50%',
                          isPopular: true,
                        ),

                        const SizedBox(height: 12),

                        // Plan 2: Monthly
                        _buildPlanCard(
                          index: 1,
                          title: 'Monthly Plan',
                          price: '\$9.99 / month',
                          billingText: 'Billed monthly, cancel anytime',
                          badge: null,
                          isPopular: false,
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                // Bottom Action Button & Terms
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
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
                          onPressed: _isProcessing
                              ? null
                              : () async {
                                  setState(() => _isProcessing = true);
                                  await Future.delayed(
                                    const Duration(milliseconds: 1000),
                                  );
                                  if (mounted) {
                                    setState(() => _isProcessing = false);
                                    ToastUtil.showShortToast(
                                      "Subscription initiated! Payment gateway connecting...",
                                      forceShow: true,
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7B6EF6),
                            foregroundColor: Colors.white,
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
                                  children: [
                                    const Icon(
                                      Icons.lock_open_rounded,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _selectedPlanIndex == 0
                                          ? 'Unlock Annual Access'
                                          : 'Unlock Monthly Access',
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
                        'Recurring billing. Cancel anytime in account settings.\nBy subscribing, you agree to our Terms & Privacy Policy.',
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
    bool isPopular = false,
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF1E173D)
              : const Color(0xFF131325),
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
