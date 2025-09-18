import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:matrimony_flutter/utils/constants.dart';
import 'package:matrimony_flutter/widgets/custom_text_field.dart';
import 'package:matrimony_flutter/widgets/custom_dropdown.dart';

class PersonalDetailsForm extends StatefulWidget {
  final Map<String, dynamic> formData;
  final Function(Map<String, dynamic>) onDataChanged;

  const PersonalDetailsForm({
    super.key,
    required this.formData,
    required this.onDataChanged,
  });

  @override
  State<PersonalDetailsForm> createState() => _PersonalDetailsFormState();
}

class _PersonalDetailsFormState extends State<PersonalDetailsForm> {
  final _aboutMeController = TextEditingController();
  final _disabilityController = TextEditingController();

  String? _selectedMotherTongue;
  String? _selectedDiet;
  String? _selectedSmokingHabit;
  String? _selectedDrinkingHabit;
  String? _selectedBodyType;
  String? _selectedBloodGroup;
  String? _selectedComplexion;
  List<String> _selectedKnownLanguages = [];
  int? _willingToRelocate; // 1: Yes, 2: No, 3: Maybe

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  @override
  void dispose() {
    _aboutMeController.dispose();
    _disabilityController.dispose();
    super.dispose();
  }

  void _loadExistingData() {
    if (widget.formData['aboutMe'] != null) {
      _aboutMeController.text = widget.formData['aboutMe'];
    }
    if (widget.formData['disability'] != null) {
      _disabilityController.text = widget.formData['disability'];
    }
    if (widget.formData['motherTongue'] != null) {
      _selectedMotherTongue = widget.formData['motherTongue'];
    } else {
      // Set default mother tongue if not selected
      _selectedMotherTongue = '1'; // Default to English
    }
    if (widget.formData['diet'] != null) {
      _selectedDiet = widget.formData['diet'];
    } else {
      // Set default diet if not selected
      _selectedDiet = '1'; // Default to Non-Vegetarian
    }
    if (widget.formData['smokingHabit'] != null) {
      _selectedSmokingHabit = widget.formData['smokingHabit'];
    } else {
      // Set default smoking habit if not selected
      _selectedSmokingHabit = '1'; // Default to Non-Smoker
    }
    if (widget.formData['drinkingHabit'] != null) {
      _selectedDrinkingHabit = widget.formData['drinkingHabit'];
    } else {
      // Set default drinking habit if not selected
      _selectedDrinkingHabit = '1'; // Default to Non-Drinker
    }
    if (widget.formData['bodyType'] != null) {
      _selectedBodyType = widget.formData['bodyType'];
    } else {
      // Set default body type if not selected
      _selectedBodyType = '1'; // Default to Average
    }
    if (widget.formData['bloodGroup'] != null) {
      _selectedBloodGroup = widget.formData['bloodGroup'];
    } else {
      // Set default blood group if not selected
      _selectedBloodGroup = '1'; // Default to A+
    }
    if (widget.formData['complexion'] != null) {
      _selectedComplexion = widget.formData['complexion'];
    } else {
      // Set default complexion if not selected
      _selectedComplexion = '1'; // Default to Fair
    }
    if (widget.formData['knownLanguages'] != null) {
      _selectedKnownLanguages = List<String>.from(widget.formData['knownLanguages']);
    } else {
      // Set default language if not selected
      _selectedKnownLanguages = ['English']; // Default to English
    }
    if (widget.formData['willingToRelocate'] != null) {
      _willingToRelocate = widget.formData['willingToRelocate'];
    } else {
      // Set default willingness to relocate if not selected
      _willingToRelocate = 1; // Default to Yes
    }

    // Call _updateFormData to ensure default values are saved to parent formData
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateFormData();
    });
  }

  void _updateFormData() {
    final data = {
      'aboutMe': _aboutMeController.text,
      'disability': _disabilityController.text,
      'motherTongue': _selectedMotherTongue ?? '1', // Default to English
      'diet': _selectedDiet ?? '1', // Default to Non-Vegetarian
      'smokingHabit': _selectedSmokingHabit ?? '1', // Default to Non-Smoker
      'drinkingHabit': _selectedDrinkingHabit ?? '1', // Default to Non-Drinker
      'bodyType': _selectedBodyType ?? '1', // Default to Average
      'bloodGroup': _selectedBloodGroup ?? '1', // Default to A+
      'complexion': _selectedComplexion ?? '1', // Default to Fair
      'knownLanguages': _selectedKnownLanguages.isNotEmpty ? _selectedKnownLanguages : ['English'], // Default to English
      'willingToRelocate': _willingToRelocate ?? 1, // Default to Yes
    };
    widget.onDataChanged(data);
  }

  void _addLanguage(String language) {
    if (language.isNotEmpty && !_selectedKnownLanguages.contains(language)) {
      setState(() {
        _selectedKnownLanguages.add(language);
      });
      _updateFormData();
    }
  }

  void _removeLanguage(String language) {
    setState(() {
      _selectedKnownLanguages.remove(language);
    });
    _updateFormData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // About Me
        CustomTextField(
          controller: _aboutMeController,
          labelText: 'About Me *',
          hintText: 'Tell us about yourself (minimum 50 characters)',
          maxLines: 4,
          onChanged: (value) => _updateFormData(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'About me is required';
            }
            if (value.length < 50) {
              return 'About me must be at least 50 characters';
            }
            if (value.length > 500) {
              return 'About me must not exceed 500 characters';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),

        // Disability
        CustomTextField(
          controller: _disabilityController,
          labelText: 'Disability',
          hintText: 'Enter any disability (optional)',
          onChanged: (value) => _updateFormData(),
        ),
        SizedBox(height: 16.h),

        // Mother Tongue
        CustomDropdown(
          label: 'Mother Tongue *',
          value: _selectedMotherTongue,
          options: RegistrationConstants.languageOptions,
          onChanged: (value) {
            setState(() {
              _selectedMotherTongue = value;
            });
            _updateFormData();
          },
          isRequired: true,
        ),
        SizedBox(height: 16.h),

        // Diet
        CustomDropdown(
          label: 'Diet *',
          value: _selectedDiet,
          options: RegistrationConstants.dietOptions,
          onChanged: (value) {
            setState(() {
              _selectedDiet = value;
            });
            _updateFormData();
          },
          isRequired: true,
        ),
        SizedBox(height: 16.h),

        // Smoking
        CustomDropdown(
          label: 'Smoking *',
          value: _selectedSmokingHabit,
          options: RegistrationConstants.smokingOptions,
          onChanged: (value) {
            setState(() {
              _selectedSmokingHabit = value;
            });
            _updateFormData();
          },
          isRequired: true,
        ),
        SizedBox(height: 16.h),

        // Drinking
        CustomDropdown(
          label: 'Drinking *',
          value: _selectedDrinkingHabit,
          options: RegistrationConstants.drinkingOptions,
          onChanged: (value) {
            setState(() {
              _selectedDrinkingHabit = value;
            });
            _updateFormData();
          },
          isRequired: true,
        ),
        SizedBox(height: 16.h),

        // Body Type
        CustomDropdown(
          label: 'Body Type *',
          value: _selectedBodyType,
          options: RegistrationConstants.bodyTypeOptions,
          onChanged: (value) {
            setState(() {
              _selectedBodyType = value;
            });
            _updateFormData();
          },
          isRequired: true,
        ),
        SizedBox(height: 16.h),

        // Complexion
        CustomDropdown(
          label: 'Complexion *',
          value: _selectedComplexion,
          options: RegistrationConstants.complexionOptions,
          onChanged: (value) {
            setState(() {
              _selectedComplexion = value;
            });
            _updateFormData();
          },
          isRequired: true,
        ),
        SizedBox(height: 16.h),

        // Blood Group
        CustomDropdown(
          label: 'Blood Group *',
          value: _selectedBloodGroup,
          options: RegistrationConstants.bloodGroupOptions,
          onChanged: (value) {
            setState(() {
              _selectedBloodGroup = value;
            });
            _updateFormData();
          },
          isRequired: true,
        ),
        SizedBox(height: 16.h),

        // Languages Known
        _buildLanguagesSection(),
        SizedBox(height: 16.h),

        // Willing to Relocate
        Text(
          'Willing to Relocate *',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: RadioListTile<int>(
                title: Text('Yes'),
                value: 1,
                groupValue: _willingToRelocate,
                onChanged: (value) {
                  setState(() {
                    _willingToRelocate = value;
                  });
                  _updateFormData();
                },
                contentPadding: EdgeInsets.zero,
                activeColor: Colors.red,
              ),
            ),
            Expanded(
              child: RadioListTile<int>(
                title: Text('No'),
                value: 2,
                groupValue: _willingToRelocate,
                onChanged: (value) {
                  setState(() {
                    _willingToRelocate = value;
                  });
                  _updateFormData();
                },
                contentPadding: EdgeInsets.zero,
                activeColor: Colors.red,
              ),
            ),
            Expanded(
              child: RadioListTile<int>(
                title: Text('Maybe'),
                value: 3,
                groupValue: _willingToRelocate,
                onChanged: (value) {
                  setState(() {
                    _willingToRelocate = value;
                  });
                  _updateFormData();
                },
                contentPadding: EdgeInsets.zero,
                activeColor: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLanguagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Languages Known *',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Select languages from the dropdown. Tap on chips to remove them.',
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 12.h),

        // Language chips
        if (_selectedKnownLanguages.isNotEmpty)
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: _selectedKnownLanguages.map((language) {
              return Chip(
                label: Text(language),
                deleteIcon: Icon(Icons.close, size: 16.sp),
                onDeleted: () => _removeLanguage(language),
                backgroundColor: Colors.red[50],
                deleteIconColor: Colors.red,
                labelStyle: TextStyle(
                  color: Colors.red[700],
                  fontSize: 12.sp,
                ),
              );
            }).toList(),
          ),

        SizedBox(height: 12.h),

        // Language dropdown
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: DropdownButton<String>(
            value: null, // No default selection
            isExpanded: true,
            underline: const SizedBox(),
            hint: Text('Select a language to add'),
            items: RegistrationConstants.commonLanguages
                .map((language) {
                  // Filter out already selected languages
                  if (_selectedKnownLanguages.contains(language)) {
                    return null;
                  }
                  return DropdownMenuItem<String>(
                    value: language,
                    child: Text(language),
                  );
                })
                .where((item) => item != null)
                .cast<DropdownMenuItem<String>>()
                .toList(),
            onChanged: (value) {
              if (value != null) {
                _addLanguage(value);
              }
            },
          ),
        ),
      ],
    );
  }
}
