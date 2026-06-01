import 'package:dhikru_linda_flutter/helpers/all_routes.dart';
import 'package:dhikru_linda_flutter/helpers/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  // --------------- Controllers ---------------
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // --------------- State ---------------
  bool _obscurePassword = true;
  bool _isLoading = false;

  // --------------- Animation ---------------
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    // --------------- Animation Controller ---------------
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // --------------- Fade Animation ---------------
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);

    // --------------- Slide Animation ---------------
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _animController.forward();
  }

  @override
  void dispose() {
    // --------------- Dispose Controllers ---------------
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    setState(() => _isLoading = false);
    NavigationService.navigateToReplacement(Routes.userNavigationMenu);
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

        // --------------- Body ---------------
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
                      SizedBox(height: 72.h),

                      // --------------- Title ---------------
                      Text(
                        'Log in',
                        style: GoogleFonts.cormorantGaramond(
                          color: Colors.white,
                          fontSize: 34.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),

                      SizedBox(height: 80.h),

                      // --------------- Email Field ---------------
                      _buildLabel('EMAIL ADDRESS'),
                      SizedBox(height: 10.h),
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

                      SizedBox(height: 28.h),

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

                      SizedBox(height: 36.h),

                      // --------------- Login Button ---------------
                      _buildLoginButton(),

                      SizedBox(height: 20.h),

                      // --------------- Forgot Password ---------------
                      GestureDetector(
                        onTap: () {
                          NavigationService.navigateTo(
                            Routes.forgetPasswordScreen,
                          );
                        },
                        child: Text(
                          'Forgotten your password ?',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF8B7AE8),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            decorationColor: const Color(0xFF8B7AE8),
                          ),
                        ),
                      ),

                      SizedBox(height: 120.h),

                      // --------------- Sign Up Row ---------------
                      _buildSignUpRow(),

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

  // --------------- Login Button Widget ---------------
  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 54.h,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _onLogin,
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
                'Log In',
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

  // --------------- Sign Up Row Widget ---------------
  Widget _buildSignUpRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account ? ",
          style: GoogleFonts.inter(
            color: Colors.white.withOpacity(0.6),
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        GestureDetector(
          onTap: () {
            NavigationService.navigateTo(Routes.registerScreen);
          },
          child: Text(
            'Create an Account',
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
