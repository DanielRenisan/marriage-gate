import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:matrimony_flutter/widgets/custom_text_field.dart';
import 'package:matrimony_flutter/widgets/custom_dropdown.dart';
import 'package:matrimony_flutter/widgets/country_picker.dart';
import 'package:matrimony_flutter/utils/enum.dart';
import 'package:provider/provider.dart';
import 'package:matrimony_flutter/providers/data_provider.dart';

class FamilyInfoForm extends StatefulWidget {
  final Map<String, dynamic> formData;
  final Function(Map<String, dynamic>) onDataChanged;

  const FamilyInfoForm({
    super.key,
    required this.formData,
    required this.onDataChanged,
  });

  @override
  State<FamilyInfoForm> createState() => _FamilyInfoFormState();
}

class _FamilyInfoFormState extends State<FamilyInfoForm> {
  final _fatherNameController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _fatherOccupationController = TextEditingController();
  final _motherOccupationController = TextEditingController();
  final _siblingsController = TextEditingController();

  String? _selectedFamilyType;
  String? _selectedOriginCountry;

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  @override
  void dispose() {
    _fatherNameController.dispose();
    _motherNameController.dispose();
    _fatherOccupationController.dispose();
    _motherOccupationController.dispose();
    _siblingsController.dispose();
    super.dispose();
  }

  void _loadExistingData() {
    if (widget.formData['fatherName'] != null) {
      _fatherNameController.text = widget.formData['fatherName'];
    }
    if (widget.formData['motherName'] != null) {
      _motherNameController.text = widget.formData['motherName'];
    }
    if (widget.formData['fatherOccupation'] != null) {
      _fatherOccupationController.text = widget.formData['fatherOccupation'];
    }
    if (widget.formData['motherOccupation'] != null) {
      _motherOccupationController.text = widget.formData['motherOccupation'];
    }
    if (widget.formData['siblings'] != null) {
      _siblingsController.text = widget.formData['siblings'].toString();
    } else {
      // Set default siblings count if not selected
      _siblingsController.text = '0'; // Default to 0 siblings
    }
    if (widget.formData['familyType'] != null) {
      _selectedFamilyType = widget.formData['familyType'];
    }
    if (widget.formData['originCountry'] != null) {
      _selectedOriginCountry = widget.formData['originCountry'];
    }

    // Call _updateFormData to ensure default values are saved to parent formData
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateFormData();
    });
  }

  void _updateFormData() {
    final data = {
      'fatherName': _fatherNameController.text,
      'motherName': _motherNameController.text,
      'fatherOccupation': _fatherOccupationController.text,
      'motherOccupation': _motherOccupationController.text,
      'siblings': int.tryParse(_siblingsController.text) ?? 0,
      'familyType': _selectedFamilyType,
      'originCountry': _selectedOriginCountry,
    };
    widget.onDataChanged(data);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Father's Name
            CustomTextField(
              controller: _fatherNameController,
              labelText: 'Father\'s Name *',
              hintText: 'Enter father\'s name',
              onChanged: (value) => _updateFormData(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Father\'s name is required';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),

            // Mother's Name
            CustomTextField(
              controller: _motherNameController,
              labelText: 'Mother\'s Name *',
              hintText: 'Enter mother\'s name',
              onChanged: (value) => _updateFormData(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Mother\'s name is required';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),

            // Father's Occupation
            CustomTextField(
              controller: _fatherOccupationController,
              labelText: 'Father\'s Occupation *',
              hintText: 'Enter father\'s occupation',
              onChanged: (value) => _updateFormData(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Father\'s occupation is required';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),

            // Mother's Occupation
            CustomTextField(
              controller: _motherOccupationController,
              labelText: 'Mother\'s Occupation *',
              hintText: 'Enter mother\'s occupation',
              onChanged: (value) => _updateFormData(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Mother\'s occupation is required';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),

            // Number of Siblings
            CustomTextField(
              controller: _siblingsController,
              labelText: 'Number of Siblings *',
              hintText: '0',
              keyboardType: TextInputType.number,
              onChanged: (value) => _updateFormData(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Number of siblings is required';
                }
                final siblings = int.tryParse(value);
                if (siblings == null || siblings < 0) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),

            // Family Type
            CustomDropdown(
              label: 'Family Type *',
              value: _selectedFamilyType,
              options: RegistrationConstants.familyTypeOptions,
              onChanged: (value) {
                setState(() {
                  _selectedFamilyType = value;
                });
                _updateFormData();
              },
              isRequired: true,
            ),
            SizedBox(height: 16.h),

            // Origin Country
            CountryPicker(
              label: 'Origin Country *',
              initialValue: _selectedOriginCountry,
              onChanged: (value) {
                setState(() {
                  _selectedOriginCountry = value;
                });
                _updateFormData();
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Origin country is required';
                }
                return null;
              },
            ),
          ],
        );
      },
    );
  }
}
