import 'package:dhikru_linda_flutter/networks/api_acess.dart';
import 'package:dhikru_linda_flutter/helpers/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  // ── Colors ──
  static const _bg = Color(0xFF0B0F14);
  static const _cardBg = Color(0xFF111720);
  static const _fieldBg = Color(0xFF141B24);
  static const _mutedText = Color(0xFF8993A4);
  static const _accentPurple = Color(0xFF7C5CF6);
  static const _accentPurpleLight = Color(0xFF9D7FF7);
  static const _borderColor = Color(0xFF252F3D);

  // ── Controllers ──
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // ── State ──
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isChanging = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ── Handle Action ──
  Future<void> _handleChangePassword() async {
    final oldPassword = _oldPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Local validation
    if (oldPassword.isEmpty) {
      ToastUtil.showShortToast("The old password field is required.");
      return;
    }
    if (newPassword.isEmpty) {
      ToastUtil.showShortToast("The new password field is required.");
      return;
    }
    if (confirmPassword != newPassword) {
      ToastUtil.showShortToast("The new password field confirmation does not match.");
      return;
    }

    setState(() => _isChanging = true);
    try {
      final success = await changePasswordRxObj.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
        newPasswordConfirmation: confirmPassword,
      );
      if (success && mounted) {
        Navigator.pop(context);
      }
    } finally {
      if (mounted) {
        setState(() => _isChanging = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── App Bar ──
            _buildAppBar(),

            // ── Scrollable Body ──
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),

                    // ── Old Password ──
                    _buildFieldLabel('OLD PASSWORD'),
                    SizedBox(height: 8.h),
                    _buildPasswordField(
                      controller: _oldPasswordController,
                      hintText: 'Enter your old password',
                      obscureText: _obscureOldPassword,
                      onToggleVisibility: () =>
                          setState(() => _obscureOldPassword = !_obscureOldPassword),
                    ),

                    SizedBox(height: 20.h),

                    // ── New Password ──
                    _buildFieldLabel('NEW PASSWORD'),
                    SizedBox(height: 8.h),
                    _buildPasswordField(
                      controller: _newPasswordController,
                      hintText: 'Enter your new password',
                      obscureText: _obscureNewPassword,
                      onToggleVisibility: () =>
                          setState(() => _obscureNewPassword = !_obscureNewPassword),
                    ),

                    SizedBox(height: 20.h),

                    // ── Confirm Password ──
                    _buildFieldLabel('CONFIRM NEW PASSWORD'),
                    SizedBox(height: 8.h),
                    _buildPasswordField(
                      controller: _confirmPasswordController,
                      hintText: 'Confirm your new password',
                      obscureText: _obscureConfirmPassword,
                      onToggleVisibility: () => setState(
                          () => _obscureConfirmPassword = !_obscureConfirmPassword),
                    ),

                    SizedBox(height: 40.h),

                    // ── Action Button ──
                    _buildChangePasswordButton(),

                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────
  //  App Bar
  // ────────────────────────────────────────────────
  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () {
              if (Navigator.canPop(context)) Navigator.pop(context);
            },
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: _cardBg,
                shape: BoxShape.circle,
                border: Border.all(color: _borderColor, width: 1),
              ),
              child: const Icon(
                Icons.chevron_left_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Text(
            'Change Password',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────
  //  Field Label
  // ────────────────────────────────────────────────
  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.inter(
        color: _mutedText,
        fontSize: 11.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      ),
    );
  }

  // ────────────────────────────────────────────────
  //  Password Text Field
  // ────────────────────────────────────────────────
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
  }) {
    return Container(
      height: 54.h,
      decoration: BoxDecoration(
        color: _fieldBg,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: _borderColor, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
              ),
              cursorColor: _accentPurpleLight,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
                hintText: hintText,
                hintStyle: GoogleFonts.inter(color: _mutedText, fontSize: 15.sp),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off_rounded : Icons.visibility_rounded,
              color: _mutedText,
              size: 20.sp,
            ),
            onPressed: onToggleVisibility,
          ),
          SizedBox(width: 8.w),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────
  //  Change Password Button
  // ────────────────────────────────────────────────
  Widget _buildChangePasswordButton() {
    return GestureDetector(
      onTap: _isChanging ? null : _handleChangePassword,
      child: Container(
        width: double.infinity,
        height: 50.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          gradient: const LinearGradient(
            colors: [Color(0xFF9D7FF7), _accentPurple],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: _accentPurple.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: _isChanging
            ? SizedBox(
                width: 20.w,
                height: 20.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                'Change Password',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
