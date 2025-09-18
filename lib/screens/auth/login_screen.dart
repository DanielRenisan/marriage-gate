import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:matrimony_flutter/providers/auth_provider.dart';
import 'package:matrimony_flutter/widgets/custom_text_field.dart';
import 'package:matrimony_flutter/widgets/custom_button.dart';
import 'package:matrimony_flutter/widgets/background_svg.dart';
import 'package:matrimony_flutter/widgets/error_dialog.dart';
import 'package:matrimony_flutter/widgets/otp_verification_widget.dart';
import 'package:matrimony_flutter/widgets/social_login_buttons.dart';
import 'package:matrimony_flutter/widgets/phone_number_input.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:matrimony_flutter/utils/constants.dart';

enum ForgotPasswordStep { enterEmail, verification, resetPassword }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _signUpFormKey = GlobalKey<FormState>();

  bool _isSignUp = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isForgotPassword = false;
  bool _isOtpVerification = false;
  bool _isSocialLoginLoading = false; // Add this line to track social login loading
  LoginType _loginType = LoginType.email;
  ForgotPasswordStep _forgotStep = ForgotPasswordStep.enterEmail;
  String _selectedCountryCode = 'GB'; // Default to United Kingdom

  // Password strength
  double _passwordStrength = 0.0;
  String _passwordStrengthText = 'None';
  Color _passwordStrengthColor = Colors.grey;
  bool _isPasswordMatch = true;
  final bool _isOtpVerifying = false;

  // Login form controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Sign up form controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _signUpEmailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _signUpPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Forgot password form controllers
  final _forgotEmailController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _signUpEmailController.dispose();
    _phoneController.dispose();
    _signUpPasswordController.dispose();
    _confirmPasswordController.dispose();
    _forgotEmailController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundSvg(),
          Center(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 5.0),
                        child: Image.asset(
                          'assets/images/png/marriagegate_icon.png',
                          // height: 60.h,
                          // width: 60.w,
                          // errorBuilder: (context, error, stackTrace) {
                          //   return Container(
                          //     height: 60.h,
                          //     width: 60.w,
                          //     decoration: BoxDecoration(
                          //       color: Colors.red,
                          //       borderRadius: BorderRadius.circular(8.r),
                          //     ),
                          //     child: const Icon(
                          //       Icons.favorite,
                          //       color: Colors.white,
                          //       size: 30,
                          //     ),
                          //   );
                          // },
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Title
                      Text(
                        _isSignUp ? 'SIGN UP' : 'SIGN IN',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Main Form
                      if (!_isOtpVerification) _buildMainForm(),

                      // OTP Verification
                      if (_isOtpVerification) _buildOtpVerification(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainForm() {
    if (_isSignUp) {
      return _buildSignUpForm();
    } else {
      return _buildLoginForm();
    }
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          if (_loginType == LoginType.phoneNumber)
            Container(
              margin: EdgeInsets.only(bottom: 16.h),
              child: Row(
                children: [
                  Text(
                    'Country Code: ',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedCountryCode,
                      underline: Container(),
                      items: const [
                        DropdownMenuItem(value: 'GB', child: Text('🇬🇧 +44')),
                        DropdownMenuItem(value: 'US', child: Text('🇺🇸 +1')),
                        DropdownMenuItem(value: 'IN', child: Text('🇮🇳 +91')),
                        DropdownMenuItem(value: 'PK', child: Text('🇵🇰 +92')),
                        DropdownMenuItem(value: 'BD', child: Text('🇧🇩 +880')),
                        DropdownMenuItem(value: 'AE', child: Text('🇦🇪 +971')),
                        DropdownMenuItem(value: 'SA', child: Text('🇸🇦 +966')),
                        DropdownMenuItem(value: 'CA', child: Text('🇨🇦 +1')),
                        DropdownMenuItem(value: 'AU', child: Text('🇦🇺 +61')),
                      ],
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedCountryCode = newValue;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

          CustomTextField(
            controller: _emailController,
            labelText: 'Email or Phone Number',
            hintText: 'Enter your email or phone number',
            keyboardType: TextInputType.text,
            onChanged: (value) {
              // Auto-detect if it's email or phone
              if (value.contains('@')) {
                setState(() {
                  _loginType = LoginType.email;
                });
              } else if (value.length >= 10 && RegExp(r'^[0-9+\-\s()]+$').hasMatch(value) && !value.contains('@')) {
                setState(() {
                  _loginType = LoginType.phoneNumber;
                });
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email or phone number is required';
              }

              // Check if it's email
              if (value.contains('@')) {
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
              } else {
                // Check if it's phone number
                if (value.length < 10) {
                  return 'Please enter a valid phone number (at least 10 digits)';
                }
                // Allow digits, spaces, hyphens, parentheses, and plus sign
                if (!RegExp(r'^[0-9+\-\s()]+$').hasMatch(value)) {
                  return 'Please enter a valid phone number';
                }
              }
              return null;
            },
          ),

          if (_emailController.text.isNotEmpty)
            Container(
              margin: EdgeInsets.only(top: 8.h),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: _loginType == LoginType.email ? Colors.blue[50] : Colors.green[50],
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(
                  color: _loginType == LoginType.email ? Colors.blue[200]! : Colors.green[200]!,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _loginType == LoginType.email ? Icons.email : Icons.phone,
                    size: 16.sp,
                    color: _loginType == LoginType.email ? Colors.blue[600] : Colors.green[600],
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    _loginType == LoginType.email ? 'Email detected' : 'Phone number detected',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: _loginType == LoginType.email ? Colors.blue[700] : Colors.green[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

          SizedBox(height: 16.h),

          CustomTextField(
            controller: _passwordController,
            labelText: 'Password',
            hintText: 'Enter your password',
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
                return 'Password is required';
              }
              if (value.length < 8) {
                return 'Password must be at least 8 characters';
              }
              return null;
            },
          ),

          SizedBox(height: 20.h),

          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return CustomButton(
                text: 'Sign In',
                onPressed: (authProvider.isLoading || _isSocialLoginLoading) ? null : _handleLogin,
                isLoading: authProvider.isLoading,
              );
            },
          ),

          SizedBox(height: 16.h),

          // Social Login Buttons
          SocialLoginButtons(
            onSuccess: () {
              // Navigate to profile selection or main screen
              Navigator.pushReplacementNamed(context, '/profile-selection');
            },
            onError: () {
              // Handle error (already handled in the widget)
            },
            onLoadingChanged: (bool isLoading) {
              setState(() {
                _isSocialLoginLoading = isLoading;
              });
            },
          ),

          SizedBox(height: 16.h),

          // Forgot Password
          TextButton(
            onPressed: () {
              setState(() {
                _isForgotPassword = true;
              });
            },
            child: Text(
              'Forgot Password?',
              style: TextStyle(
                color: Colors.red,
                fontSize: 14.sp,
              ),
            ),
          ),

          // Forgot Password Form
          if (_isForgotPassword) _buildForgotPasswordForm(),

          SizedBox(height: 20.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account? ",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isSignUp = true;
                  });
                },
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Form(
      key: _signUpFormKey,
      child: Column(
        children: [
          // First Name
          CustomTextField(
            controller: _firstNameController,
            labelText: 'First Name',
            hintText: 'Enter your first name',
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
            labelText: 'Last Name',
            hintText: 'Enter your last name',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Last name is required';
              }
              return null;
            },
          ),

          SizedBox(height: 16.h),

          // Email
          CustomTextField(
            controller: _signUpEmailController,
            labelText: 'Email',
            hintText: 'Enter your email',
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),

          SizedBox(height: 16.h),

          // Phone Number
          PhoneNumberInput(
            labelText: 'Phone Number',
            hintText: 'Enter your phone number',
            phoneController: _phoneController,
            selectedCountryCode: _selectedCountryCode,
            onCountryCodeChanged: (String countryCode) {
              setState(() {
                _selectedCountryCode = countryCode;
              });
            },
            onPhoneNumberChanged: (String value) {
              // The complete phone number is now handled by the controller
              // No need to store it separately
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Phone number is required';
              }
              if (value.length < 10) {
                return 'Please enter a valid phone number (at least 10 digits)';
              }
              return null;
            },
            isRequired: true,
          ),

          SizedBox(height: 8.h),

          // Password
          CustomTextField(
            controller: _signUpPasswordController,
            labelText: 'Password',
            hintText: 'Enter your password',
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
            onChanged: (value) {
              _calculatePasswordStrength(value);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              if (value.length < 8) {
                return 'Password must be at least 8 characters';
              }
              return null;
            },
          ),

          // Password Strength Indicator
          if (_signUpPasswordController.text.isNotEmpty) ...[
            SizedBox(height: 8.h),
            LinearProgressIndicator(
              value: _passwordStrength,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(_passwordStrengthColor),
            ),
            SizedBox(height: 4.h),
            Text(
              'Password Strength: $_passwordStrengthText',
              style: TextStyle(
                fontSize: 12.sp,
                color: _passwordStrengthColor,
              ),
            ),
          ],

          SizedBox(height: 16.h),

          // Confirm Password
          CustomTextField(
            controller: _confirmPasswordController,
            labelText: 'Confirm Password',
            hintText: 'Confirm your password',
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
            onChanged: (value) {
              _checkPasswordMatch();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _signUpPasswordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),

          if (!_isPasswordMatch && _confirmPasswordController.text.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Text(
              'Passwords do not match',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.red,
              ),
            ),
          ],

          SizedBox(height: 20.h),

          // Sign Up Button
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return CustomButton(
                text: 'Sign Up',
                onPressed: (authProvider.isLoading || _isSocialLoginLoading) ? null : _handleSignUp,
                isLoading: authProvider.isLoading,
              );
            },
          ),

          SizedBox(height: 16.h),

          // Social Login Buttons
          SocialLoginButtons(
            onSuccess: () {
              // Navigate to profile selection or main screen
              Navigator.pushReplacementNamed(context, '/profile-selection');
            },
            onError: () {
              // Handle error (already handled in the widget)
            },
            onLoadingChanged: (bool isLoading) {
              setState(() {
                _isSocialLoginLoading = isLoading;
              });
            },
          ),

          SizedBox(height: 20.h),

          // Already have account? Sign in
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account? ',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isSignUp = false;
                  });
                },
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildForgotPasswordForm() {
    return Column(
      children: [
        SizedBox(height: 20.h),
        Text(
          'Reset Password',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),
        if (_forgotStep == ForgotPasswordStep.enterEmail) ...[
          CustomTextField(
            controller: _forgotEmailController,
            labelText: 'Email',
            hintText: 'Enter your email',
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          SizedBox(height: 16.h),
          CustomButton(
            text: 'Send Reset Link',
            onPressed: _handleForgotPassword,
          ),
        ],
        if (_forgotStep == ForgotPasswordStep.verification) ...[
          Text(
            'Enter the verification code sent to your email',
            style: TextStyle(fontSize: 14.sp),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          OtpVerificationWidget(
            onOtpComplete: _handleOtpVerification,
          ),
        ],
        if (_forgotStep == ForgotPasswordStep.resetPassword) ...[
          CustomTextField(
            controller: _newPasswordController,
            labelText: 'New Password',
            hintText: 'Enter new password',
            obscureText: !_isPasswordVisible,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              if (value.length < 8) {
                return 'Password must be at least 8 characters';
              }
              return null;
            },
          ),
          SizedBox(height: 16.h),
          CustomTextField(
            controller: _confirmNewPasswordController,
            labelText: 'Confirm New Password',
            hintText: 'Confirm new password',
            obscureText: !_isConfirmPasswordVisible,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _newPasswordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          SizedBox(height: 16.h),
          CustomButton(
            text: 'Reset Password',
            onPressed: _handleResetPassword,
          ),
        ],
        SizedBox(height: 16.h),
        TextButton(
          onPressed: () {
            setState(() {
              _isForgotPassword = false;
              _forgotStep = ForgotPasswordStep.enterEmail;
            });
          },
          child: Text(
            'Back to Login',
            style: TextStyle(
              color: Colors.red,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpVerification() {
    return Column(
      children: [
        // Header with back button in top left corner
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                  _isOtpVerification = false;
                });
              },
            ),
          ],
        ),
        SizedBox(height: 10.h),
        // OTP Verification title
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
        SizedBox(height: 20.h),
        OtpVerificationWidget(
          onOtpComplete: _handleEmailVerification,
          hideTitle: true, // Hide the title since we're showing it here
        ),
        SizedBox(height: 16.h),
        TextButton(
          onPressed: _handleResendOtp,
          child: Text(
            'I didn\'t receive the code? Send again',
            style: TextStyle(
              color: Colors.red,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();

    try {
      String? email;
      String? phoneNumber;

      if (_loginType == LoginType.email) {
        email = _emailController.text;
      } else {
        // For phone login, get the phone number from the email controller
        // since we're now using a single field
        phoneNumber = _emailController.text;

        // Ensure phone number has proper format
        if (phoneNumber.isNotEmpty && !phoneNumber.startsWith('+')) {
          // Add country code if not present
          phoneNumber = '+$_selectedCountryCode$phoneNumber';
        }
      }

      final result = await authProvider.login(
        email ?? '',
        _passwordController.text,
        phoneNumber: phoneNumber,
      );

      if (result['success'] == true) {
        if (result['needsOtpVerification'] == true) {
          // Show OTP verification
          setState(() {
            _isOtpVerification = true;
          });
        } else if (result['needsRegistration'] == true) {
          // Navigate to member registration screen
          Navigator.pushReplacementNamed(context, '/member-registration');
        } else {
          // User → Member model: Navigate to profile selection
          Navigator.pushReplacementNamed(context, '/profile-selection');
        }
      }
    } catch (e) {
      // Parse error message to extract title and detail
      final errorMessage = e.toString();
      if (errorMessage.contains('|')) {
        final parts = errorMessage.split('|');
        final title = parts[0].replaceAll('Exception: ', '');
        final detail = parts.length > 1 ? parts[1] : 'An unknown error occurred';
        _showErrorDialog(title, detail);
      } else {
        _showErrorDialog('Login Error', errorMessage.replaceAll('Exception: ', ''));
      }
    }
  }

  Future<void> _handleSignUp() async {
    if (!_signUpFormKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();

    try {
      final result = await authProvider.signUp(
        _firstNameController.text,
        _lastNameController.text,
        _signUpEmailController.text,
        _signUpPasswordController.text,
        phoneNumber: _phoneController.text, // Complete phone number with country code
      );

      if (result['success'] == true) {
        if (result['needsOtpVerification'] == true) {
          // Show OTP verification
          setState(() {
            _isOtpVerification = true;
          });
        }
      }
    } catch (e) {
      // Parse error message to extract title and detail
      final errorMessage = e.toString();
      if (errorMessage.contains('|')) {
        final parts = errorMessage.split('|');
        final title = parts[0].replaceAll('Exception: ', '');
        final detail = parts.length > 1 ? parts[1] : 'An unknown error occurred';
        _showErrorDialog(title, detail);
      } else {
        _showErrorDialog('Sign Up Error', errorMessage.replaceAll('Exception: ', ''));
      }
    }
  }

  Future<void> _handleEmailVerification(int otpCode) async {
    final authProvider = context.read<AuthProvider>();

    try {
      final result = await authProvider.emailVerification(otpCode.toString());

      if (result['success'] == true) {
        // User → Member model: Navigate to profile selection
        Navigator.pushReplacementNamed(context, '/profile-selection');
      }
    } catch (e) {
      // Parse error message to extract title and detail
      final errorMessage = e.toString();
      if (errorMessage.contains('|')) {
        final parts = errorMessage.split('|');
        final title = parts[0].replaceAll('Exception: ', '');
        final detail = parts.length > 1 ? parts[1] : 'An unknown error occurred';
        _showErrorDialog(title, detail);
      } else {
        _showErrorDialog('Verification Error', errorMessage.replaceAll('Exception: ', ''));
      }
    }
  }

  Future<void> _handleForgotPassword() async {
    if (_forgotEmailController.text.isEmpty) {
      _showErrorDialog('Error', 'Please enter your email');
      return;
    }

    final authProvider = context.read<AuthProvider>();

    try {
      final result = await authProvider.forgotPassword(
        true, // isEmail
        _forgotEmailController.text,
      );

      if (result['success'] == true) {
        setState(() {
          _forgotStep = ForgotPasswordStep.verification;
        });
      }
    } catch (e) {
      // Parse error message to extract title and detail
      final errorMessage = e.toString();
      if (errorMessage.contains('|')) {
        final parts = errorMessage.split('|');
        final title = parts[0].replaceAll('Exception: ', '');
        final detail = parts.length > 1 ? parts[1] : 'An unknown error occurred';
        _showErrorDialog(title, detail);
      } else {
        _showErrorDialog('Forgot Password Error', errorMessage.replaceAll('Exception: ', ''));
      }
    }
  }

  Future<void> _handleOtpVerification(int otpCode) async {
    final authProvider = context.read<AuthProvider>();

    try {
      final result = await authProvider.verifyOtp(otpCode.toString());

      if (result['success'] == true) {
        setState(() {
          _forgotStep = ForgotPasswordStep.resetPassword;
        });
      }
    } catch (e) {
      // Parse error message to extract title and detail
      final errorMessage = e.toString();
      if (errorMessage.contains('|')) {
        final parts = errorMessage.split('|');
        final title = parts[0].replaceAll('Exception: ', '');
        final detail = parts.length > 1 ? parts[1] : 'An unknown error occurred';
        _showErrorDialog(title, detail);
      } else {
        _showErrorDialog('OTP Verification Error', errorMessage.replaceAll('Exception: ', ''));
      }
    }
  }

  Future<void> _handleResetPassword() async {
    if (_newPasswordController.text != _confirmNewPasswordController.text) {
      _showErrorDialog('Error', 'Passwords do not match');
      return;
    }

    final authProvider = context.read<AuthProvider>();

    try {
      final result = await authProvider.resetPassword(
        _newPasswordController.text,
        _confirmNewPasswordController.text,
      );

      if (result['success'] == true) {
        Fluttertoast.showToast(
          msg: 'Password reset successfully',
          backgroundColor: Colors.green,
        );
        setState(() {
          _isForgotPassword = false;
          _forgotStep = ForgotPasswordStep.enterEmail;
        });
      }
    } catch (e) {
      // Parse error message to extract title and detail
      final errorMessage = e.toString();
      if (errorMessage.contains('|')) {
        final parts = errorMessage.split('|');
        final title = parts[0].replaceAll('Exception: ', '');
        final detail = parts.length > 1 ? parts[1] : 'An unknown error occurred';
        _showErrorDialog(title, detail);
      } else {
        _showErrorDialog('Reset Password Error', errorMessage.replaceAll('Exception: ', ''));
      }
    }
  }

  Future<void> _handleResendOtp() async {
    final authProvider = context.read<AuthProvider>();

    try {
      // Get email and password from sign-up form (like Angular implementation)
      final email = _signUpEmailController.text;
      final password = _signUpPasswordController.text;

      if (email.isEmpty || password.isEmpty) {
        _showErrorDialog('Error', 'Please complete the sign-up form first');
        return;
      }

      await authProvider.resendOtp(email: email, password: password);
      Fluttertoast.showToast(
        msg: 'OTP sent successfully',
        backgroundColor: Colors.green,
      );
    } catch (e) {
      // Parse error message to extract title and detail
      final errorMessage = e.toString();
      if (errorMessage.contains('|')) {
        final parts = errorMessage.split('|');
        final title = parts[0].replaceAll('Exception: ', '');
        final detail = parts.length > 1 ? parts[1] : 'An unknown error occurred';
        _showErrorDialog(title, detail);
      } else {
        _showErrorDialog('Resend OTP Error', errorMessage.replaceAll('Exception: ', ''));
      }
    }
  }

  void _navigateToMainScreen() {
    Navigator.of(context).pushReplacementNamed('/main');
  }

  void _calculatePasswordStrength(String password) {
    int score = 0;
    if (password.length >= 8) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    setState(() {
      _passwordStrength = score / 5.0;

      if (score <= 1) {
        _passwordStrengthText = 'Weak';
        _passwordStrengthColor = Colors.red;
      } else if (score <= 3) {
        _passwordStrengthText = 'Fair';
        _passwordStrengthColor = Colors.orange;
      } else if (score <= 4) {
        _passwordStrengthText = 'Good';
        _passwordStrengthColor = Colors.yellow;
      } else {
        _passwordStrengthText = 'Strong';
        _passwordStrengthColor = Colors.green;
      }
    });
  }

  void _checkPasswordMatch() {
    setState(() {
      _isPasswordMatch = _signUpPasswordController.text == _confirmPasswordController.text;
    });
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => ErrorDialog(
        title: title,
        message: message,
      ),
    );
  }
}
