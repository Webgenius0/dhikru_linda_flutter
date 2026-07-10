import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dhikru_linda_flutter/networks/api_acess.dart';
import 'package:dhikru_linda_flutter/features/home/model/get_profile_model.dart';
import 'package:dhikru_linda_flutter/features/profile/widgets/profile_widgets.dart';

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
  late final TextEditingController _nameController;
  late String _selectedGender;
  late int _selectedAge;
  late String _selectedStatus;
  File? _pickedImage;
  bool _isSaving = false;

  final List<String> _genderOptions = ['Male', 'Female'];
  final List<int> _ageOptions = List.generate(150, (i) => i + 1);
  final List<String> _statusOptions = [
    'Single',
    'Married',
    'Divorced',
    'Prefer not to say',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);

    final String genderLower = widget.gender.trim().toLowerCase();
    _selectedGender = _genderOptions.firstWhere(
      (opt) => opt.toLowerCase() == genderLower,
      orElse: () => _genderOptions.first,
    );

    _selectedAge = _ageOptions.contains(widget.age)
        ? widget.age
        : _ageOptions.first;

    final String statusLower = widget.status.trim().toLowerCase().replaceAll(
      '_',
      ' ',
    );
    _selectedStatus = _statusOptions.firstWhere(
      (opt) => opt.toLowerCase() == statusLower,
      orElse: () => _statusOptions.first,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: const Color(0xFF111720),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 12.h),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2730),
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
                    color: const Color(0xFF7C5CF6).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    color: const Color(0xFF9D7FF7),
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
              const Divider(
                color: Color(0xFF1E2730),
                height: 1,
                indent: 16,
                endIndent: 16,
              ),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C5CF6).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.photo_library_rounded,
                    color: const Color(0xFF9D7FF7),
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
    } catch (_) {}
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    setState(() => _isSaving = true);
    try {
      final success = await updateProfileRxObj.updateProfile(
        name: name,
        maritalStatus: _selectedStatus.toLowerCase().replaceAll(' ', '_'),
        age: _selectedAge,
        gender: _selectedGender.toLowerCase(),
        avatar: _pickedImage,
      );

      if (success && mounted) {
        final currentProfile = getProfileRxObj.dataFetcher.hasValue
            ? getProfileRxObj.dataFetcher.value
            : null;
        final currentUser = currentProfile?.data?.user;
        final updatedUser = (currentUser ?? User()).copyWith(
          name: name,
          maritalStatus: _selectedStatus.toLowerCase().replaceAll(' ', '_'),
          age: _selectedAge,
          gender: _selectedGender.toLowerCase(),
        );
        getProfileRxObj.dataFetcher.sink.add(
          GetProfileModel(
            success: true,
            message: currentProfile?.message,
            code: currentProfile?.code,
            data: Data(user: updatedUser),
          ),
        );

        getProfileRxObj.getProfileInfo();

        Navigator.pop(context, {
          'name': name,
          'gender': _selectedGender,
          'age': _selectedAge,
          'status': _selectedStatus,
          'imageFile': _pickedImage,
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F14),
      body: SafeArea(
        child: Column(
          children: [
            EditProfileAppBar(isSaving: _isSaving, onSaveTap: _save),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),
                    EditProfileAvatarPicker(
                      pickedImage: _pickedImage,
                      imageUrl: widget.imageUrl,
                      onTap: _pickImage,
                    ),
                    SizedBox(height: 32.h),
                    EditProfileNameField(controller: _nameController),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Expanded(
                          child: EditProfileDropdown<String>(
                            label: 'GENDER',
                            value: _selectedGender,
                            items: _genderOptions,
                            displayText: (v) => v,
                            onChanged: (v) =>
                                setState(() => _selectedGender = v!),
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: EditProfileDropdown<int>(
                            label: 'AGE',
                            value: _selectedAge,
                            items: _ageOptions,
                            displayText: (v) => '$v',
                            onChanged: (v) => setState(() => _selectedAge = v!),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    EditProfileDropdown<String>(
                      label: 'RELATIONSHIP STATUS',
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
}
