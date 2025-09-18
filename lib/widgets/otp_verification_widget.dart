import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OtpVerificationWidget extends StatefulWidget {
  final Function(int) onOtpComplete;
  final bool isLoading;
  final int length;
  final String? errorMessage;
  final bool hideTitle;

  const OtpVerificationWidget({
    super.key,
    required this.onOtpComplete,
    this.isLoading = false,
    this.length = 6,
    this.errorMessage,
    this.hideTitle = false,
  });

  @override
  State<OtpVerificationWidget> createState() => _OtpVerificationWidgetState();
}

class _OtpVerificationWidgetState extends State<OtpVerificationWidget> {
  final List<TextEditingController> _controllers = [];
  final List<FocusNode> _focusNodes = [];
  final List<String> _otpValues = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    for (int i = 0; i < widget.length; i++) {
      _controllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
      _otpValues.add('');
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onInput(String value, int index) {
    if (value.length == 1 && RegExp(r'^[0-9]$').hasMatch(value)) {
      _otpValues[index] = value;
      
      // Move to next field
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      }

      // Check if all fields are filled
      if (_otpValues.every((val) => val.isNotEmpty)) {
        final otp = _otpValues.join('');
        widget.onOtpComplete(int.parse(otp));
      }
    } else {
      _otpValues[index] = '';
      _controllers[index].clear();
    }
  }

  void _onKeyDown(KeyEvent event, int index) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backspace) {
        if (_controllers[index].text.isEmpty && index > 0) {
          _focusNodes[index - 1].requestFocus();
          _controllers[index - 1].selection = TextSelection.fromPosition(
            TextPosition(offset: _controllers[index - 1].text.length),
          );
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        if (index > 0) {
          _focusNodes[index - 1].requestFocus();
          _controllers[index - 1].selection = TextSelection.fromPosition(
            TextPosition(offset: _controllers[index - 1].text.length),
          );
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        if (index < widget.length - 1) {
          _focusNodes[index + 1].requestFocus();
          _controllers[index + 1].selection = const TextSelection.collapsed(offset: 0);
        }
      }
    }
  }

  void _onPaste(String pastedData) {
    final digits = pastedData.replaceAll(RegExp(r'[^0-9]'), '').split('').take(widget.length).toList();
    
    if (digits.isNotEmpty) {
      for (int i = 0; i < digits.length && i < widget.length; i++) {
        _controllers[i].text = digits[i];
        _otpValues[i] = digits[i];
      }
      
      // Focus on the next empty field or the last field
      final focusIndex = digits.length < widget.length ? digits.length : widget.length - 1;
      _focusNodes[focusIndex].requestFocus();
      
      // Check if all fields are filled
      if (_otpValues.every((val) => val.isNotEmpty)) {
        final otp = _otpValues.join('');
        widget.onOtpComplete(int.parse(otp));
      }
    }
  }

  void clear() {
    for (int i = 0; i < widget.length; i++) {
      _controllers[i].clear();
      _otpValues[i] = '';
    }
    _focusNodes[0].requestFocus();
  }

  int getOtpValue() {
    final otp = _otpValues.join('');
    return otp.isEmpty ? 0 : int.parse(otp);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!widget.hideTitle) ...[
            Text(
              'OTP Verification',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Enter the 6-digit code sent to your phone/email',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
          ],
          
          // OTP Input Fields
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.length, (index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 3.w),
                child: SizedBox(
                  width: 40.w,
                  child: KeyboardListener(
                    focusNode: FocusNode(),
                    onKeyEvent: (event) => _onKeyDown(event, index),
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) => _onInput(value, index),
                      onTap: () {
                        _controllers[index].selection = TextSelection.fromPosition(
                          TextPosition(offset: _controllers[index].text.length),
                        );
                      },
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(
                            color: widget.errorMessage != null ? Colors.red : Colors.grey[300]!,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(
                            color: widget.errorMessage != null ? Colors.red : Colors.grey[300]!,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          
          if (widget.errorMessage != null) ...[
            SizedBox(height: 12.h),
            Text(
              widget.errorMessage!,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          
          SizedBox(height: 16.h),
          
          // Paste Button
          TextButton(
            onPressed: () async {
              final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
              if (clipboardData?.text != null) {
                _onPaste(clipboardData!.text!);
              }
            },
            child: Text(
              'Paste OTP',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.red,
              ),
            ),
          ),
          
          SizedBox(height: 16.h),
          
          // Loading Overlay
          if (widget.isLoading)
            Container(
              padding: EdgeInsets.all(16.w),
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}
