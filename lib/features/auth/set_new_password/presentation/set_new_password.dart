import 'package:dhikru_linda_flutter/helpers/all_routes.dart';
import 'package:dhikru_linda_flutter/helpers/navigation_service.dart';
import 'package:dhikru_linda_flutter/networks/api_acess.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SetNewPassword extends StatefulWidget {
  final String email;
  final String resetToken;
  const SetNewPassword({super.key, required this.email, required this.resetToken});

  @override
  State<SetNewPassword> createState() => _SetNewPasswordState();
}

class _SetNewPasswordState extends State<SetNewPassword>
    with SingleTickerProviderStateMixin {
  // --------------- Controllers ---------------
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // --------------- State ---------------
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  // --------------- Animation ---------------
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // --------------- Continue Action ---------------
  void _onContinue() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final bool success = await resetPasswordRxObj.resetPasswordRx(
      email: widget.email,
      resetToken: widget.resetToken,
      password: _passwordController.text,
      passwordConfirmation: _confirmPasswordController.text,
    );
    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Password reset successfully!',
            style: GoogleFonts.inter(),
          ),
          backgroundColor: const Color(0xFF8B7AE8),
        ),
      );
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          NavigationService.navigateToUntilReplacement(Routes.logInScreen);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF0D0B1F),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => NavigationService.goBack,
          ),
        ),
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 36.h),

                      // --------------- Title ---------------
                      Text(
                        'Set new password',
                        style: GoogleFonts.cormorantGaramond(
                          color: Colors.white,
                          fontSize: 34.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),

                      SizedBox(height: 80.h),

                      // --------------- Password Field ---------------
                      _buildLabel('PASSWORD'),
                      SizedBox(height: 10.h),
                      _buildTextField(
                        controller: _passwordController,
                        hint: 'Enter Your Password',
                        obscureText: _obscurePassword,
                        suffixIcon: GestureDetector(
                          onTap: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                          child: Icon(
                            _obscurePassword
                                ? Icons.remove_red_eye_outlined
                                : Icons.visibility_off_outlined,
                            color: const Color(0xFF8B7AE8),
                            size: 22.sp,
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (v.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 28.h),

                      // --------------- Confirm Password Field ---------------
                      _buildLabel('CONFIRM PASSWORD'),
                      SizedBox(height: 10.h),
                      _buildTextField(
                        controller: _confirmPasswordController,
                        hint: 'Confirm Your Password',
                        obscureText: _obscureConfirmPassword,
                        suffixIcon: GestureDetector(
                          onTap: () => setState(
                            () => _obscureConfirmPassword = !_obscureConfirmPassword,
                          ),
                          child: Icon(
                            _obscureConfirmPassword
                                ? Icons.remove_red_eye_outlined
                                : Icons.visibility_off_outlined,
                            color: const Color(0xFF8B7AE8),
                            size: 22.sp,
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (v != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 48.h),

                      // --------------- Continue Button ---------------
                      SizedBox(
                        width: double.infinity,
                        height: 54.h,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _onContinue,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B7AE8),
                            disabledBackgroundColor:
                                const Color(0xFF8B7AE8).withOpacity(0.6),
                            elevation: 0,
                            shadowColor: const Color(0xFF8B7AE8).withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  width: 22.w,
                                  height: 22.w,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Continue',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --------------- Label Widget ---------------
  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: Colors.white.withOpacity(0.55),
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  // --------------- TextField Widget ---------------
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: GoogleFonts.inter(
        color: Colors.white.withOpacity(0.85),
        fontSize: 14.sp,
      ),
      cursorRadius: const Radius.circular(6),
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(
          color: Colors.white.withOpacity(0.3),
          fontSize: 14.sp,
        ),
        suffixIcon: suffixIcon,
        suffixIconConstraints: BoxConstraints(
          minWidth: 24.w,
          minHeight: 24.h,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.25),
            width: 1,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF8B7AE8), width: 1.5),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFCF6679), width: 1),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFCF6679), width: 1.5),
        ),
        errorStyle: GoogleFonts.inter(
          color: const Color(0xFFCF6679),
          fontSize: 11.sp,
        ),
        contentPadding: EdgeInsets.only(bottom: 10.h),
        isDense: true,
      ),
    );
  }
}
