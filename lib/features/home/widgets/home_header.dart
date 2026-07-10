import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:lottie/lottie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dhikru_linda_flutter/features/home/model/get_profile_model.dart' hide Data;
import 'package:dhikru_linda_flutter/features/home/model/home_data_model.dart';
import 'package:dhikru_linda_flutter/networks/api_acess.dart';
import 'package:dhikru_linda_flutter/networks/endpoints.dart' as endpoints;

// Colors
const Color _white = Colors.white;
const Color _accentPurple = Color(0xFF7B6EF6);
const Color _streakBg = Color(0xFF2A1A10);
const Color _streakText = Color(0xFFE08030);

Map<String, String> _getGreeting() {
  final hour = DateTime.now().hour;
  if (hour >= 5 && hour < 12) {
    return {'text': 'Good morning ', 'icon': '🌅'};
  } else if (hour >= 12 && hour < 17) {
    return {'text': 'Good afternoon ', 'icon': '☀️'};
  } else if (hour >= 17 && hour < 20) {
    return {'text': 'Good evening ', 'icon': '🌆'};
  } else {
    return {'text': 'Good night ', 'icon': '🌙'};
  }
}

class HomeTopBar extends StatelessWidget {
  final VoidCallback? onGoProfile;

  const HomeTopBar({super.key, this.onGoProfile});

  @override
  Widget build(BuildContext context) {
    final greeting = _getGreeting();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Text(
              greeting['text'] ?? 'Good night ',
              style: const TextStyle(
                color: _white,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              greeting['icon'] ?? '🌙',
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
        Row(
          children: [
            const HomeStreakBadge(),
            const SizedBox(width: 10),
            HomeAvatar(onGoProfile: onGoProfile),
          ],
        ),
      ],
    );
  }
}

class HomeStreakBadge extends StatelessWidget {
  const HomeStreakBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<HomeDataModel>(
      stream: homeDataRxObj.getHomeDataStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data?.data?.stats?.streak != true) {
          return const SizedBox.shrink();
        }
        final count = snapshot.data?.data?.stats?.streakCount ?? 0;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _streakBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF3D2010), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🔥', style: TextStyle(fontSize: 13)),
              const SizedBox(width: 5),
              Text(
                '$count DAY STREAK',
                style: const TextStyle(
                  color: _streakText,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class HomeAvatar extends StatelessWidget {
  final VoidCallback? onGoProfile;

  const HomeAvatar({super.key, this.onGoProfile});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onGoProfile,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: _accentPurple, width: 2),
          color: const Color(0xFF3A2060),
        ),
        child: ClipOval(
          child: StreamBuilder<GetProfileModel>(
            stream: getProfileRxObj.getProfileData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Lottie.asset(
                  'assets/lottie/loader_animation.json',
                  width: 38,
                  height: 38,
                  fit: BoxFit.cover,
                );
              }
              final user = snapshot.data?.data?.user;
              final avatar = user?.avatar;
              if (avatar != null && avatar.isNotEmpty) {
                String fullImageUrl = avatar;
                if (!fullImageUrl.startsWith('http')) {
                  fullImageUrl =
                      "${endpoints.url}/${fullImageUrl.startsWith('/') ? fullImageUrl.substring(1) : fullImageUrl}";
                }
                return CachedNetworkImage(
                  imageUrl: fullImageUrl,
                  width: 38,
                  height: 38,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.white.withOpacity(0.05),
                    highlightColor: Colors.white.withOpacity(0.1),
                    child: Container(
                      width: 38,
                      height: 38,
                      color: Colors.white,
                    ),
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/icons/user.png',
                    width: 38,
                    height: 38,
                    fit: BoxFit.cover,
                  ),
                );
              }
              return Container(
                color: const Color(0xFF5A3A80),
                padding: const EdgeInsets.all(6),
                child: Image.asset(
                  'assets/icons/user.png',
                  height: 22,
                  width: 22,
                  fit: BoxFit.contain,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class HomeGreetingName extends StatelessWidget {
  const HomeGreetingName({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GetProfileModel>(
      stream: getProfileRxObj.getProfileData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData ||
            snapshot.data?.data?.user == null) {
          return Shimmer.fromColors(
            baseColor: Colors.white.withOpacity(0.05),
            highlightColor: Colors.white.withOpacity(0.1),
            child: Container(
              width: 120,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
        final name = snapshot.data?.data?.user?.name ?? '';
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Text(
            name,
            maxLines: 1,
            style: const TextStyle(
              color: _white,
              fontSize: 26,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
              height: 1.1,
            ),
          ),
        );
      },
    );
  }
}
