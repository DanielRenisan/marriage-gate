import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:matrimony_flutter/providers/auth_provider.dart';
import 'package:matrimony_flutter/widgets/error_dialog.dart';

class SocialLoginButtons extends StatefulWidget {
  final VoidCallback? onSuccess;
  final VoidCallback? onError;
  final Function(bool)? onLoadingChanged;

  const SocialLoginButtons({
    super.key,
    this.onSuccess,
    this.onError,
    this.onLoadingChanged,
  });

  @override
  State<SocialLoginButtons> createState() => _SocialLoginButtonsState();
}

class _SocialLoginButtonsState extends State<SocialLoginButtons> {
  bool _isGoogleLoading = false;
  bool _isFacebookLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider with "or" text
        Row(
          children: [
            Expanded(
              child: Divider(
                color: Colors.grey[400],
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                'OR',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: Colors.grey[400],
                thickness: 1,
              ),
            ),
          ],
        ),
        
        SizedBox(height: 20.h),
        
        // Social Login Buttons
        Row(
          children: [
            // Google Sign In Button
            Expanded(
              child: _buildSocialButton(
                context: context,
                iconPath: 'assets/images/png/google.png',
                text: 'Google',
                onPressed: _isGoogleLoading || _isFacebookLoading ? null : () => _handleGoogleSignIn(context),
                backgroundColor: Colors.white,
                textColor: Colors.black87,
                borderColor: Colors.grey[300]!,
                isLoading: _isGoogleLoading,
              ),
            ),
            
            SizedBox(width: 16.w),
            
            // Facebook Sign In Button
            Expanded(
              child: _buildSocialButton(
                context: context,
                iconPath: 'assets/images/png/facebook.png',
                text: 'Facebook',
                onPressed: _isGoogleLoading || _isFacebookLoading ? null : () => _handleFacebookSignIn(context),
                backgroundColor: const Color(0xFF1877F2),
                textColor: Colors.white,
                borderColor: const Color(0xFF1877F2),
                isLoading: _isFacebookLoading,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required BuildContext context,
    required String iconPath,
    required String text,
    required VoidCallback? onPressed,
    required Color backgroundColor,
    required Color textColor,
    required Color borderColor,
    required bool isLoading,
  }) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8.r),
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon
                Image.asset(
                  iconPath,
                  width: 20.w,
                  height: 20.h,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      text == 'Google' ? Icons.g_mobiledata : Icons.facebook,
                      size: 20.sp,
                      color: textColor,
                    );
                  },
                ),
                
                SizedBox(width: 8.w),
                
                // Text
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
                
                // Loading indicator
                if (isLoading) ...[
                  SizedBox(width: 8.w),
                  SizedBox(
                    width: 16.w,
                    height: 16.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(textColor),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    if (_isGoogleLoading) return;
    
    setState(() {
      _isGoogleLoading = true;
    });
    widget.onLoadingChanged?.call(true);
    
    final authProvider = context.read<AuthProvider>();
    
    try {
      final result = await authProvider.signInWithGoogle();
      
      if (result['success'] == true) {
        if (result['needsOtpVerification'] == true) {
          // Handle OTP verification if needed
          widget.onSuccess?.call();
        } else {
          // Navigate to profile selection or main screen
          widget.onSuccess?.call();
        }
      } else {
        _showErrorDialog(context, 'Google Sign In Error', result['error'] ?? 'Google sign in failed');
        widget.onError?.call();
      }
    } catch (e) {
      _showErrorDialog(context, 'Google Sign In Error', e.toString());
      widget.onError?.call();
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleLoading = false;
        });
        widget.onLoadingChanged?.call(false);
      }
    }
  }

  Future<void> _handleFacebookSignIn(BuildContext context) async {
    if (_isFacebookLoading) return;
    
    setState(() {
      _isFacebookLoading = true;
    });
    widget.onLoadingChanged?.call(true);
    
    final authProvider = context.read<AuthProvider>();
    
    try {
      final result = await authProvider.signInWithFacebook();
      
      if (result['success'] == true) {
        if (result['needsOtpVerification'] == true) {
          // Handle OTP verification if needed
          widget.onSuccess?.call();
        } else {
          // Navigate to profile selection or main screen
          widget.onSuccess?.call();
        }
      } else {
        _showErrorDialog(context, 'Facebook Sign In Error', result['error'] ?? 'Facebook sign in failed');
        widget.onError?.call();
      }
    } catch (e) {
      _showErrorDialog(context, 'Facebook Sign In Error', e.toString());
      widget.onError?.call();
    } finally {
      if (mounted) {
        setState(() {
          _isFacebookLoading = false;
        });
        widget.onLoadingChanged?.call(false);
      }
    }
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => ErrorDialog(
        title: title,
        message: message,
      ),
    );
  }
}
