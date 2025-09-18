import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:matrimony_flutter/utils/constants.dart';
import 'package:matrimony_flutter/widgets/custom_text_field.dart';
import 'package:matrimony_flutter/widgets/custom_dropdown.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class BasicInfoForm extends StatefulWidget {
  final Map<String, dynamic> formData;
  final Function(Map<String, dynamic>) onDataChanged;

  const BasicInfoForm({
    super.key,
    required this.formData,
    required this.onDataChanged,
  });

  @override
  State<BasicInfoForm> createState() => _BasicInfoFormState();
}

class _BasicInfoFormState extends State<BasicInfoForm> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  int? _selectedGender;
  String? _selectedMaritalStatus;
  final List<File> _profileImages = [];
  final ImagePicker _picker = ImagePicker();
  bool _isImageVisible = true;

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dateOfBirthController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _loadExistingData() {
    if (widget.formData['firstName'] != null) {
      _firstNameController.text = widget.formData['firstName'];
    }
    if (widget.formData['lastName'] != null) {
      _lastNameController.text = widget.formData['lastName'];
    }
    if (widget.formData['dateOfBirth'] != null) {
      _dateOfBirthController.text = widget.formData['dateOfBirth'];
    }
    if (widget.formData['height'] != null) {
      _heightController.text = widget.formData['height'].toString();
    } else {
      // Set default height if not selected
      _heightController.text = '170'; // Default to 170 cm
    }
    if (widget.formData['weight'] != null) {
      _weightController.text = widget.formData['weight'].toString();
    }
    if (widget.formData['gender'] != null) {
      _selectedGender = widget.formData['gender'];
    } else {
      // Set default gender if not selected
      _selectedGender = 1; // Default to Male
    }
    if (widget.formData['maritalStatus'] != null) {
      _selectedMaritalStatus = widget.formData['maritalStatus'];
    } else {
      // Set default marital status if not selected
      _selectedMaritalStatus = '1'; // Default to Single
    }
    if (widget.formData['isImageVisible'] != null) {
      _isImageVisible = widget.formData['isImageVisible'];
    }

    // Call _updateFormData to ensure default values are saved to parent formData
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateFormData();
    });
  }

  void _updateFormData() {
    final data = {
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'dateOfBirth': _dateOfBirthController.text,
      'height': double.tryParse(_heightController.text) ?? 0,
      'weight': double.tryParse(_weightController.text) ?? 0,
      'gender': _selectedGender ?? 1, // Default to Male if not selected
      'maritalStatus': _selectedMaritalStatus ?? '1', // Default to Single if not selected
      'profileImages': _profileImages,
      'isImageVisible': _isImageVisible,
    };
    widget.onDataChanged(data);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 6570)), // 18 years ago
      firstDate: DateTime.now().subtract(const Duration(days: 36500)), // 100 years ago
      lastDate: DateTime.now().subtract(const Duration(days: 6570)), // 18 years ago
    );
    if (picked != null) {
      setState(() {
        _dateOfBirthController.text = picked.toIso8601String().split('T')[0]; // YYYY-MM-DD format
      });
      _updateFormData();
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        final file = File(image.path);
        final sizeInBytes = await file.length();
        final sizeInMB = sizeInBytes / (1024 * 1024);

        if (sizeInMB > 5) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Image size should be between 250KB and 5MB.'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }

        setState(() {
          if (_profileImages.length < 5) {
            _profileImages.add(file);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('You can upload maximum 5 images.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
        _updateFormData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to upload image. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _profileImages.removeAt(index);
    });
    _updateFormData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // First Name
        CustomTextField(
          controller: _firstNameController,
          labelText: 'First Name *',
          hintText: 'Enter first name',
          onChanged: (value) => _updateFormData(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'First name is required';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),

        // Last Name
        CustomTextField(
          controller: _lastNameController,
          labelText: 'Last Name *',
          hintText: 'Enter last name',
          onChanged: (value) => _updateFormData(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Last name is required';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),

        // Date of Birth
        CustomTextField(
          controller: _dateOfBirthController,
          labelText: 'Date of Birth *',
          hintText: 'YYYY-MM-DD',
          enabled: true,
          onTap: () => _selectDate(context),
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Date of birth is required';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),

        // Height and Weight
        Row(
          children: [
            Expanded(
              child: _buildHeightDropdown(),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: CustomTextField(
                controller: _weightController,
                labelText: 'Weight (Kg) *',
                hintText: 'Enter weight',
                keyboardType: TextInputType.number,
                onChanged: (value) => _updateFormData(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Weight is required';
                  }
                  final weight = double.tryParse(value);
                  if (weight == null || weight < 30 || weight > 200) {
                    return 'Please enter a valid weight';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // Profile Image Upload
        _buildImageUploadSection(),
        SizedBox(height: 16.h),

        // Gender Radio Buttons
        Text(
          'Gender *',
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
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
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
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
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

        // Marital Status Dropdown
        CustomDropdown(
          label: 'Marital Status *',
          value: _selectedMaritalStatus,
          options: RegistrationConstants.maritalStatusOptions,
          onChanged: (value) {
            setState(() {
              _selectedMaritalStatus = value;
            });
            _updateFormData();
          },
          isRequired: true,
        ),
      ],
    );
  }

  Widget _buildHeightDropdown() {
    final heightOptions = List.generate(
        101,
        (index) => {
              'id': index + 140,
              'name': '${index + 140} cm',
            });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Height (cm) *',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: DropdownButton<int>(
            value: _heightController.text.isNotEmpty ? int.tryParse(_heightController.text) : null,
            isExpanded: true,
            underline: const SizedBox(),
            hint: Text('170 cm (default)'),
            items: heightOptions.map((option) {
              return DropdownMenuItem<int>(
                value: option['id'] as int,
                child: Text(option['name'] as String),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _heightController.text = value.toString();
                });
                _updateFormData();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildImageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profile Image *',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'You can upload a maximum of 5 images. Each image must be clear and between 250KB and 5MB in size.',
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            children: [
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  ..._profileImages.asMap().entries.map((entry) {
                    final index = entry.key;
                    final image = entry.value;
                    return Stack(
                      children: [
                        Container(
                          width: 80.w,
                          height: 80.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            image: DecorationImage(
                              image: FileImage(image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4.h,
                          right: 4.w,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                              padding: EdgeInsets.all(4.w),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 12.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                  if (_profileImages.length < 5)
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 80.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.grey[600],
                          size: 24.sp,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        if (_profileImages.isEmpty)
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Text(
              'At least one profile image is required',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.red,
              ),
            ),
          ),

        // Make it visible checkbox
        SizedBox(height: 12.h),
        CheckboxListTile(
          title: Text(
            'Make it visible',
            style: TextStyle(fontSize: 14.sp),
          ),
          value: _isImageVisible,
          onChanged: (value) {
            setState(() {
              _isImageVisible = value ?? true;
            });
            _updateFormData();
          },
          activeColor: Colors.red,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }
}
