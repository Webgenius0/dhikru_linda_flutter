// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:dhikru_linda_flutter/common_widgets/profile_avatar.dart';
import 'package:dhikru_linda_flutter/helpers/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final String name;
  final String email;
  final String gender;
  final int age;
  final String status;
  final String? imageUrl;

  const EditProfileScreen({
    super.key,
    required this.name,
    required this.email,
    required this.gender,
    required this.age,
    required this.status,
    this.imageUrl,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // ── Colors ──
  static const _bg = Color(0xFF0B0F14);
  static const _cardBg = Color(0xFF111720);
  static const _fieldBg = Color(0xFF141B24);
  static const _dividerColor = Color(0xFF1E2730);
  static const _mutedText = Color(0xFF8993A4);
  static const _accentPurple = Color(0xFF7C5CF6);
  static const _accentPurpleLight = Color(0xFF9D7FF7);
  static const _borderColor = Color(0xFF252F3D);

  // ── Form state ──
  late final TextEditingController _nameController;
  late String _selectedGender;
  late int _selectedAge;
  late String _selectedStatus;
  File? _pickedImage;
  bool _isSaving = false;

  // ── Dropdown options ──
  final List<String> _genderOptions = [
    'Male',
    'Female',
    'Non-binary',
    'Prefer not to say',
  ];
  final List<int> _ageOptions = List.generate(83, (i) => i + 18); // 18–100
  final List<String> _statusOptions = [
    'Single',
    'In a relationship',
    'Married',
    'Divorced',
    'Widowed',
    'It\'s complicated',
    'Prefer not to say',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _selectedGender = _genderOptions.contains(widget.gender)
        ? widget.gender
        : _genderOptions.first;
    _selectedAge = _ageOptions.contains(widget.age)
        ? widget.age
        : _ageOptions.first;
    _selectedStatus = _statusOptions.contains(widget.status)
        ? widget.status
        : _statusOptions.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // ── Pick image from camera or gallery ──
  Future<void> _pickImage() async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: _cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 12.h),
              // Grab handle
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: _dividerColor,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Change Profile Photo',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16.h),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: _accentPurple.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    color: _accentPurpleLight,
                    size: 20.sp,
                  ),
                ),
                title: Text(
                  'Take Photo',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              Divider(
                color: _dividerColor,
                height: 1,
                indent: 16.w,
                endIndent: 16.w,
              ),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: _accentPurple.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.photo_library_rounded,
                    color: _accentPurpleLight,
                    size: 20.sp,
                  ),
                ),
                title: Text(
                  'Choose from Gallery',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              SizedBox(height: 12.h),
            ],
          ),
        );
      },
    );

    if (source == null) return;

    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: source, imageQuality: 85);
      if (picked != null && mounted) {
        setState(() => _pickedImage = File(picked.path));
      }
    } catch (_) {
      // ImagePicker not configured yet — silently ignore
    }
  }

  // ── Save changes ──
  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    setState(() => _isSaving = true);
    await Future.delayed(
      const Duration(milliseconds: 600),
    ); // TODO: replace with real API call
    if (mounted) {
      setState(() => _isSaving = false);
      ToastUtil.showShortToast('Profile edited successfully.');
      Navigator.pop(context, {
        'name': name,
        'gender': _selectedGender,
        'age': _selectedAge,
        'status': _selectedStatus,
        'imageFile': _pickedImage,
      });
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

            // ── Scrollable body ──
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),

                    // ── Avatar picker ──
                    _buildAvatarPicker(),

                    SizedBox(height: 32.h),

                    // ── Full Name ──
                    _buildFieldLabel('FULL NAME'),
                    SizedBox(height: 8.h),
                    _buildNameField(),

                    SizedBox(height: 20.h),

                    // ── Gender + Age (side by side) ──
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel('GENDER'),
                              SizedBox(height: 8.h),
                              _buildDropdown<String>(
                                value: _selectedGender,
                                items: _genderOptions,
                                displayText: (v) => v,
                                onChanged: (v) =>
                                    setState(() => _selectedGender = v!),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel('AGE'),
                              SizedBox(height: 8.h),
                              _buildDropdown<int>(
                                value: _selectedAge,
                                items: _ageOptions,
                                displayText: (v) => '$v',
                                onChanged: (v) =>
                                    setState(() => _selectedAge = v!),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    // ── Relationship Status ──
                    _buildFieldLabel('RELATIONSHIP STATUS'),
                    SizedBox(height: 8.h),
                    _buildDropdown<String>(
                      value: _selectedStatus,
                      items: _statusOptions,
                      displayText: (v) => v,
                      onChanged: (v) => setState(() => _selectedStatus = v!),
                    ),

                    SizedBox(height: 40.h),
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
  //  App Bar  (back | title | Save)
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
            'Edit Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          Spacer(),
          // Save button
          GestureDetector(
            onTap: _isSaving ? null : _save,
            child: SizedBox(
              width: 40.w,
              height: 40.h,
              child: _isSaving
                  ? Center(
                      child: SizedBox(
                        width: 18.w,
                        height: 18.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: _accentPurpleLight,
                        ),
                      ),
                    )
                  : Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Save',
                        style: GoogleFonts.inter(
                          color: _accentPurpleLight,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── App Bar ─────────────────────────────────────────────────────────────────

  // Widget _buildAppBar(BuildContext context) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
  //     child: Row(
  //       children: [
  //         GestureDetector(
  //           onTap: () {
  //             if (widget.onGoHome != null) {
  //               widget.onGoHome!();
  //             } else if (Navigator.canPop(context)) {
  //               Navigator.pop(context);
  //             }
  //           },
  //           child: Container(
  //             width: 34,
  //             height: 34,
  //             decoration: BoxDecoration(
  //               color: _cardBg,
  //               shape: BoxShape.circle,
  //               border: Border.all(color: _borderColor, width: 1),
  //             ),
  //             child: const Icon(
  //               Icons.chevron_left_rounded,
  //               color: _white,
  //               size: 22,
  //             ),
  //           ),
  //         ),
  //         const SizedBox(width: 14),
  //         Text(
  //           'Profile',
  //           style: TextStyle(
  //             color: _white,
  //             fontSize: 22,
  //             fontWeight: FontWeight.w700,
  //             letterSpacing: -0.3,
  //           ),
  //         ),
  //         Spacer(),
  //         GestureDetector(
  //           onTap: _navigateToEditProfile,
  //           child: Container(
  //             width: 34,
  //             height: 34,
  //             decoration: BoxDecoration(
  //               color: _cardBg,
  //               shape: BoxShape.circle,
  //               border: Border.all(color: _borderColor, width: 1),
  //             ),
  //             child: const Icon(Icons.edit_outlined, color: _white, size: 15),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // ────────────────────────────────────────────────
  //  Avatar Picker
  // ────────────────────────────────────────────────
  Widget _buildAvatarPicker() {
    return Column(
      children: [
        Center(
          child: GestureDetector(
            onTap: _pickImage,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                // Avatar ring
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [_accentPurple, Color(0xFF4A90E2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: ProfileAvatar(
                    radius: 50.r,
                    imageFile: _pickedImage,
                    imageUrl: widget.imageUrl,
                    borderColor: _bg,
                    borderWidth: 3,
                  ),
                ),
                // Camera icon badge
                Container(
                  width: 32.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: _accentPurple,
                    shape: BoxShape.circle,
                    border: Border.all(color: _bg, width: 2.5),
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: 15.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h),
        GestureDetector(
          onTap: _pickImage,
          child: Text(
            'Change Photo',
            style: GoogleFonts.inter(
              color: _accentPurpleLight,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ────────────────────────────────────────────────
  //  Field label
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
  //  Name text field
  // ────────────────────────────────────────────────
  Widget _buildNameField() {
    return Container(
      height: 54.h,
      decoration: BoxDecoration(
        color: _fieldBg,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: _borderColor, width: 1),
      ),
      child: TextField(
        controller: _nameController,
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
          hintText: 'Enter your full name',
          hintStyle: GoogleFonts.inter(color: _mutedText, fontSize: 15.sp),
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────
  //  Generic styled dropdown
  // ────────────────────────────────────────────────
  Widget _buildDropdown<T>({
    required T value,
    required List<T> items,
    required String Function(T) displayText,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      height: 54.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: _fieldBg,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: _borderColor, width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          dropdownColor: const Color(0xFF1A2233),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: _mutedText,
            size: 22.sp,
          ),
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 15.sp,
            fontWeight: FontWeight.w400,
          ),
          items: items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    displayText(item),
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
