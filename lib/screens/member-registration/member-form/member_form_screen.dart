import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:matrimony_flutter/utils/constants.dart';
import 'package:matrimony_flutter/screens/member-registration/member-form/looking_for_form.dart';
import 'package:matrimony_flutter/screens/member-registration/member-form/basic_info_form.dart';
import 'package:matrimony_flutter/screens/member-registration/member-form/contact_info_form.dart';
import 'package:matrimony_flutter/screens/member-registration/member-form/personal_details_form.dart';
import 'package:matrimony_flutter/screens/member-registration/member-form/family_info_form.dart';
import 'package:matrimony_flutter/screens/member-registration/member-form/religious_background_form.dart';
import 'package:matrimony_flutter/screens/member-registration/member-form/education_career_form.dart';

class MemberFormScreen extends StatelessWidget {
  final int currentStep;
  final Map<String, dynamic> formData;
  final Function(Map<String, dynamic>) onStepDataChanged;

  const MemberFormScreen({
    super.key,
    required this.currentStep,
    required this.formData,
    required this.onStepDataChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: _buildCurrentStepForm(),
    );
  }

  Widget _buildCurrentStepForm() {
    final currentStepEnum = RegistrationConstants.registrationSteps[currentStep];
    
    switch (currentStepEnum) {
      case RegistrationStep.lookingFor:
        return LookingForForm(
          formData: formData,
          onDataChanged: onStepDataChanged,
        );
      case RegistrationStep.basic:
        return BasicInfoForm(
          formData: formData,
          onDataChanged: onStepDataChanged,
        );
      case RegistrationStep.contact:
        return ContactInfoForm(
          formData: formData,
          onDataChanged: onStepDataChanged,
        );
      case RegistrationStep.personal:
        return PersonalDetailsForm(
          formData: formData,
          onDataChanged: onStepDataChanged,
        );
      case RegistrationStep.family:
        return FamilyInfoForm(
          formData: formData,
          onDataChanged: onStepDataChanged,
        );
      case RegistrationStep.religionBackground:
        return ReligiousBackgroundForm(
          formData: formData,
          onDataChanged: onStepDataChanged,
        );
      case RegistrationStep.education:
        return EducationCareerForm(
          formData: formData,
          onDataChanged: onStepDataChanged,
        );
      default:
        return Container(
          padding: EdgeInsets.all(20.w),
          child: Center(
            child: Text(
              'Unknown step: $currentStep',
              style: TextStyle(fontSize: 16.sp),
            ),
          ),
        );
    }
  }
}
