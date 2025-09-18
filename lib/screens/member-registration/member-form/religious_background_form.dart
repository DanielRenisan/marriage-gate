import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:matrimony_flutter/utils/constants.dart';
import 'package:matrimony_flutter/widgets/custom_text_field.dart';
import 'package:matrimony_flutter/widgets/custom_dropdown.dart';
import 'package:matrimony_flutter/widgets/google_places_autocomplete.dart';
import 'package:matrimony_flutter/services/google_maps_service.dart';
import 'package:matrimony_flutter/providers/data_provider.dart';

class ReligiousBackgroundForm extends StatefulWidget {
  final Map<String, dynamic> formData;
  final Function(Map<String, dynamic>) onDataChanged;

  const ReligiousBackgroundForm({
    super.key,
    required this.formData,
    required this.onDataChanged,
  });

  @override
  State<ReligiousBackgroundForm> createState() => _ReligiousBackgroundFormState();
}

class _ReligiousBackgroundFormState extends State<ReligiousBackgroundForm> {
  String? _selectedReligion;
  String? _selectedCommunity;
  String? _selectedStar;
  String? _selectedRaasi;
  final _timeOfBirthController = TextEditingController();

  // Birth location fields
  final _birthCountryController = TextEditingController();
  final _birthStateController = TextEditingController();
  final _birthCityController = TextEditingController();
  final _birthRoadController = TextEditingController();

  double? _birthLatitude;
  double? _birthLongitude;

  @override
  void initState() {
    super.initState();
    _loadExistingData();
    _testGoogleMapsApi();
  }

  void _testGoogleMapsApi() async {
    final isWorking = await GoogleMapsService.testApiKey();
  }

  @override
  void dispose() {
    _timeOfBirthController.dispose();
    _birthCountryController.dispose();
    _birthStateController.dispose();
    _birthCityController.dispose();
    _birthRoadController.dispose();
    super.dispose();
  }

  void _loadExistingData() {
    if (widget.formData['religion'] != null) {
      _selectedReligion = widget.formData['religion'];
    }
    if (widget.formData['community'] != null) {
      _selectedCommunity = widget.formData['community'];
    }
    if (widget.formData['star'] != null) {
      _selectedStar = widget.formData['star'];
    }
    if (widget.formData['raasi'] != null) {
      _selectedRaasi = widget.formData['raasi'];
    }
    if (widget.formData['timeOfBirth'] != null) {
      _timeOfBirthController.text = widget.formData['timeOfBirth'];
    }
    if (widget.formData['birthCountry'] != null) {
      _birthCountryController.text = widget.formData['birthCountry'];
    }
    if (widget.formData['birthState'] != null) {
      _birthStateController.text = widget.formData['birthState'];
    }
    if (widget.formData['birthCity'] != null) {
      _birthCityController.text = widget.formData['birthCity'];
    }
    if (widget.formData['birthRoad'] != null) {
      _birthRoadController.text = widget.formData['birthRoad'];
    }

    // Call _updateFormData to ensure default values are saved to parent formData
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateFormData();
    });
  }

  void _onBirthPlaceSelected(PlaceDetails placeDetails) {
    setState(() {
      _birthCountryController.text = placeDetails.country ?? '';
      _birthStateController.text = placeDetails.administrativeAreaLevel1 ?? '';
      _birthCityController.text = placeDetails.locality ?? '';
      _birthRoadController.text = placeDetails.route ?? '';
      _birthLatitude = placeDetails.latitude;
      _birthLongitude = placeDetails.longitude;
    });
    _updateFormData();
  }

  void _updateFormData() {
    final data = {
      'religion': _selectedReligion,
      'community': _selectedCommunity,
      'star': _selectedStar,
      'raasi': _selectedRaasi,
      'timeOfBirth': _timeOfBirthController.text,
      'birthCountry': _birthCountryController.text,
      'birthState': _birthStateController.text,
      'birthCity': _birthCityController.text,
      'birthRoad': _birthRoadController.text,
      'birthLatitude': _birthLatitude,
      'birthLongitude': _birthLongitude,
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
            // Religion
            if (dataProvider.isLoadingReligions)
              Container(
                padding: EdgeInsets.all(16.w),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                ),
              )
            else
              CustomDropdown(
                label: 'Religion *',
                value: _selectedReligion,
                options: dataProvider.getReligionOptions(),
                onChanged: (value) {
                  setState(() {
                    _selectedReligion = value;
                    // Reset community when religion changes
                    _selectedCommunity = null;
                  });
                  _updateFormData();
                },
                isRequired: true,
              ),
            SizedBox(height: 16.h),

            // Community
            if (dataProvider.isLoadingCommunities)
              Container(
                padding: EdgeInsets.all(16.w),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                ),
              )
            else
              CustomDropdown(
                label: 'Community *',
                value: _selectedCommunity,
                options: dataProvider.getCommunityOptions(),
                onChanged: (value) {
                  setState(() {
                    _selectedCommunity = value;
                  });
                  _updateFormData();
                },
                isRequired: true,
              ),
            SizedBox(height: 16.h),

            // Star/Nakshathra
            CustomDropdown(
              label: 'Star/Nakshathra *',
              value: _selectedStar,
              options: RegistrationConstants.starOptions,
              onChanged: (value) {
                setState(() {
                  _selectedStar = value;
                });
                _updateFormData();
              },
              isRequired: true,
            ),
            SizedBox(height: 16.h),

            // Raasi
            CustomDropdown(
              label: 'Raasi *',
              value: _selectedRaasi,
              options: RegistrationConstants.raasiOptions,
              onChanged: (value) {
                setState(() {
                  _selectedRaasi = value;
                });
                _updateFormData();
              },
              isRequired: true,
            ),
            SizedBox(height: 24.h),

            // Birth Details Section
            Text(
              'Birth Details',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 16.h),

            // Time of Birth
            CustomTextField(
              controller: _timeOfBirthController,
              labelText: 'Time of Birth *',
              hintText: 'HH:MM AM/PM',
              onChanged: (value) => _updateFormData(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Time of birth is required';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),

            // Google Maps Birth Location Search
            GooglePlacesAutocomplete(
              label: 'Search Birth Location',
              hint: 'Type to search birth location using Google Maps',
              onPlaceSelected: _onBirthPlaceSelected,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please search and select a birth location';
                }
                return null;
              },
              isRequired: true,
            ),
            SizedBox(height: 16.h),

            // Birth Location Fields (auto-filled from Google Maps or manual entry)
            Text(
              'Birth Location Details',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 12.h),

            // Country
            CustomTextField(
              controller: _birthCountryController,
              labelText: 'Country',
              hintText: 'Enter birth country',
              onChanged: (value) => _updateFormData(),
            ),
            SizedBox(height: 12.h),

            // State/Province
            CustomTextField(
              controller: _birthStateController,
              labelText: 'State/Province',
              hintText: 'Enter birth state/province',
              onChanged: (value) => _updateFormData(),
            ),
            SizedBox(height: 12.h),

            // City/Village
            CustomTextField(
              controller: _birthCityController,
              labelText: 'City/Village',
              hintText: 'Enter birth city/village',
              onChanged: (value) => _updateFormData(),
            ),
            SizedBox(height: 12.h),

            // Road
            CustomTextField(
              controller: _birthRoadController,
              labelText: 'Road',
              hintText: 'Enter birth road name',
              onChanged: (value) => _updateFormData(),
            ),
          ],
        );
      },
    );
  }
}
