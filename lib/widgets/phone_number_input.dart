import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneNumberInput extends StatefulWidget {
  final String labelText;
  final String hintText;
  final TextEditingController phoneController;
  final String? selectedCountryCode;
  final Function(String) onCountryCodeChanged;
  final Function(String) onPhoneNumberChanged;
  final String? Function(String?)? validator;
  final bool isRequired;

  const PhoneNumberInput({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.phoneController,
    this.selectedCountryCode,
    required this.onCountryCodeChanged,
    required this.onPhoneNumberChanged,
    this.validator,
    this.isRequired = false,
  });

  @override
  State<PhoneNumberInput> createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  String _selectedCountryCode = 'GB';
  String _completePhoneNumber = '';

  @override
  void initState() {
    super.initState();
    // Set initial country code if provided
    if (widget.selectedCountryCode != null) {
      _selectedCountryCode = widget.selectedCountryCode!;
    }
  }

  @override
  void didUpdateWidget(PhoneNumberInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedCountryCode != null && widget.selectedCountryCode != oldWidget.selectedCountryCode) {
      setState(() {
        _selectedCountryCode = widget.selectedCountryCode!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.isRequired ? '${widget.labelText} *' : widget.labelText,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 4.h),
        IntlPhoneField(
          controller: widget.phoneController,
          initialCountryCode: _selectedCountryCode,
          flagsButtonPadding: EdgeInsets.all(8.w),
          dropdownIconPosition: IconPosition.trailing,
          showCursor: true,
          showDropdownIcon: true,
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Colors.red),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 10.h,
            ),
          ),
          onChanged: (phone) {
            setState(() {
              _selectedCountryCode = phone.countryCode;
              _completePhoneNumber = phone.completeNumber;
            });
            widget.onCountryCodeChanged(phone.countryCode);
            widget.onPhoneNumberChanged(phone.completeNumber);
          },
          onCountryChanged: (country) {
            setState(() {
              _selectedCountryCode = country.code;
            });
            widget.onCountryCodeChanged(country.code);
          },
          validator: widget.validator != null ? (phone) => widget.validator!(phone?.completeNumber) : null,
        ),
      ],
    );
  }
}
