import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CountryCodePicker extends StatefulWidget {
  final String? initialValue;
  final Function(String) onChanged;
  final String? Function(String?)? validator;

  const CountryCodePicker({
    super.key,
    this.initialValue,
    required this.onChanged,
    this.validator,
  });

  @override
  State<CountryCodePicker> createState() => _CountryCodePickerState();
}

class _CountryCodePickerState extends State<CountryCodePicker> {
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
    _selectedCountryCode = widget.initialValue ?? 'LK'; // Default to Sri Lanka
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Country Code *',
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
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCountryCode,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
              items: _countries.map((country) {
                return DropdownMenuItem<String>(
                  value: country['code'],
                  child: Row(
                    children: [
                      Text(
                        country['flag']!,
                        style: TextStyle(fontSize: 20.sp),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        country['dialCode']!,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          country['name']!,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedCountryCode = newValue;
                  });
                  final selectedCountry = _countries.firstWhere(
                    (country) => country['code'] == newValue,
                  );
                  widget.onChanged(selectedCountry['dialCode']!);
                }
              },
            ),
          ),
        ),
        if (widget.validator != null)
          Builder(
            builder: (context) {
              final error = widget.validator!(_selectedCountryCode);
              if (error != null) {
                return Padding(
                  padding: EdgeInsets.only(top: 4.h),
                  child: Text(
                    error,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12.sp,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
      ],
    );
  }
}
