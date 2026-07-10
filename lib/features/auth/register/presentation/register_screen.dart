import 'package:dhikru_linda_flutter/common_widgets/custom_logo_widget.dart';
import 'package:dhikru_linda_flutter/helpers/all_routes.dart';
import 'package:dhikru_linda_flutter/helpers/navigation_service.dart';
import 'package:dhikru_linda_flutter/networks/api_acess.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  // --------------- Controllers ---------------
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // --------------- State ---------------
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _agreeToTerms = false;

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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // --------------- Register Action ---------------
  void _onRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'You must agree to the Terms & Conditions to register.',
            style: GoogleFonts.inter(),
          ),
          backgroundColor: const Color(0xFFCF6679),
        ),
      );
      return;
    }
    setState(() => _isLoading = true);
    final bool success = await registerRxObj.registerRx(
      name: _nameController.text.trim().isEmpty ? null : _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      passwordConfirmation: _confirmPasswordController.text,
    );
    setState(() => _isLoading = false);
    if (success) {
      NavigationService.navigateTo(
        Routes.registerVerifyScreen,
        arguments: _emailController.text.trim(),
      );
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
                      SizedBox(height: 48.h),

                      // --------------- Logo Widget ---------------
                      const CustomLogoWidget(height: 72, width: 72),
                      SizedBox(height: 24.h),

                      // --------------- Title ---------------
                      Text(
                        'Create Account',
                        style: GoogleFonts.cormorantGaramond(
                          color: Colors.white,
                          fontSize: 34.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),

                      SizedBox(height: 48.h),

                      // --------------- Name Field ---------------
                      _buildLabel('FULL NAME'),
                      SizedBox(height: 8.h),
                      _buildTextField(
                        controller: _nameController,
                        hint: 'Enter Your Full Name',
                        keyboardType: TextInputType.name,
                        validator: (v) {
                          return null;
                        },
                      ),

                      SizedBox(height: 24.h),

                      // --------------- Email Field ---------------
                      _buildLabel('EMAIL ADDRESS'),
                      SizedBox(height: 8.h),
                      _buildTextField(
                        controller: _emailController,
                        hint: 'Enter Your Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 24.h),

                      // --------------- Password Field ---------------
                      _buildLabel('PASSWORD'),
                      SizedBox(height: 8.h),
                      _buildTextField(
                        controller: _passwordController,
                        hint: 'Enter Your Password',
                        obscureText: _obscurePassword,
                        suffixIcon: GestureDetector(
                          onTap: () =>
                              setState(() => _obscurePassword = !_obscurePassword),
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

                      SizedBox(height: 24.h),

                      // --------------- Confirm Password Field ---------------
                      _buildLabel('CONFIRM PASSWORD'),
                      SizedBox(height: 8.h),
                      _buildTextField(
                        controller: _confirmPasswordController,
                        hint: 'Confirm Your Password',
                        obscureText: _obscureConfirmPassword,
                        suffixIcon: GestureDetector(
                          onTap: () => setState(() =>
                              _obscureConfirmPassword = !_obscureConfirmPassword),
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

                      SizedBox(height: 36.h),

                      // --------------- Register Button ---------------
                      _buildRegisterButton(),

                      SizedBox(height: 24.h),

                      // --------------- Terms & Conditions Checkbox ---------------
                      _buildTermsCheckbox(),

                      SizedBox(height: 48.h),

                      // --------------- Login Link Row ---------------
                      _buildLoginRow(),

                      SizedBox(height: 24.h),
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
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
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

  // --------------- Register Button Widget ---------------
  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 54.h,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _onRegister,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8B7AE8),
          disabledBackgroundColor: const Color(0xFF8B7AE8).withOpacity(0.6),
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
                'Register',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
      ),
    );
  }

  // --------------- Terms & Conditions Checkbox Widget ---------------
  Widget _buildTermsCheckbox() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _agreeToTerms = !_agreeToTerms;
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: _agreeToTerms ? const Color(0xFF8B7AE8) : Colors.transparent,
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(
                color: _agreeToTerms
                    ? const Color(0xFF8B7AE8)
                    : Colors.white.withValues(alpha: 0.4),
                width: 1.5,
              ),
            ),
            child: _agreeToTerms
                ? Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 14.sp,
                  )
                : null,
          ),
          SizedBox(width: 12.w),
          Text(
            'I agree to ',
            style: GoogleFonts.inter(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          GestureDetector(
            onTap: () {
              // TODO: Navigate to Terms & Conditions
            },
            child: Text(
              'Terms & Conditions',
              style: GoogleFonts.inter(
                color: const Color(0xFF8B7AE8),
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --------------- Login Row Widget ---------------
  Widget _buildLoginRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account ? ",
          style: GoogleFonts.inter(
            color: Colors.white.withOpacity(0.6),
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        GestureDetector(
          onTap: () {
            NavigationService.goBack;
          },
          child: Text(
            'Log In',
            style: GoogleFonts.inter(
              color: const Color(0xFF8B7AE8),
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
              decorationColor: const Color(0xFF8B7AE8),
            ),
          ),
        ),
      ],
    );
  }
}
