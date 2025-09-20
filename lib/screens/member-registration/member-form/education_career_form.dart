import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:matrimony_flutter/utils/enum.dart';
import 'package:matrimony_flutter/widgets/custom_text_field.dart';
import 'package:matrimony_flutter/widgets/custom_dropdown.dart';
import 'package:matrimony_flutter/providers/data_provider.dart';

class EducationCareerForm extends StatefulWidget {
  final Map<String, dynamic> formData;
  final Function(Map<String, dynamic>) onDataChanged;

  const EducationCareerForm({
    super.key,
    required this.formData,
    required this.onDataChanged,
  });

  @override
  State<EducationCareerForm> createState() => _EducationCareerFormState();
}

class _EducationCareerFormState extends State<EducationCareerForm> {
  final _qualificationController = TextEditingController();
  final _instituteController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _salaryController = TextEditingController();

  String? _selectedEducation;
  String? _selectedSector;
  String? _selectedJobType;
  String? _selectedCurrency;
  bool _isSalaryVisible = true;
  bool _isYearly = true; // true for yearly, false for monthly

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  @override
  void dispose() {
    _qualificationController.dispose();
    _instituteController.dispose();
    _jobTitleController.dispose();
    _companyNameController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  void _loadExistingData() {
    if (widget.formData['qualification'] != null) {
      _qualificationController.text = widget.formData['qualification'];
    }
    if (widget.formData['institute'] != null) {
      _instituteController.text = widget.formData['institute'];
    }
    if (widget.formData['jobTitle'] != null) {
      _jobTitleController.text = widget.formData['jobTitle'];
    }
    if (widget.formData['companyName'] != null) {
      _companyNameController.text = widget.formData['companyName'];
    }
    if (widget.formData['salary'] != null) {
      _salaryController.text = widget.formData['salary'].toString();
    }
    if (widget.formData['education'] != null) {
      _selectedEducation = widget.formData['education'];
    }
    if (widget.formData['sector'] != null) {
      _selectedSector = widget.formData['sector'];
    }
    if (widget.formData['jobType'] != null) {
      _selectedJobType = widget.formData['jobType'];
    }

    // Debug currency handling
    if (widget.formData['currency'] != null) {
      final existingCurrency = widget.formData['currency'];

      // If the existing value is 'USD', convert it to the correct ID
      if (existingCurrency == 'USD') {
        _selectedCurrency = '2'; // Convert USD code to ID
      } else {
        _selectedCurrency = existingCurrency;
      }
    } else {
      // Set default currency if not selected
      _selectedCurrency = '2'; // Default to USD (ID: 2)
    }

    if (widget.formData['isSalaryVisible'] != null) {
      _isSalaryVisible = widget.formData['isSalaryVisible'];
    }
    if (widget.formData['isYearly'] != null) {
      _isYearly = widget.formData['isYearly'];
    }

    // Call _updateFormData to ensure default values are saved to parent formData
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateFormData();
    });
  }

  void _updateFormData() {
    final currency = _selectedCurrency ?? '2'; // Default to USD (ID: 2) if not selected

    final data = {
      'qualification': _qualificationController.text,
      'institute': _instituteController.text,
      'jobTitle': _jobTitleController.text,
      'companyName': _companyNameController.text,
      'salary': double.tryParse(_salaryController.text) ?? 0,
      'education': _selectedEducation,
      'sector': _selectedSector,
      'jobType': _selectedJobType,
      'currency': currency,
      'isSalaryVisible': _isSalaryVisible,
      'isYearly': _isYearly,
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
            // Highest Education
            if (dataProvider.isLoadingEducation)
              Container(
                padding: EdgeInsets.all(16.w),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                ),
              )
            else
              CustomDropdown(
                label: 'Highest Education *',
                value: _selectedEducation,
                options: dataProvider.getEducationQualificationOptions(),
                onChanged: (value) {
                  setState(() {
                    _selectedEducation = value;
                  });
                  _updateFormData();
                },
                isRequired: true,
              ),
            SizedBox(height: 16.h),

            // Qualification
            CustomTextField(
              controller: _qualificationController,
              labelText: 'Qualification *',
              hintText: 'Enter your qualification',
              onChanged: (value) => _updateFormData(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Qualification is required';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),

            // Institute
            CustomTextField(
              controller: _instituteController,
              labelText: 'Institute *',
              hintText: 'Enter institute name',
              onChanged: (value) => _updateFormData(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Institute is required';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),

            // Job Sector
            CustomDropdown(
              label: 'Job Sector *',
              value: _selectedSector,
              options: RegistrationConstants.sectorOptions,
              onChanged: (value) {
                setState(() {
                  _selectedSector = value;
                });
                _updateFormData();
              },
              isRequired: true,
            ),
            SizedBox(height: 16.h),

            // Job Type
            if (dataProvider.isLoadingJobTypes)
              Container(
                padding: EdgeInsets.all(16.w),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                ),
              )
            else
              CustomDropdown(
                label: 'Job Type *',
                value: _selectedJobType,
                options: dataProvider.getJobTypeOptions(),
                onChanged: (value) {
                  setState(() {
                    _selectedJobType = value;
                  });
                  _updateFormData();
                },
                isRequired: true,
              ),
            SizedBox(height: 16.h),

            // Job Title
            CustomTextField(
              controller: _jobTitleController,
              labelText: 'Job Title *',
              hintText: 'Enter your job title',
              onChanged: (value) => _updateFormData(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Job title is required';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),

            // Company Name
            CustomTextField(
              controller: _companyNameController,
              labelText: 'Company Name *',
              hintText: 'Enter company name',
              onChanged: (value) => _updateFormData(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Company name is required';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),

            // Income Details Section
            Text(
              'Income Details',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 16.h),

            // Salary and Currency
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _salaryController,
                    labelText: 'Salary *',
                    hintText: 'Enter salary amount',
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _updateFormData(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Salary is required';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: CustomDropdown(
                    label: 'Currency *',
                    value: _selectedCurrency,
                    options: RegistrationConstants.currencyOptions,
                    onChanged: (value) {
                      setState(() {
                        _selectedCurrency = value;
                      });
                      _updateFormData();
                    },
                    isRequired: true,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // Make it visible checkbox
            CheckboxListTile(
              title: Text(
                'Make it visible',
                style: TextStyle(fontSize: 14.sp),
              ),
              value: _isSalaryVisible,
              onChanged: (value) {
                setState(() {
                  _isSalaryVisible = value ?? true;
                });
                _updateFormData();
              },
              activeColor: Colors.red,
              contentPadding: EdgeInsets.zero,
            ),
            SizedBox(height: 16.h),

            // Salary Type
            Text(
              'Salary Type *',
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
                  child: RadioListTile<bool>(
                    title: const Text('Monthly'),
                    value: false,
                    groupValue: _isYearly,
                    onChanged: (value) {
                      setState(() {
                        _isYearly = value ?? true;
                      });
                      _updateFormData();
                    },
                    contentPadding: EdgeInsets.zero,
                    activeColor: Colors.red,
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('Yearly'),
                    value: true,
                    groupValue: _isYearly,
                    onChanged: (value) {
                      setState(() {
                        _isYearly = value ?? true;
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
      },
    );
  }
}
