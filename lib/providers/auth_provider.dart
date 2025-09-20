import 'package:flutter/material.dart';
import 'package:matrimony_flutter/services/auth_service.dart';
import 'package:matrimony_flutter/services/social_auth_service.dart';
import 'package:matrimony_flutter/services/profile_check_service.dart';
import 'package:matrimony_flutter/services/member_service.dart';
import 'package:matrimony_flutter/models/user.dart';
import 'package:matrimony_flutter/utils/constants.dart';

import '../models/member.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final SocialAuthService _socialAuthService = SocialAuthService();
  final ProfileCheckService _profileCheckService = ProfileCheckService();
  final MemberService _memberService = MemberService();

  bool _isLoading = false;
  bool _isLoggedIn = false;
  String _clientToken = '';
  bool _isAgent = false;
  User? _currentUser;
  bool _isOtpVerification = false;
  String _verificationToken = '';
  String _resetToken = '';

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String get clientToken => _clientToken;
  bool get isAgent => _isAgent;
  User? get currentUser => _currentUser;
  bool get isOtpVerification => _isOtpVerification;
  String get verificationToken => _verificationToken;
  String get resetToken => _resetToken;

  AuthProvider() {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    _isLoggedIn = await _authService.isLoggedIn();
    await _getClientToken();
    notifyListeners();
  }

  Future<bool> _getClientToken() async {
    try {
      _isLoading = true;
      notifyListeners();

      final clientData = _isAgent ? ClientData.agent : ClientData.member;

      final tokenResult = await _authService.getLoginClientToken(clientData);
      _clientToken = tokenResult.token;
      return true;
    } catch (e) {
      debugPrint('Error getting client token: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> changeLoginType() async {
    _isAgent = !_isAgent;
    return await _getClientToken();
  }

  Future<Map<String, dynamic>> login(String email, String password, {String? phoneNumber}) async {
    try {
      _isLoading = true;
      notifyListeners();

      if (_clientToken.isEmpty) {
        final tokenSuccess = await _getClientToken();
        if (!tokenSuccess) {
          throw Exception('Failed to get client token');
        }
      }

      final body = {
        'password': password,
        'loginType': phoneNumber != null ? LoginType.phoneNumber.value : LoginType.email.value,
        if (phoneNumber != null) 'phoneNumber': phoneNumber,
        if (phoneNumber == null) 'email': email,
      };

      final response = await _authService.login(body, _clientToken);

      if (response.isError) {
        if (response.error != null) {
          throw Exception('${response.error!.title}|${response.error!.detail}');
        } else {
          throw Exception('Login failed|An unknown error occurred');
        }
      }

      if (response.result != null && response.result!['token'] != null) {
        final tokenType = response.result!['tokenType'] ?? TokenType.loginToken.value;

        if (tokenType == TokenType.userVerificationToken.value) {
          _verificationToken = response.result!['token'];
          _isOtpVerification = true;
          _isLoading = false;
          notifyListeners();

          return {
            'success': true,
            'needsOtpVerification': true,
            'token': response.result!['token'],
          };
        } else {
          await _authService.setAuthToken(response.result!['token']);
          await _authService.setUser(response.result!['token']);

          _isLoggedIn = true;
          _isOtpVerification = false;
          _isLoading = false;
          notifyListeners();

          final userProfiles = await loadUserProfiles();

          return {
            'success': true,
            'needsOtpVerification': false,
            'hasProfiles': userProfiles.isNotEmpty,
            'userProfiles': userProfiles,
            'token': response.result!['token'],
          };
        }
      } else if (response.result != null) {
        return {
          'success': true,
          'needsRegistration': true,
          'message': 'Login successful. Please complete your registration.',
        };
      } else {
        throw Exception('Invalid login response');
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Login error: $e');
    }
  }

  Future<Map<String, dynamic>> signUp(String firstName, String lastName, String email, String password,
      {String? phoneNumber}) async {
    try {
      _isLoading = true;
      notifyListeners();

      if (_clientToken.isEmpty) {
        final tokenSuccess = await _getClientToken();
        if (!tokenSuccess) {
          throw Exception('Failed to get client token');
        }
      }

      final body = {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'loginType': LoginType.email.value,
        if (phoneNumber != null) 'phoneNumber': phoneNumber,
      };

      final response = await _authService.signUp(body, _clientToken);

      if (response.isError) {
        if (response.error != null) {
          throw Exception('${response.error!.title}|${response.error!.detail}');
        } else {
          throw Exception('Sign up failed|An unknown error occurred');
        }
      }

      if (response.result != null && response.result!['token'] != null) {
        _verificationToken = response.result!['token'];
        _isOtpVerification = true;
        _isLoading = false;
        notifyListeners();

        return {
          'success': true,
          'needsOtpVerification': true,
          'token': response.result!['token'],
        };
      } else {
        throw Exception('Invalid sign up response');
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Sign up error: $e');
    }
  }

  Future<Map<String, dynamic>> emailVerification(String otpCode) async {
    try {
      _isLoading = true;
      notifyListeners();

      final body = {
        'token': _verificationToken,
        'otpCode': otpCode,
      };

      final response = await _authService.emailVerification(body, _clientToken);

      if (response.isError) {
        if (response.error != null) {
          throw Exception('${response.error!.title}|${response.error!.detail}');
        } else {
          throw Exception('Email verification failed|An unknown error occurred');
        }
      }

      if (response.result != null && response.result!['token'] != null) {
        await _authService.setAuthToken(response.result!['token']);
        await _authService.setUser(response.result!['token']);

        _isLoggedIn = true;
        _isOtpVerification = false;
        _isLoading = false;
        notifyListeners();

        final userProfiles = await loadUserProfiles();

        return {
          'success': true,
          'hasProfiles': userProfiles.isNotEmpty,
          'userProfiles': userProfiles,
          'token': response.result!['token'],
        };
      } else {
        throw Exception('Invalid verification response');
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Email verification error: $e');
    }
  }

  Future<Map<String, dynamic>> forgotPassword(bool isEmail, String param) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _authService.forgotPassword(isEmail, _clientToken, param);

      if (response.isError) {
        if (response.error != null) {
          throw Exception('${response.error!.title}|${response.error!.detail}');
        } else {
          throw Exception('Forgot password failed|An unknown error occurred');
        }
      }

      if (response.result != null && response.result!['token'] != null) {
        _resetToken = response.result!['token'];
        _isLoading = false;
        notifyListeners();

        return {
          'success': true,
          'token': response.result!['token'],
        };
      } else {
        throw Exception('Invalid forgot password response');
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Forgot password error: $e');
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String otpCode) async {
    try {
      _isLoading = true;
      notifyListeners();

      final body = {
        'token': _resetToken,
        'otpCode': otpCode,
      };

      final response = await _authService.verifyOtp(body, _clientToken);

      if (response.isError) {
        if (response.error != null) {
          throw Exception('${response.error!.title}|${response.error!.detail}');
        } else {
          throw Exception('OTP verification failed|An unknown error occurred');
        }
      }

      if (response.result != null && response.result!['token'] != null) {
        await _authService.setAuthToken(response.result!['token']);
        await _authService.setUser(response.result!['token']);

        _isLoggedIn = true;
        _isOtpVerification = false;
        _isLoading = false;
        notifyListeners();

        final userProfiles = await loadUserProfiles();

        return {
          'success': true,
          'hasProfiles': userProfiles.isNotEmpty,
          'userProfiles': userProfiles,
          'token': response.result!['token'],
        };
      } else {
        throw Exception('Invalid OTP verification response');
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('OTP verification error: $e');
    }
  }

  Future<Map<String, dynamic>> resetPassword(String password, String confirmPassword) async {
    try {
      _isLoading = true;
      notifyListeners();

      final body = {
        'password': password,
        'confirmPassword': confirmPassword,
      };

      final response = await _authService.resetPassword(body, _clientToken);

      if (response.isError) {
        if (response.error != null) {
          throw Exception('${response.error!.title}|${response.error!.detail}');
        } else {
          throw Exception('Password reset failed|An unknown error occurred');
        }
      }

      _isLoading = false;
      notifyListeners();

      return {
        'success': true,
      };
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Password reset error: $e');
    }
  }

  Future<Map<String, dynamic>> resendOtp({required String email, required String password}) async {
    try {
      _isLoading = true;
      notifyListeners();

      final body = {
        'password': password,
        'email': email,
        'loginType': LoginType.email.value,
      };

      final response = await _authService.login(body, _clientToken);

      if (response.isError) {
        if (response.error != null) {
          throw Exception('${response.error!.title}|${response.error!.detail}');
        } else {
          throw Exception('Resend OTP failed|An unknown error occurred');
        }
      }

      if (response.result != null && response.result!['token'] != null) {
        final tokenType = response.result!['tokenType'];

        if (tokenType == TokenType.userVerificationToken.value) {
          _verificationToken = response.result!['token'];
        }

        _isLoading = false;
        notifyListeners();

        return {
          'success': true,
          'token': response.result!['token'],
        };
      } else {
        throw Exception('Invalid resend OTP response');
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Resend OTP error: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _authService.clearAllData();
      _isLoggedIn = false;
      _isOtpVerification = false;
      _clientToken = '';
      _verificationToken = '';
      _resetToken = '';
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Logout error: $e');
    }
  }

  Future<bool> checkLoginStatus() async {
    _isLoggedIn = await _authService.isLoggedIn();
    if (_isLoggedIn) {
      await _getClientToken();
    }
    notifyListeners();
    return _isLoggedIn;
  }

  Future<Map<String, dynamic>> checkUserStatus() async {
    return await _profileCheckService.checkUserStatus();
  }

  Future<bool> hasProfiles() async {
    return await _profileCheckService.hasProfiles();
  }

  Future<String?> getUserType() async {
    return await _authService.getUserType();
  }

  void clearOtpVerification() {
    _isOtpVerification = false;
    _verificationToken = '';
    notifyListeners();
  }

  void setOtpVerification(bool value) {
    _isOtpVerification = value;
    notifyListeners();
  }

  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      _isLoading = true;
      notifyListeners();

      if (_clientToken.isEmpty) {
        final tokenSuccess = await _getClientToken();
        if (!tokenSuccess) {
          throw Exception('Failed to get client token');
        }
      }

      final result = await _socialAuthService.signInWithGoogle(_clientToken);

      if (result['success'] == true) {
        if (result['data'] != null && result['data']['token'] != null) {
          final tokenType = result['data']['tokenType'];

          if (tokenType == TokenType.userVerificationToken.value) {
            _verificationToken = result['data']['token'];
            _isOtpVerification = true;
            _isLoading = false;
            notifyListeners();

            return {
              'success': true,
              'needsOtpVerification': true,
              'token': result['data']['token'],
            };
          } else {
            await _authService.setAuthToken(result['data']['token']);
            await _authService.setUser(result['data']['token']);

            _isLoggedIn = true;
            _isOtpVerification = false;
            _isLoading = false;
            notifyListeners();

            final userProfiles = await loadUserProfiles();

            return {
              'success': true,
              'needsOtpVerification': false,
              'hasProfiles': userProfiles.isNotEmpty,
              'userProfiles': userProfiles,
              'token': result['data']['token'],
            };
          }
        }
      }

      _isLoading = false;
      notifyListeners();

      return {
        'success': false,
        'error': result['error'] ?? 'Google sign in failed',
      };
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Google sign in error: $e');
    }
  }

  Future<Map<String, dynamic>> signInWithFacebook() async {
    try {
      _isLoading = true;
      notifyListeners();

      if (_clientToken.isEmpty) {
        final tokenSuccess = await _getClientToken();
        if (!tokenSuccess) {
          throw Exception('Failed to get client token');
        }
      }

      final result = await _socialAuthService.signInWithFacebook(_clientToken);

      if (result['success'] == true) {
        if (result['data'] != null && result['data']['token'] != null) {
          final tokenType = result['data']['tokenType'];

          if (tokenType == TokenType.userVerificationToken.value) {
            _verificationToken = result['data']['token'];
            _isOtpVerification = true;
            _isLoading = false;
            notifyListeners();

            return {
              'success': true,
              'needsOtpVerification': true,
              'token': result['data']['token'],
            };
          } else {
            // Normal login - set auth token and mark as logged in
            await _authService.setAuthToken(result['data']['token']);
            await _authService.setUser(result['data']['token']);

            _isLoggedIn = true;
            _isOtpVerification = false;
            _isLoading = false;
            notifyListeners();

            final userProfiles = await loadUserProfiles();

            return {
              'success': true,
              'needsOtpVerification': false,
              'hasProfiles': userProfiles.isNotEmpty,
              'userProfiles': userProfiles,
              'token': result['data']['token'],
            };
          }
        }
      }

      _isLoading = false;
      notifyListeners();

      return {
        'success': false,
        'error': result['error'] ?? 'Facebook sign in failed',
      };
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Facebook sign in error: $e');
    }
  }

  Future<void> signOutFromSocial() async {
    await _socialAuthService.signOut();
  }

  Future<List<MemberProfile>> loadUserProfiles() async {
    try {
      final profiles = await _memberService.getMemberProfiles();

      if (profiles.isEmpty) {
        return [];
      } else {
        return profiles;
      }
    } catch (e) {
      debugPrint('Error loading user profiles: $e');
      return [];
    }
  }
}
