import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:matrimony_flutter/providers/member_provider.dart';
import 'package:matrimony_flutter/utils/enum.dart';

import 'package:matrimony_flutter/utils/popup_utils.dart';
import 'package:matrimony_flutter/widgets/custom_button.dart';
import 'package:matrimony_flutter/screens/member-registration/member-form/member_form_screen.dart';

class MemberEditFormScreen extends StatefulWidget {
  final String memberId;

  const MemberEditFormScreen({
    super.key,
    required this.memberId,
  });

  @override
  State<MemberEditFormScreen> createState() => _MemberEditFormScreenState();
}

class _MemberEditFormScreenState extends State<MemberEditFormScreen> {
  int _currentStep = 0;
  bool _isLoading = false;
  bool _isLoadingProfile = true;

  // Store form data for each step
  final Map<String, dynamic> _formData = {};
  Map<String, dynamic>? _existingProfile;

  @override
  void initState() {
    super.initState();
    _loadExistingProfile();
  }

  Future<void> _loadExistingProfile() async {
    try {
      final memberProvider = Provider.of<MemberProvider>(context, listen: false);
      await memberProvider.loadCurrentUserProfile(widget.memberId);
      final profile = memberProvider.currentUserProfile;

      if (mounted && profile != null) {
        setState(() {
          _existingProfile = profile.toJson();
          _formData.addAll(_existingProfile!);
          _isLoadingProfile = false;
        });
      } else if (mounted) {
        setState(() {
          _isLoadingProfile = false;
        });
        DialogUtils.showErrorDialog(
          context,
          title: 'Error',
          message: 'Failed to load profile: Profile not found',
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingProfile = false;
        });
        DialogUtils.showErrorDialog(
          context,
          title: 'Error',
          message: 'Failed to load profile: ${e.toString().replaceAll('Exception: ', '')}',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoadingProfile
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildStepIndicator(),
                Expanded(
                  child: _buildCurrentStep(),
                ),
                _buildNavigationButtons(),
              ],
            ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Text(
            'STEP ${_currentStep + 1} OF ${RegistrationConstants.registrationSteps.length}',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            RegistrationConstants.registrationSteps[_currentStep].title,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: RegistrationConstants.registrationSteps.asMap().entries.map((entry) {
              final index = entry.key;
              final isActive = index == _currentStep;
              final isCompleted = index < _currentStep;

              return Expanded(
                child: Container(
                  height: 4.h,
                  margin: EdgeInsets.symmetric(horizontal: 2.w),
                  decoration: BoxDecoration(
                    color: isCompleted ? Colors.green : (isActive ? Colors.red : Colors.grey[300]),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(12.w),
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.edit,
                  color: Colors.blue,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Edit your profile information. You can navigate between steps to update different sections.',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep() {
    return MemberFormScreen(
      currentStep: _currentStep,
      formData: _formData,
      onStepDataChanged: (stepData) {
        setState(() {
          _formData.addAll(stepData);
        });
      },
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: CustomButton(
                text: 'Previous',
                onPressed: _previousStep,
                backgroundColor: Colors.grey,
              ),
            ),
          if (_currentStep > 0) SizedBox(width: 16.w),
          Expanded(
            child: CustomButton(
              text: _currentStep == RegistrationConstants.registrationSteps.length - 1 ? 'Save Changes' : 'Next',
              onPressed: _isLoading ? null : _nextStep,
              isLoading: _isLoading,
            ),
          ),
        ],
      ),
    );
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _nextStep() async {
    if (!_validateCurrentStep()) {
      return;
    }

    if (_currentStep == RegistrationConstants.registrationSteps.length - 1) {
      await _saveProfile();
    } else {
      setState(() {
        _currentStep++;
      });
    }
  }

  bool _validateCurrentStep() {
    final currentStepEnum = RegistrationConstants.registrationSteps[_currentStep];

    switch (currentStepEnum) {
      case RegistrationStep.lookingFor:
        return _validateLookingForStep();
      case RegistrationStep.basic:
        return _validateBasicStep();
      case RegistrationStep.contact:
        return _validateContactStep();
      case RegistrationStep.personal:
        return _validatePersonalStep();
      case RegistrationStep.family:
        return _validateFamilyStep();
      case RegistrationStep.religionBackground:
        return _validateReligiousStep();
      case RegistrationStep.education:
        return _validateEducationStep();
      default:
        return true;
    }
  }

  bool _validateLookingForStep() {
    final requiredFields = ['profileFor', 'preferenceGender', 'preferenceAgeMin', 'preferenceAgeMax'];
    for (final field in requiredFields) {
      if (_formData[field] == null) {
        DialogUtils.showErrorDialog(
          context,
          title: 'Validation Error',
          message: 'Please complete all required fields in the matching preferences section.',
        );
        return false;
      }
    }
    return true;
  }

  bool _validateBasicStep() {
    final requiredFields = ['firstName', 'lastName', 'gender', 'dateOfBirth', 'maritalStatus', 'height', 'weight'];
    for (final field in requiredFields) {
      if (_formData[field] == null || _formData[field].toString().isEmpty) {
        DialogUtils.showErrorDialog(
          context,
          title: 'Validation Error',
          message: 'Please complete all required fields in the basic information section.',
        );
        return false;
      }
    }
    return true;
  }

  bool _validateContactStep() {
    final requiredFields = ['email', 'phoneNumber', 'city', 'state', 'country'];
    for (final field in requiredFields) {
      if (_formData[field] == null || _formData[field].toString().isEmpty) {
        DialogUtils.showErrorDialog(
          context,
          title: 'Validation Error',
          message: 'Please complete all required fields in the contact information section.',
        );
        return false;
      }
    }
    return true;
  }

  bool _validatePersonalStep() {
    final requiredFields = ['aboutMe', 'motherTongue', 'diet', 'smokingHabit', 'drinkingHabit'];
    for (final field in requiredFields) {
      if (_formData[field] == null) {
        DialogUtils.showErrorDialog(
          context,
          title: 'Validation Error',
          message: 'Please complete all required fields in the personal details section.',
        );
        return false;
      }
    }
    return true;
  }

  bool _validateFamilyStep() {
    final requiredFields = ['fatherName', 'motherName', 'familyType', 'familyStatus'];
    for (final field in requiredFields) {
      if (_formData[field] == null || _formData[field].toString().isEmpty) {
        DialogUtils.showErrorDialog(
          context,
          title: 'Validation Error',
          message: 'Please complete all required fields in the family information section.',
        );
        return false;
      }
    }
    return true;
  }

  bool _validateReligiousStep() {
    final requiredFields = ['religion', 'community', 'star', 'raasi'];
    for (final field in requiredFields) {
      if (_formData[field] == null) {
        DialogUtils.showErrorDialog(
          context,
          title: 'Validation Error',
          message: 'Please complete all required fields in the religious background section.',
        );
        return false;
      }
    }
    return true;
  }

  bool _validateEducationStep() {
    final requiredFields = ['qualification', 'institute', 'jobTitle', 'companyName'];
    for (final field in requiredFields) {
      if (_formData[field] == null || _formData[field].toString().isEmpty) {
        DialogUtils.showErrorDialog(
          context,
          title: 'Validation Error',
          message: 'Please complete all required fields in the education & career section.',
        );
        return false;
      }
    }
    return true;
  }

  Future<void> _saveProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      DialogUtils.showLoadingDialog(context, message: 'Saving your profile...');

      final memberProvider = Provider.of<MemberProvider>(context, listen: false);

      // Prepare the complete profile data
      final profileData = Map<String, dynamic>.from(_formData);

      // Add any additional required fields
      profileData['updatedAt'] = DateTime.now().toIso8601String();

      await memberProvider.updateProfile(widget.memberId, profileData);

      DialogUtils.hideLoadingDialog(context);

      if (mounted) {
        DialogUtils.showSuccessDialog(
          context,
          title: 'Success',
          message: 'Profile updated successfully!',
          onConfirm: () {
            Navigator.of(context).pop();
          },
        );
      }
    } catch (e) {
      DialogUtils.hideLoadingDialog(context);

      if (mounted) {
        DialogUtils.showErrorDialog(
          context,
          title: 'Error',
          message: e.toString().replaceAll('Exception: ', ''),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
