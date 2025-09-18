import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CombinedPhoneField extends StatefulWidget {
  final String? initialCountryCode;
  final String? initialPhoneNumber;
  final Function(String countryCode, String phoneNumber) onChanged;
  final String? Function(String?)? validator;

  const CombinedPhoneField({
    super.key,
    this.initialCountryCode,
    this.initialPhoneNumber,
    required this.onChanged,
    this.validator,
  });

  @override
  State<CombinedPhoneField> createState() => _CombinedPhoneFieldState();
}

class _CombinedPhoneFieldState extends State<CombinedPhoneField> {
  final TextEditingController _phoneController = TextEditingController();
  String? _selectedCountryCode;
  final List<Map<String, String>> _countries = [
    {'code': 'LK', 'name': 'Sri Lanka', 'dialCode': '+94', 'flag': '🇱🇰'},
    {'code': 'IN', 'name': 'India', 'dialCode': '+91', 'flag': '🇮🇳'},
    {'code': 'US', 'name': 'United States', 'dialCode': '+1', 'flag': '🇺🇸'},
    {'code': 'GB', 'name': 'United Kingdom', 'dialCode': '+44', 'flag': '🇬🇧'},
    {'code': 'CA', 'name': 'Canada', 'dialCode': '+1', 'flag': '🇨🇦'},
    {'code': 'AU', 'name': 'Australia', 'dialCode': '+61', 'flag': '🇦🇺'},
    {'code': 'DE', 'name': 'Germany', 'dialCode': '+49', 'flag': '🇩🇪'},
    {'code': 'FR', 'name': 'France', 'dialCode': '+33', 'flag': '🇫🇷'},
    {'code': 'IT', 'name': 'Italy', 'dialCode': '+39', 'flag': '🇮🇹'},
    {'code': 'ES', 'name': 'Spain', 'dialCode': '+34', 'flag': '🇪🇸'},
    {'code': 'JP', 'name': 'Japan', 'dialCode': '+81', 'flag': '🇯🇵'},
    {'code': 'KR', 'name': 'South Korea', 'dialCode': '+82', 'flag': '🇰🇷'},
    {'code': 'CN', 'name': 'China', 'dialCode': '+86', 'flag': '🇨🇳'},
    {'code': 'SG', 'name': 'Singapore', 'dialCode': '+65', 'flag': '🇸🇬'},
    {'code': 'MY', 'name': 'Malaysia', 'dialCode': '+60', 'flag': '🇲🇾'},
    {'code': 'TH', 'name': 'Thailand', 'dialCode': '+66', 'flag': '🇹🇭'},
    {'code': 'AE', 'name': 'United Arab Emirates', 'dialCode': '+971', 'flag': '🇦🇪'},
    {'code': 'SA', 'name': 'Saudi Arabia', 'dialCode': '+966', 'flag': '🇸🇦'},
    {'code': 'QA', 'name': 'Qatar', 'dialCode': '+974', 'flag': '🇶🇦'},
    {'code': 'KW', 'name': 'Kuwait', 'dialCode': '+965', 'flag': '🇰🇼'},
    {'code': 'BH', 'name': 'Bahrain', 'dialCode': '+973', 'flag': '🇧🇭'},
    {'code': 'OM', 'name': 'Oman', 'dialCode': '+968', 'flag': '🇴🇲'},
    {'code': 'BD', 'name': 'Bangladesh', 'dialCode': '+880', 'flag': '🇧🇩'},
    {'code': 'PK', 'name': 'Pakistan', 'dialCode': '+92', 'flag': '🇵🇰'},
    {'code': 'NP', 'name': 'Nepal', 'dialCode': '+977', 'flag': '🇳🇵'},
    {'code': 'MV', 'name': 'Maldives', 'dialCode': '+960', 'flag': '🇲🇻'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedCountryCode = widget.initialCountryCode ?? 'LK';
    _phoneController.text = widget.initialPhoneNumber ?? '';
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onCountryCodeChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        _selectedCountryCode = newValue;
      });
      final selectedCountry = _countries.firstWhere(
        (country) => country['code'] == newValue,
      );
      widget.onChanged(selectedCountry['dialCode']!, _phoneController.text);
    }
  }

  void _onPhoneNumberChanged(String value) {
    widget.onChanged(
      _countries.firstWhere((country) => country['code'] == _selectedCountryCode)['dialCode']!,
      value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mobile Number *',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              // Country Code Dropdown
              Container(
                width: 100.w,
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCountryCode,
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600], size: 20.sp),
                    items: _countries.map((country) {
                      return DropdownMenuItem<String>(
                        value: country['code'],
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              country['flag']!,
                              style: TextStyle(fontSize: 16.sp),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              country['dialCode']!,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: _onCountryCodeChanged,
                  ),
                ),
              ),
              // Phone Number Input
              Expanded(
                child: TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  onChanged: _onPhoneNumberChanged,
                  decoration: InputDecoration(
                    hintText: '10-11 digits',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 16.h,
                    ),
                  ),
                  validator: widget.validator,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
