import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:matrimony_flutter/providers/member_provider.dart';
import 'package:matrimony_flutter/providers/data_provider.dart';
import 'package:matrimony_flutter/utils/enum.dart';
import 'package:matrimony_flutter/utils/popup_utils.dart';
import 'package:matrimony_flutter/widgets/custom_button.dart';
import 'package:matrimony_flutter/screens/member-registration/member-form/member_form_screen.dart';
import 'package:matrimony_flutter/models/profile_request.dart';
import 'package:matrimony_flutter/screens/main/main_screen.dart';
import 'dart:io';
import 'package:matrimony_flutter/providers/auth_provider.dart';

import '../../services/auth_service.dart';

class MemberRegistrationScreen extends StatefulWidget {
  const MemberRegistrationScreen({super.key});

  @override
  State<MemberRegistrationScreen> createState() => _MemberRegistrationScreenState();
}

class _MemberRegistrationScreenState extends State<MemberRegistrationScreen> {
  int _currentStep = 0;
  bool _isLoading = false;
  final authService = AuthService();

  // Store form data for each step
  final Map<String, dynamic> _formData = {};

  @override
  void initState() {
    super.initState();
    // Initialize data when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dataProvider = context.read<DataProvider>();
      dataProvider.initializeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Member Registration'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
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
      padding: EdgeInsets.all(8.w),
      child: Column(
        children: [
          Text(
            'STEP ${_currentStep + 1} OF 7',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          // SizedBox(height: 8.h),
          Text(
            RegistrationConstants.registrationSteps[_currentStep].title,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8.h),
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
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.all(8.w),
            margin: EdgeInsets.symmetric(horizontal: 8.w),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.green,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    RegistrationConstants.getStepDescription(RegistrationConstants.registrationSteps[_currentStep]),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.green[800],
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
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        if (dataProvider.isAnyLoading) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 10.0.h),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Loading registration data...',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return MemberFormScreen(
          currentStep: _currentStep,
          formData: _formData,
          onStepDataChanged: (stepData) {
            setState(() {
              _formData.addAll(stepData);
            });
          },
        );
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
              text: _currentStep == RegistrationConstants.registrationSteps.length - 1 ? 'Create Membership' : 'Next',
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
      await _submitRegistration();
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
    final requiredFields = ['profileFor', 'preferenceGender', 'preferenceAgeMin', 'preferenceAgeMax', 'preferredCountry'];
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
          message: 'Please complete all required fields in the personal information section.',
        );
        return false;
      }
    }

    // Check if at least one profile image is uploaded
    if (_formData['profileImages'] == null || (_formData['profileImages'] as List).isEmpty) {
      DialogUtils.showErrorDialog(
        context,
        title: 'Validation Error',
        message: 'Please upload at least one profile image.',
      );
      return false;
    }

    return true;
  }

  bool _validateContactStep() {
    final requiredFields = [
      'email',
      'phoneNumber',
      'phoneCode',
      'residencyStatus',
      'country',
      'state',
      'city',
      'road',
      'zipCode'
    ];
    for (final field in requiredFields) {
      if (_formData[field] == null || _formData[field].toString().isEmpty) {
        DialogUtils.showErrorDialog(
          context,
          title: 'Validation Error',
          message: 'Please complete all required fields in the contact details section.',
        );
        return false;
      }
    }
    return true;
  }

  bool _validatePersonalStep() {
    final requiredFields = [
      'aboutMe',
      'motherTongue',
      'diet',
      'smokingHabit',
      'drinkingHabit',
      'bodyType',
      'complexion',
      'bloodGroup',
      'willingToRelocate'
    ];
    for (final field in requiredFields) {
      if (_formData[field] == null || _formData[field].toString().isEmpty) {
        DialogUtils.showErrorDialog(
          context,
          title: 'Validation Error',
          message: 'Please complete all required fields in the personal details section.',
        );
        return false;
      }
    }

    // Check if at least one language is selected
    if (_formData['knownLanguages'] == null || (_formData['knownLanguages'] as List).isEmpty) {
      DialogUtils.showErrorDialog(
        context,
        title: 'Validation Error',
        message: 'Please add at least one language you know.',
      );
      return false;
    }

    return true;
  }

  bool _validateFamilyStep() {
    final requiredFields = [
      'fatherName',
      'motherName',
      'fatherOccupation',
      'motherOccupation',
      'siblings',
      'familyType',
      'originCountry'
    ];
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
    final requiredFields = ['religion', 'community', 'star', 'raasi', 'timeOfBirth'];
    for (final field in requiredFields) {
      if (_formData[field] == null || _formData[field].toString().isEmpty) {
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
    final requiredFields = [
      'education',
      'qualification',
      'institute',
      'sector',
      'jobType',
      'jobTitle',
      'companyName',
      'salary',
      'currency'
    ];
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

  Future<void> _submitRegistration() async {
    setState(() {
      _isLoading = true;
    });

    try {
      DialogUtils.showLoadingDialog(context, message: 'Creating your profile...');

      final memberProvider = Provider.of<MemberProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      List<String> imageUrls = [];
      if (_formData['profileImages'] != null && _formData['profileImages'] is List) {
        final List<File> profileImages = _formData['profileImages'];
        for (final File image in profileImages) {
          try {
            final imageUrl = await memberProvider.uploadProfileImage(image);
            imageUrls.add(imageUrl);
          } catch (e) {
            throw Exception('Failed to upload image: ${e.toString()}');
          }
        }
      }

      final token = await authService.getAuthToken();
      final profileRequest = ProfileRequest(
        profileFor: _getIntValue('profileFor', 1),
        isActive: true,
        firstName: _formData['firstName']?.toString() ?? '',
        lastName: _formData['lastName']?.toString() ?? '',
        email: _formData['email']?.toString() ?? '',
        phoneNumber: _formData['phoneNumber']?.toString() ?? '',
        phoneCode: _formData['phoneCode']?.toString() ?? 'LK',
        aboutMe: _formData['aboutMe']?.toString() ?? '',
        gender: _getIntValue('gender', 1),
        dateOfBirth: _formData['dateOfBirth']?.toString() ?? '',
        foodHabit: _getIntValue('diet', 1),
        drinksHabit: _getIntValue('drinkingHabit', 1),
        smokeHabit: _getIntValue('smokingHabit', 1),
        marriageStatus: _getIntValue('maritalStatus', 1),
        bodyType: _getIntValue('bodyType', 1),
        willingToRelocate: _getBoolValue('canReLocated', false) ? 1 : 0,
        height: _getDoubleValue('height', 0.0),
        weight: _getDoubleValue('weight', 0.0),
        disability: _formData['disability']?.toString() ?? '',
        originCountry: _formData['country']?.toString() ?? '',
        knownLanguages: _formData['languages'] != null ? (_formData['languages'] as List).join(',') : null,
        bloodGroup: _getIntValue('bloodGroup', 1),
        skinComplexion: _getIntValue('complexion', 1),
        isVisibleCommunity: _getBoolValue('isVisible', true),
        userId:
            authService.getUserIdFromToken(token ?? '') ?? authProvider.currentUser?.id ?? _formData['userId']?.toString() ?? '',
        religionId: _formData['religionId']?.toString() ?? _formData['religion']?.toString() ?? '',
        communityId: _formData['communityId']?.toString() ?? _formData['community']?.toString(),
        profileJob: _createProfileJob(),
        profileLookingFor: ProfileLookingForRequest(
          gender: _getIntValue('preferenceGender', 1),
          minAge: _getIntValue('preferenceAgeMin', 25),
          maxAge: _getIntValue('preferenceAgeMax', 35),
          country: _formData['preferredCountry']?.toString() ?? '',
        ),
        profileFamily: ProfileFamilyRequest(
          fatherName: _formData['fatherName']?.toString() ?? '',
          fatherOccupation: _formData['fatherOccupation']?.toString() ?? '',
          motherName: _formData['motherName']?.toString() ?? '',
          motherOccupation: _formData['motherOccupation']?.toString() ?? '',
          numberOfSiblings: _getIntValue('siblings', 0),
          familyType: _getIntValue('familyType', 1),
        ),
        profileAstrology: ProfileAstrologyRequest(
          nakshathiram: _getIntValue('star', 1),
          raasi: _getIntValue('raasi', 1),
          timeOfBirth: _formData['timeOfBirth']?.toString(),
        ),
        profileImages: imageUrls
            .map((url) => {
                  'url': url,
                  'isProfile': true,
                  'isVisible': true,
                })
            .toList(),
        profileAddresses: _createProfileAddresses(),
        profileEducations: _createProfileEducations(),
      );

      final response = await memberProvider.createMemberProfile(profileRequest);

      if (!mounted) return;

      DialogUtils.hideLoadingDialog(context);

      if (response.isError) {
        DialogUtils.showErrorDialog(
          context,
          title: 'Registration Failed',
          message: response.error ?? 'Failed to create profile. Please try again.',
        );
      } else {
        String successMessage = 'Profile created successfully! Welcome to our community.';

        if (imageUrls.isNotEmpty) {
          successMessage += '\n\n${imageUrls.length} image(s) uploaded successfully.';
        }

        DialogUtils.showSuccessDialog(
          context,
          title: 'Success',
          message: successMessage,
          onConfirm: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
          },
        );
      }
    } catch (e) {
      if (!mounted) return;

      DialogUtils.hideLoadingDialog(context);

      DialogUtils.showErrorDialog(
        context,
        title: 'Registration Failed',
        message: 'An error occurred while creating your profile. Please try again.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  int _getIntValue(String key, [int? defaultValue]) {
    final value = _formData[key];
    if (value == null) return defaultValue ?? 1;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? defaultValue ?? 1;
    return defaultValue ?? 1;
  }

  double _getDoubleValue(String key, [double? defaultValue]) {
    final value = _formData[key];
    if (value == null) return defaultValue ?? 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? defaultValue ?? 0.0;
    return defaultValue ?? 0.0;
  }

  bool _getBoolValue(String key, [bool? defaultValue]) {
    final value = _formData[key];
    if (value == null) return defaultValue ?? false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return value.toLowerCase() == 'true' || value == '1';
    return defaultValue ?? false;
  }

  ProfileJobRequest? _createProfileJob() {
    final jobTitle = _formData['jobTitle'];
    final companyName = _formData['companyName'];

    if (jobTitle == null || jobTitle.toString().isEmpty) return null;

    return ProfileJobRequest(
      title: jobTitle.toString(),
      companyName: companyName?.toString() ?? '',
      sector: _getIntValue('sector', 1),
      jobTypeId: _formData['jobType']?.toString() ?? '',
      profileSalary: ProfileSalaryRequest(
        isAnnual: _getBoolValue('isYearly', true),
        amount: _getDoubleValue('salary', 0.0),
        currencyCode: _formData['currency']?.toString() ?? 'USD',
        isVisible: _getBoolValue('isVisible', false),
      ),
    );
  }

  List<ProfileAddressRequest> _createProfileAddresses() {
    return [
      ProfileAddressRequest(
        addressType: _getIntValue('addressType', 1),
        residentStatus: _getIntValue('residencyStatus'),
        isDefault: true,
        number: _formData['addressNumber']?.toString(),
        street: _formData['address']?.toString() ?? '',
        city: _formData['city']?.toString() ?? '',
        state: _formData['state']?.toString() ?? '',
        zipcode: _formData['zipcode']?.toString(),
        country: _formData['country']?.toString() ?? '',
        latitude: 0.0, // You might want to get actual coordinates
        longitude: 0.0, // You might want to get actual coordinates
      ),
    ];
  }

  List<ProfileEducationRequest>? _createProfileEducations() {
    final qualification = _formData['qualification'];
    final institute = _formData['institute'];

    if (qualification == null || qualification.toString().isEmpty) return null;

    return [
      ProfileEducationRequest(
        qualification: qualification.toString(),
        institute: institute?.toString() ?? '',
        sortNo: 1,
        educationQualificationId: _formData['education']?.toString() ?? '1',
      ),
    ];
  }
}
