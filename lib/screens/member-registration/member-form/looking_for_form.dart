import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:matrimony_flutter/utils/constants.dart';
import 'package:matrimony_flutter/utils/dialog_utils.dart';
import 'package:matrimony_flutter/widgets/custom_dropdown.dart';
import 'package:matrimony_flutter/widgets/country_picker.dart';
import 'package:provider/provider.dart';
import 'package:matrimony_flutter/providers/data_provider.dart';

class LookingForForm extends StatefulWidget {
  final Map<String, dynamic> formData;
  final Function(Map<String, dynamic>) onDataChanged;
  final Function(bool Function())? onValidationNeeded;

  const LookingForForm({
    super.key,
    required this.formData,
    required this.onDataChanged,
    this.onValidationNeeded,
  });

  @override
  State<LookingForForm> createState() => _LookingForFormState();
}

class _LookingForFormState extends State<LookingForForm> {
  String? _selectedProfileFor;
  int _selectedPreferenceGender = 1; // Default to Male (1)
  int _preferenceAgeMin = 18; // Default min age
  int _preferenceAgeMax = 35; // Default max age
  String? _selectedCountry; // User must select - no default

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  void _loadExistingData() {
    // Load Profile For - no default, user must select
    if (widget.formData['profileFor'] != null) {
      _selectedProfileFor = widget.formData['profileFor'];
    }
    // No default value - user must explicitly select

    // Load Gender Preference with default 'Male' (1)
    if (widget.formData['preferenceGender'] != null) {
      _selectedPreferenceGender = widget.formData['preferenceGender'];
    }
    // _selectedPreferenceGender is already initialized to 1 (Male) as default

    // Load Age Min with default 18
    if (widget.formData['preferenceAgeMin'] != null) {
      _preferenceAgeMin = widget.formData['preferenceAgeMin'];
    }
    // _preferenceAgeMin is already initialized to 18 as default

    // Load Age Max with default 35
    if (widget.formData['preferenceAgeMax'] != null) {
      _preferenceAgeMax = widget.formData['preferenceAgeMax'];
    }
    // _preferenceAgeMax is already initialized to 35 as default

    // Load Country with default 'Sri Lanka'
    if (widget.formData['preferredCountry'] != null) {
      _selectedCountry = widget.formData['preferredCountry'];
    }
    // _selectedCountry is already initialized to 'Sri Lanka' as default

    // Call _updateFormData to ensure default values are saved to parent formData
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateFormData();
      // Register validation method with parent if callback is provided
      widget.onValidationNeeded?.call(validateForm);
    });
  }

  void _updateFormData() {
    final data = {
      'profileFor': _selectedProfileFor, // User must select - no default
      'preferenceGender': _selectedPreferenceGender, // Default is 1 (Male)
      'preferenceAgeMin': _preferenceAgeMin, // Default is 18
      'preferenceAgeMax': _preferenceAgeMax, // Default is 35
      'preferredCountry': _selectedCountry, // Default is 'Sri Lanka'
    };
    widget.onDataChanged(data);
  }

  // Validation method to check required fields
  bool validateForm() {
    List<String> missingFields = [];

    // Check Profile For (required field - user must select)
    if (_selectedProfileFor == null || _selectedProfileFor!.isEmpty) {
      missingFields.add('Profile For');
    }

    // Gender preference has default value (Male), so no validation needed
    // Age fields have default values (18-35), so no validation needed
    // Country has default value (Sri Lanka), so no validation needed

    // Age validation (ensure min <= max)
    if (_preferenceAgeMin > _preferenceAgeMax) {
      missingFields.add('Valid Age Range (Max age must be greater than Min age)');
    }

    // Show validation error popup if there are missing fields
    if (missingFields.isNotEmpty) {
      String message;
      if (missingFields.length == 1) {
        message = 'Please select ${missingFields.first}.';
      } else {
        message = 'Please complete the following required fields:\n• ${missingFields.join('\n• ')}';
      }

      DialogUtils.showErrorDialog(
        context,
        title: 'Validation Error',
        message: message,
      );
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile For Dropdown
            CustomDropdown(
              label: 'I am creating this Profile for? *',
              value: _selectedProfileFor,
              options: RegistrationConstants.profileForOptions,
              onChanged: (value) {
                setState(() {
                  _selectedProfileFor = value;
                });
                _updateFormData();
              },
              isRequired: true,
            ),
            SizedBox(height: 24.h),

            // Looking For in a Match Section
            Text(
              'Looking For in a Match',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 16.h),

            // Gender Radio Buttons
            Text(
              'Looking For Gender *',
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
                    title: Text('Male'),
                    value: 1,
                    groupValue: _selectedPreferenceGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedPreferenceGender = value ?? 1; // Default to Male if null
                      });
                      _updateFormData();
                    },
                    contentPadding: EdgeInsets.zero,
                    activeColor: Colors.red,
                  ),
                ),
                Expanded(
                  child: RadioListTile<int>(
                    title: Text('Female'),
                    value: 2,
                    groupValue: _selectedPreferenceGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedPreferenceGender = value ?? 1; // Default to Male if null
                      });
                      _updateFormData();
                    },
                    contentPadding: EdgeInsets.zero,
                    activeColor: Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Age Range
            Row(
              children: [
                Expanded(
                  child: _buildAgeDropdown(
                    'Min Age *',
                    _preferenceAgeMin,
                    (value) {
                      setState(() {
                        _preferenceAgeMin = value;
                        if (_preferenceAgeMin > _preferenceAgeMax) {
                          _preferenceAgeMax = _preferenceAgeMin;
                        }
                      });
                      _updateFormData();
                    },
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildAgeDropdown(
                    'Max Age *',
                    _preferenceAgeMax,
                    (value) {
                      setState(() {
                        _preferenceAgeMax = value;
                        if (_preferenceAgeMax < _preferenceAgeMin) {
                          _preferenceAgeMin = _preferenceAgeMax;
                        }
                      });
                      _updateFormData();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Preferred Country
            CountryPicker(
              label: 'Preferred Country *',
              initialValue: _selectedCountry,
              onChanged: (value) {
                setState(() {
                  _selectedCountry = value;
                });
                _updateFormData();
              },
              validator: (value) {
                // Since we have a default value, this validation is less critical
                if (value == null || value.isEmpty) {
                  return 'Preferred country is required';
                }
                return null;
              },
            ),

            // Validation message for age range
            if (_preferenceAgeMin > _preferenceAgeMax)
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Text(
                  'Max age must be greater than min age.',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12.sp,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildAgeDropdown(
    String label,
    int selectedValue,
    Function(int) onChanged,
  ) {
    final ageOptions = List.generate(43, (index) => index + 18); // 18 to 60

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 4.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: DropdownButton<int>(
            value: selectedValue,
            isExpanded: true,
            underline: const SizedBox(),
            hint: Text(label == 'Min Age *' ? '18 (default)' : '35 (default)'),
            items: ageOptions.map((age) {
              return DropdownMenuItem<int>(
                value: age,
                child: Text('$age'),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                onChanged(value);
              }
            },
          ),
        ),
      ],
    );
  }
}
