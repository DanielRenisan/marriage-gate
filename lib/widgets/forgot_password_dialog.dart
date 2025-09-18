import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:matrimony_flutter/providers/auth_provider.dart';
import 'package:matrimony_flutter/utils/constants.dart';
import 'package:matrimony_flutter/widgets/custom_text_field.dart';
import 'package:matrimony_flutter/widgets/custom_button.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordDialog extends StatefulWidget {
  const ForgotPasswordDialog({super.key});

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  ResetPasswordStep _currentStep = ResetPasswordStep.enterEmail;
  String _otpCode = '';
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isPasswordMatch = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            SizedBox(height: 20.h),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        if (_currentStep != ResetPasswordStep.enterEmail)
          IconButton(
            onPressed: _goBack,
            icon: const Icon(Icons.arrow_back),
          ),
        Expanded(
          child: Text(
            _getStepTitle(),
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            _resetForm();
          },
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _buildContent() {
    switch (_currentStep) {
      case ResetPasswordStep.enterEmail:
        return _buildEmailStep();
      case ResetPasswordStep.verification:
        return _buildOtpStep();
      case ResetPasswordStep.resetPassword:
        return _buildPasswordStep();
    }
  }

  Widget _buildEmailStep() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Image.network(
            'https://cdni.iconscout.com/illustration/premium/thumb/otp-authentication-illustration-download-in-svg-png-gif-file-formats--one-time-password-security-protection-business-pack-illustrations-5840953.png',
            height: 200.h,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 200.h,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.email,
                  size: 80.sp,
                  color: Colors.grey[400],
                ),
              );
            },
          ),
          SizedBox(height: 20.h),
          Text(
            'Please enter your email address to receive a verification code',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          CustomTextField(
            controller: _emailController,
            labelText: 'Email or Phone number',
            hintText: 'name@example.com',
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email or phone number';
              }
              return null;
            },
          ),
          SizedBox(height: 20.h),
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return CustomButton(
                text: 'Send',
                isLoading: authProvider.isLoading,
                onPressed: _handleSendOtp,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOtpStep() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: PinCodeTextField(
            appContext: context,
            length: 4,
            obscureText: false,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(8),
              fieldHeight: 50.h,
              fieldWidth: 50.w,
              activeFillColor: Colors.white,
              activeColor: Colors.red,
              selectedColor: Colors.red,
              inactiveColor: Colors.grey[300],
            ),
            animationDuration: const Duration(milliseconds: 300),
            backgroundColor: Colors.transparent,
            enableActiveFill: false,
            onCompleted: (v) {
              setState(() {
                _otpCode = v;
              });
            },
            onChanged: (value) {
              setState(() {
                _otpCode = value;
              });
            },
            beforeTextPaste: (text) {
              return true;
            },
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          'We sent a four digits verification code to your email ${_emailController.text}. You can check your inbox.',
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20.h),
        GestureDetector(
          onTap: _handleResendOtp,
          child: Text(
            'I didn\'t receive the code? Send again',
            style: TextStyle(
              color: Colors.red,
              fontSize: 14.sp,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return CustomButton(
              text: 'Verify',
              isLoading: authProvider.isLoading,
              onPressed: _otpCode.length == 4 ? _handleVerifyOtp : null,
            );
          },
        ),
      ],
    );
  }

  Widget _buildPasswordStep() {
    return Column(
      children: [
        Image.network(
          'https://cdni.iconscout.com/illustration/premium/thumb/forgot-password-reset-illustration-download-in-svg-png-gif-file-formats--restore-cyber-security-business-technology-pack-illustrations-5889578.png',
          height: 200.h,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 200.h,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.lock_reset,
                size: 80.sp,
                color: Colors.grey[400],
              ),
            );
          },
        ),
        SizedBox(height: 20.h),
        Text(
          'Your new password must be different from previous used passwords.',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20.h),
        CustomTextField(
          controller: _passwordController,
          labelText: 'Password',
          hintText: 'Enter new password',
          obscureText: !_isPasswordVisible,
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 8) {
              return 'Password must be at least 8 characters';
            }
            return null;
          },
          onChanged: (value) {
            _checkPasswordMatch();
          },
        ),
        SizedBox(height: 20.h),
        CustomTextField(
          controller: _confirmPasswordController,
          labelText: 'Confirm Password',
          hintText: 'Confirm new password',
          obscureText: !_isConfirmPasswordVisible,
          suffixIcon: IconButton(
            icon: Icon(
              _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
              });
            },
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            }
            if (value != _passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
          onChanged: (value) {
            _checkPasswordMatch();
          },
        ),
        if (!_isPasswordMatch)
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Text(
              'Password does not match',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12.sp,
              ),
            ),
          ),
        SizedBox(height: 20.h),
        Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return CustomButton(
              text: 'Create',
              isLoading: authProvider.isLoading,
              onPressed: _isPasswordMatch ? _handleCreatePassword : null,
            );
          },
        ),
      ],
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case ResetPasswordStep.enterEmail:
        return 'Reset password';
      case ResetPasswordStep.verification:
        return 'Enter your verification code';
      case ResetPasswordStep.resetPassword:
        return 'Create new password';
    }
  }

  void _goBack() {
    switch (_currentStep) {
      case ResetPasswordStep.verification:
        setState(() {
          _currentStep = ResetPasswordStep.enterEmail;
        });
        break;
      case ResetPasswordStep.resetPassword:
        setState(() {
          _currentStep = ResetPasswordStep.verification;
        });
        break;
      default:
        break;
    }
  }

  void _checkPasswordMatch() {
    setState(() {
      _isPasswordMatch = _passwordController.text == _confirmPasswordController.text;
    });
  }

  Future<void> _handleSendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    try {
      final result = await authProvider.forgotPassword(true, _emailController.text);
      
      if (result['success'] == true && mounted) {
        setState(() {
          _currentStep = ResetPasswordStep.verification;
        });
        Fluttertoast.showToast(
          msg: 'OTP sent successfully!',
          backgroundColor: Colors.green,
        );
      }
    } catch (e) {
      if (mounted) {
        Fluttertoast.showToast(
          msg: 'Failed to send OTP. Please try again.',
          backgroundColor: Colors.red,
        );
      }
    }
  }

  Future<void> _handleVerifyOtp() async {
    if (_otpCode.length != 4) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    try {
      final result = await authProvider.verifyOtp(_otpCode);
      
      if (result['success'] == true && mounted) {
        setState(() {
          _currentStep = ResetPasswordStep.resetPassword;
        });
        Fluttertoast.showToast(
          msg: 'OTP verified successfully!',
          backgroundColor: Colors.green,
        );
      }
    } catch (e) {
      if (mounted) {
        Fluttertoast.showToast(
          msg: 'Invalid OTP. Please try again.',
          backgroundColor: Colors.red,
        );
      }
    }
  }

  Future<void> _handleCreatePassword() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _isPasswordMatch = false;
      });
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    try {
      final result = await authProvider.resetPassword(
        _passwordController.text,
        _confirmPasswordController.text,
      );

      if (result['success'] == true && mounted) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(
          msg: 'Password reset successfully!',
          backgroundColor: Colors.green,
        );
      }
    } catch (e) {
      if (mounted) {
        Fluttertoast.showToast(
          msg: 'Failed to reset password. Please try again.',
          backgroundColor: Colors.red,
        );
      }
    }
  }

  void _handleResendOtp() {
    _handleSendOtp();
  }

  void _resetForm() {
    setState(() {
      _currentStep = ResetPasswordStep.enterEmail;
      _otpCode = '';
      _isPasswordMatch = true;
    });
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
  }
}
