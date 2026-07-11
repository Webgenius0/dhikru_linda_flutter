import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dhikru_linda_flutter/networks/api_acess.dart';
import 'package:dhikru_linda_flutter/features/home/model/get_profile_model.dart';
import 'package:dhikru_linda_flutter/features/profile/widgets/profile_widgets.dart';
import 'package:dhikru_linda_flutter/features/profile/presentation/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onGoHome;

  const ProfileScreen({super.key, this.onGoHome});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String _name = 'Sarah Jenkins';
  final String _email = 'sarah.dreams@example.com';
  final String _gender = 'Female';
  final int _age = 25;
  final String _status = 'Single';
  final String _tier = 'Dreamer Tier';
  final bool _isPremium = false;
  File? _imageFile;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    getProfileRxObj.getProfileInfo();
  }

  Future<void> _navigateToEditProfile() async {
    final user = getProfileRxObj.dataFetcher.hasValue
        ? getProfileRxObj.dataFetcher.value.data?.user
        : null;
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(
          name: user?.name ?? _name,
          email: user?.email ?? _email,
          gender: user?.gender ?? _gender,
          age: user?.age is int
              ? user?.age
              : (int.tryParse(user?.age?.toString() ?? '') ?? _age),
          status: user?.maritalStatus ?? _status,
          imageUrl: user?.avatar ?? _imageUrl,
        ),
      ),
    );
    if (result != null && result is Map && mounted) {
      getProfileRxObj.getProfileInfo();
      setState(() {
        _imageFile = result['imageFile'] as File? ?? _imageFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F14),
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: ProfileAppBar(
                onGoHome: widget.onGoHome,
                onEditProfileTap: _navigateToEditProfile,
              ),
            ),
            SliverToBoxAdapter(
              child: StreamBuilder<GetProfileModel>(
                stream: getProfileRxObj.getProfileData,
                builder: (context, snapshot) {
                  final isLoading =
                      snapshot.connectionState == ConnectionState.waiting ||
                      !snapshot.hasData ||
                      snapshot.data?.data?.user == null;

                  final user = snapshot.data?.data?.user;
                  return CustomProfileHeaderWidget(
                    name: user?.name,
                    email: user?.email,
                    gender: user?.gender,
                    age: user?.age,
                    status: user?.maritalStatus,
                    imageFile: _imageFile,
                    imageUrl: user?.avatar,
                    isLoading: isLoading,
                  );
                },
              ),
            ),
            // SliverToBoxAdapter(
            //   child: ProfileTierBadge(tier: _tier, isPremium: _isPremium),
            // ),
            // SliverToBoxAdapter(child: SizedBox(height: 24.h)),
            // if (!_isPremium)
            //   SliverToBoxAdapter(
            //     child: Padding(
            //       padding: EdgeInsets.symmetric(horizontal: 20.w),
            //       child: const ProfilePremiumCard(),
            //     ),
            //   ),
            SliverToBoxAdapter(child: SizedBox(height: 28.h)),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  'ACCOUNT & DATA',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF8993A4),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 12.h)),
            const SliverToBoxAdapter(child: ProfileMenuSection()),
            const SliverToBoxAdapter(
              child: AppVersionFooter(version: 'DreamTrace App v1.0.0'),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 15.h)),
          ],
        ),
      ),
    );
  }
}
