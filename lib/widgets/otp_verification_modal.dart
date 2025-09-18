import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:matrimony_flutter/widgets/otp_verification_widget.dart';
import 'package:matrimony_flutter/widgets/custom_button.dart';

class OtpVerificationModal extends StatefulWidget {
  final String emailOrPhone;
  final bool isEmail;
  final Function(int) onOtpVerified;
  final Function() onResendOtp;
  final Function() onCancel;

  const OtpVerificationModal({
    super.key,
    required this.emailOrPhone,
    required this.isEmail,
    required this.onOtpVerified,
    required this.onResendOtp,
    required this.onCancel,
  });

  @override
  State<OtpVerificationModal> createState() => _OtpVerificationModalState();
}

class _OtpVerificationModalState extends State<OtpVerificationModal> {
  bool _isLoading = false;
  String? _errorMessage;
  int _resendCountdown = 30;

  @override
  void initState() {
    super.initState();
    _startResendCountdown();
  }

  void _startResendCountdown() {
    _resendCountdown = 30;
    _updateCountdown();
  }

  void _updateCountdown() {
    if (_resendCountdown > 0) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _resendCountdown--;
          });
          _updateCountdown();
        }
      });
    }
  }

  void _handleOtpComplete(int otp) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await widget.onOtpVerified(otp);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  void _handleResendOtp() async {
    if (_resendCountdown > 0) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await widget.onResendOtp();
      _startResendCountdown();
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'OTP resent to ${widget.isEmail ? 'email' : 'phone'}',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header with close button
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Row(
                children: [
                  IconButton(
                    onPressed: widget.onCancel,
                    icon: const Icon(Icons.close, color: Colors.grey),
                  ),
                  Expanded(
                    child: Text(
                      'OTP Verification',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 48.w), // Balance the close button
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Email/Phone display
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            widget.isEmail ? Icons.email : Icons.phone,
                            color: Colors.grey[600],
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              widget.emailOrPhone,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 24.h),
                    
                    // OTP Input Widget
                    OtpVerificationWidget(
                      onOtpComplete: _handleOtpComplete,
                      isLoading: _isLoading,
                      errorMessage: _errorMessage,
                    ),
                    
                    SizedBox(height: 32.h),
                    
                    // Resend OTP section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Didn\'t receive the code? ',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (_resendCountdown > 0)
                          Text(
                            'Resend in $_resendCountdown seconds',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[500],
                            ),
                          )
                        else
                          TextButton(
                            onPressed: _isLoading ? null : _handleResendOtp,
                            child: Text(
                              'Resend OTP',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                    
                    SizedBox(height: 24.h),
                    
                    // Cancel button
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        text: 'Cancel',
                        onPressed: _isLoading ? null : widget.onCancel,
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper function to show OTP verification modal
Future<void> showOtpVerificationModal({
  required BuildContext context,
  required String emailOrPhone,
  required bool isEmail,
  required Function(int) onOtpVerified,
  required Function() onResendOtp,
  required Function() onCancel,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    builder: (context) => OtpVerificationModal(
      emailOrPhone: emailOrPhone,
      isEmail: isEmail,
      onOtpVerified: onOtpVerified,
      onResendOtp: onResendOtp,
      onCancel: onCancel,
    ),
  );
}
