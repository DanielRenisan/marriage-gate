import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:matrimony_flutter/widgets/custom_text_field.dart';
import 'package:matrimony_flutter/widgets/custom_dropdown.dart';
import 'package:matrimony_flutter/widgets/google_places_autocomplete.dart';
import 'package:matrimony_flutter/widgets/combined_phone_field.dart';
import 'package:matrimony_flutter/services/google_maps_service.dart';
import 'package:provider/provider.dart';
import 'package:matrimony_flutter/providers/data_provider.dart';

class ContactInfoForm extends StatefulWidget {
  final Map<String, dynamic> formData;
  final Function(Map<String, dynamic>) onDataChanged;

  const ContactInfoForm({
    super.key,
    required this.formData,
    required this.onDataChanged,
  });

  @override
  State<ContactInfoForm> createState() => _ContactInfoFormState();
}

class _ContactInfoFormState extends State<ContactInfoForm> {
  final _livingAddressController = TextEditingController();
  final _emailController = TextEditingController();

  // Address fields from Google Maps
  final _countryController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _roadController = TextEditingController();
  final _doorNoController = TextEditingController();
  final _zipCodeController = TextEditingController();

  String? _selectedPhoneCode; // This will store the dial code like '+1'
  String? _selectedCountryCode; // This will store the country code like 'US'
  String? _selectedPhoneNumber;
  String? _selectedResidencyStatus;
  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  @override
  void dispose() {
    _livingAddressController.dispose();
    _emailController.dispose();
    _countryController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _roadController.dispose();
    _doorNoController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  void _loadExistingData() {
    if (widget.formData['livingAddress'] != null) {
      _livingAddressController.text = widget.formData['livingAddress'];
    }
    if (widget.formData['email'] != null) {
      _emailController.text = widget.formData['email'];
    }
    if (widget.formData['phoneNumber'] != null) {
      _selectedPhoneNumber = widget.formData['phoneNumber'];
    }
    if (widget.formData['phoneCode'] != null) {
      _selectedPhoneCode = widget.formData['phoneCode'];
      // Find the corresponding country code for the stored dial code
      _selectedCountryCode = _getCountryCodeFromDialCode(_selectedPhoneCode!);
    } else {
      // Set default phone code if not selected
      _selectedPhoneCode = '+94'; // Default to Sri Lanka phone code (primary country)
      _selectedCountryCode = 'LK'; // Default to Sri Lanka country code
    }
    if (widget.formData['residencyStatus'] != null) {
      _selectedResidencyStatus = widget.formData['residencyStatus'];
    } else {
      // Set default residency status if not selected
      _selectedResidencyStatus = 'citizen'; // Default to Citizen
    }
    if (widget.formData['country'] != null) {
      _countryController.text = widget.formData['country'];
    }
    if (widget.formData['state'] != null) {
      _stateController.text = widget.formData['state'];
    }
    if (widget.formData['city'] != null) {
      _cityController.text = widget.formData['city'];
    }
    if (widget.formData['road'] != null) {
      _roadController.text = widget.formData['road'];
    }
    if (widget.formData['doorNo'] != null) {
      _doorNoController.text = widget.formData['doorNo'];
    }
    if (widget.formData['zipCode'] != null) {
      _zipCodeController.text = widget.formData['zipCode'];
    }

    // Call _updateFormData to ensure default values are saved to parent formData
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateFormData();
    });
  }

  void _onPlaceSelected(PlaceDetails placeDetails) {
    setState(() {
      _countryController.text = placeDetails.country ?? '';
      _stateController.text = placeDetails.administrativeAreaLevel1 ?? '';
      _cityController.text = placeDetails.locality ?? '';
      _roadController.text = placeDetails.route ?? '';
      _doorNoController.text = placeDetails.streetNumber ?? '';
      _zipCodeController.text = placeDetails.postalCode ?? '';
      _livingAddressController.text = placeDetails.formattedAddress;
      _latitude = placeDetails.latitude;
      _longitude = placeDetails.longitude;
    });
    _updateFormData();
  }

  void _onManualAddressChange() {
    // Update the living address when user manually enters address details
    final address =
        '${_doorNoController.text} ${_roadController.text}, ${_cityController.text}, ${_stateController.text}, ${_countryController.text}'
            .trim();
    _livingAddressController.text = address;
    _updateFormData();
  }

  void _onPhoneChanged(String dialCode, String phoneNumber) {
    setState(() {
      _selectedPhoneCode = dialCode;
      _selectedPhoneNumber = phoneNumber;
      _selectedCountryCode = _getCountryCodeFromDialCode(dialCode);
    });
    _updateFormData();
  }

  // Helper method to get country code from dial code
  String _getCountryCodeFromDialCode(String dialCode) {
    // List of countries with their codes (matching CombinedPhoneField)
    const countryMappings = [
      {'code': 'LK', 'dialCode': '+94'},
      {'code': 'IN', 'dialCode': '+91'},
      {'code': 'US', 'dialCode': '+1'},
      {'code': 'GB', 'dialCode': '+44'},
      {'code': 'CA', 'dialCode': '+1'},
      {'code': 'AU', 'dialCode': '+61'},
      {'code': 'DE', 'dialCode': '+49'},
      {'code': 'FR', 'dialCode': '+33'},
      {'code': 'IT', 'dialCode': '+39'},
      {'code': 'ES', 'dialCode': '+34'},
      {'code': 'JP', 'dialCode': '+81'},
      {'code': 'KR', 'dialCode': '+82'},
      {'code': 'CN', 'dialCode': '+86'},
      {'code': 'SG', 'dialCode': '+65'},
      {'code': 'MY', 'dialCode': '+60'},
      {'code': 'TH', 'dialCode': '+66'},
      {'code': 'AE', 'dialCode': '+971'},
      {'code': 'SA', 'dialCode': '+966'},
      {'code': 'QA', 'dialCode': '+974'},
      {'code': 'KW', 'dialCode': '+965'},
      {'code': 'BH', 'dialCode': '+973'},
      {'code': 'OM', 'dialCode': '+968'},
      {'code': 'BD', 'dialCode': '+880'},
      {'code': 'PK', 'dialCode': '+92'},
      {'code': 'NP', 'dialCode': '+977'},
      {'code': 'MV', 'dialCode': '+960'},
    ];

    // Find the first matching country for the dial code
    for (final country in countryMappings) {
      if (country['dialCode'] == dialCode) {
        return country['code']!;
      }
    }

    // Default to Sri Lanka if not found
    return 'LK';
  }

  void _updateFormData() {
    final data = {
      'livingAddress': _livingAddressController.text,
      'email': _emailController.text,
      'phoneNumber': _selectedPhoneNumber,
      'phoneCode': _selectedPhoneCode ?? '+94', // Default to Sri Lanka phone code
      'residencyStatus': _selectedResidencyStatus ?? 'citizen', // Default to Citizen
      'country': _countryController.text,
      'state': _stateController.text,
      'city': _cityController.text,
      'road': _roadController.text,
      'doorNo': _doorNoController.text,
      'zipCode': _zipCodeController.text,
      'latitude': _latitude,
      'longitude': _longitude,
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
            // Living Address Heading
            Text(
              'Living Address',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'These details help your matched connections reach out to you',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16.h),

            // Email
            CustomTextField(
              controller: _emailController,
              labelText: 'Email *',
              hintText: 'Enter your email address',
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) => _updateFormData(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email is required';
                }
                if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),

            // Combined Phone Number Field
            CombinedPhoneField(
              initialCountryCode: _selectedCountryCode,
              initialPhoneNumber: _selectedPhoneNumber,
              onChanged: _onPhoneChanged,
              validator: (value) {
                if (_selectedPhoneNumber == null || _selectedPhoneNumber!.isEmpty) {
                  return 'Phone number is required';
                }
                if (_selectedPhoneNumber!.length < 10 || _selectedPhoneNumber!.length > 11) {
                  return 'Phone number must be 10-11 digits';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),

            // Google Maps Address Search
            GooglePlacesAutocomplete(
              label: 'Search Address',
              hint: 'Type to search address using Google Maps (optional)',
              onPlaceSelected: _onPlaceSelected,
              validator: (value) {
                // Address search is optional - user can fill manually
                return null;
              },
              isRequired: false,
            ),
            SizedBox(height: 16.h),

            // Address Fields (auto-filled from Google Maps or manual entry)
            Text(
              'Address Details',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 12.h),

            // Country
            CustomTextField(
              controller: _countryController,
              labelText: 'Country *',
              hintText: 'Enter country',
              onChanged: (value) => _onManualAddressChange(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Country is required';
                }
                return null;
              },
            ),
            SizedBox(height: 12.h),

            // State/Province
            CustomTextField(
              controller: _stateController,
              labelText: 'State/Province *',
              hintText: 'Enter state/province',
              onChanged: (value) => _onManualAddressChange(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'State/Province is required';
                }
                return null;
              },
            ),
            SizedBox(height: 12.h),

            // City/Village
            CustomTextField(
              controller: _cityController,
              labelText: 'City/Village *',
              hintText: 'Enter city/village',
              onChanged: (value) => _onManualAddressChange(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'City/Village is required';
                }
                return null;
              },
            ),
            SizedBox(height: 12.h),

            // Road
            CustomTextField(
              controller: _roadController,
              labelText: 'Road *',
              hintText: 'Enter road name',
              onChanged: (value) => _onManualAddressChange(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Road is required';
                }
                return null;
              },
            ),
            SizedBox(height: 12.h),

            // Door Number
            CustomTextField(
              controller: _doorNoController,
              labelText: 'Door Number',
              hintText: 'Enter door number',
              onChanged: (value) => _onManualAddressChange(),
            ),
            SizedBox(height: 12.h),

            // Zip/Postal Code
            CustomTextField(
              controller: _zipCodeController,
              labelText: 'Zip/Postal Code *',
              hintText: 'Enter zip/postal code',
              onChanged: (value) => _onManualAddressChange(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Zip/Postal Code is required';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),

            // Residency Status
            CustomDropdown(
              label: 'Residency Status *',
              value: _selectedResidencyStatus,
              options: const [
                {'id': 'citizen', 'name': 'Citizen'},
                {'id': 'permanent_resident', 'name': 'Permanent Resident'},
                {'id': 'temporary_resident', 'name': 'Temporary Resident'},
                {'id': 'visitor', 'name': 'Visitor'},
                {'id': 'student', 'name': 'Student'},
                {'id': 'work_permit', 'name': 'Work Permit'},
              ],
              onChanged: (value) {
                setState(() {
                  _selectedResidencyStatus = value;
                });
                _updateFormData();
              },
              isRequired: true,
            ),
          ],
        );
      },
    );
  }
}
