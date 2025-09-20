import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:matrimony_flutter/models/token_result.dart';
import 'package:matrimony_flutter/models/api_response.dart';
import 'package:matrimony_flutter/models/user.dart';
import 'package:matrimony_flutter/utils/enum.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _baseUrl = ApiEndpoints.baseUrl;
//
  Future<bool> isLoggedIn() async {
    final token = await getAuthToken();
    return token != null;
  }

//
  Future<String?> getAuthToken() async {
    return await _storage.read(key: 'token');
  }

  // Get Client Token -
  Future<TokenResult> getLoginClientToken(Map<String, dynamic> clientData) async {
    try {
      final url =
          Uri.parse('$_baseUrl${ApiEndpoints.clientToken}?name=${clientData['name']}&secretKey=${clientData['secretKey']}');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': '*',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Result'] != null) {
          final tokenResult = TokenResult.fromJson(data['Result']);
          // Store client token in secure storage (equivalent to localStorage.setItem('clientId', token))
          await _storage.write(key: 'clientId', value: tokenResult.token);
          return tokenResult;
        } else {
          throw Exception('Invalid response format: Result not found');
        }
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['Message'] ?? 'Failed to get client token (Status: ${response.statusCode})';
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Invalid response format from server');
      }
      throw Exception('Error getting client token: $e');
    }
  }

  // Sign Up -
  Future<ApiResponse<Map<String, dynamic>>> signUp(Map<String, dynamic> body, String clientToken) async {
    try {
      final url = Uri.parse('$_baseUrl${ApiEndpoints.register}');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': '*',
          'Authorization': 'Bearer $clientToken',
          'user-agent': 'Dart/3.5 (dart:io)',
        },
        body: json.encode(body),
      );

      final data = json.decode(response.body);

      // Parse the API response using the new model
      return ApiResponse.fromJson(data, (json) => json);
    } catch (e) {
      if (e is FormatException) {
        return ApiResponse.error('Invalid Response', 'Invalid response format from server', 400);
      }
      return ApiResponse.error('Registration Error', 'Error during registration: $e', 500);
    }
  }

  // Login -  with User → Member model
  Future<ApiResponse<Map<String, dynamic>>> login(Map<String, dynamic> body, String clientToken) async {
    try {
      final url = Uri.parse('$_baseUrl${ApiEndpoints.login}');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': '*',
          'Authorization': 'Bearer $clientToken',
          'user-agent': 'Dart/3.5 (dart:io)',
        },
        body: json.encode(body),
      );

      final data = json.decode(response.body);

      // Parse the API response
      final apiResponse = ApiResponse.fromJson(data, (json) => json);

      // Check token type for navigation logic ()
      if (apiResponse.result != null && apiResponse.result!['tokenType'] != null) {
        final tokenType = apiResponse.result!['tokenType'];

        // If tokenType is UserVerificationToken (5), user needs OTP verification
        if (tokenType == TokenType.userVerificationToken.value) {
          // Store verification token for OTP verification
          await _storage.write(key: 'verificationToken', value: apiResponse.result!['token']);
        } else {
          // Normal login - set auth token and user data
          await setAuthToken(apiResponse.result!['token']);
          await setUser(apiResponse.result!['token']);

          // Store user data for User → Member model
          if (apiResponse.result!['user'] != null) {
            await _storage.write(key: 'userData', value: json.encode(apiResponse.result!['user']));
          }
        }
      }

      return apiResponse;
    } catch (e) {
      if (e is FormatException) {
        return ApiResponse.error('Invalid Response', 'Invalid response format from server', 400);
      }
      return ApiResponse.error('Login Error', 'Error during login: $e', 500);
    }
  }

  // Forgot Password -
  Future<ApiResponse<Map<String, dynamic>>> forgotPassword(bool isEmail, String clientToken, String param) async {
    try {
      final queryParam = isEmail ? 'email' : 'phoneNumber';
      final url = Uri.parse('$_baseUrl${ApiEndpoints.forgotPassword}?$queryParam=$param');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': '*',
          'Authorization': 'Bearer $clientToken',
        },
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['Result'] != null) {
        // Store reset token for OTP verification
        await _storage.write(key: 'resetToken', value: data['Result']['token']);
        return ApiResponse.fromJson(data, (json) => json);
      } else {
        return ApiResponse.error('Forgot Password Error', data['Message'] ?? 'Failed to send reset email', response.statusCode);
      }
    } catch (e) {
      if (e is FormatException) {
        return ApiResponse.error('Invalid Response', 'Invalid response format from server', 400);
      }
      return ApiResponse.error('Forgot Password Error', 'Error during forgot password: $e', 500);
    }
  }

  // OTP Verification -
  Future<ApiResponse<Map<String, dynamic>>> verifyOtp(Map<String, dynamic> body, String clientToken) async {
    try {
      final url = Uri.parse('$_baseUrl${ApiEndpoints.otpVerification}');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': '*',
          'Authorization': 'Bearer $clientToken',
        },
        body: json.encode(body),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['Result'] != null) {
        await setAuthToken(data['Result']['token']);
        await setUser(data['Result']['token']);
        return ApiResponse.fromJson(data, (json) => json);
      } else {
        return ApiResponse.error('OTP Verification Error', data['Message'] ?? 'Invalid OTP', response.statusCode);
      }
    } catch (e) {
      if (e is FormatException) {
        return ApiResponse.error('Invalid Response', 'Invalid response format from server', 400);
      }
      return ApiResponse.error('OTP Verification Error', 'Error during OTP verification: $e', 500);
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> emailVerification(Map<String, dynamic> body, String clientToken) async {
    try {
      final url = Uri.parse('$_baseUrl${ApiEndpoints.emailVerification}');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': '*',
          'Authorization': 'Bearer $clientToken',
        },
        body: json.encode(body),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['Result'] != null) {
        // Set auth token after successful email verification
        await setAuthToken(data['Result']['token']);
        await setUser(data['Result']['token']);
        return ApiResponse.fromJson(data, (json) => json);
      } else {
        return ApiResponse.error('Email Verification Error', data['Message'] ?? 'Invalid verification code', response.statusCode);
      }
    } catch (e) {
      if (e is FormatException) {
        return ApiResponse.error('Invalid Response', 'Invalid response format from server', 400);
      }
      return ApiResponse.error('Email Verification Error', 'Error during email verification: $e', 500);
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> resetPassword(Map<String, dynamic> body, String clientToken) async {
    try {
      final url = Uri.parse('$_baseUrl${ApiEndpoints.resetPassword}');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': '*',
          'Authorization': 'Bearer $clientToken',
        },
        body: json.encode(body),
      );

      final data = json.decode(response.body);

      return ApiResponse.fromJson(data, (json) => json);
    } catch (e) {
      if (e is FormatException) {
        return ApiResponse.error('Invalid Response', 'Invalid response format from server', 400);
      }
      return ApiResponse.error('Reset Password Error', 'Error during password reset: $e', 500);
    }
  }

  Future<void> setAuthToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  Future<void> removeAuthToken() async {
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'userType');
    await _storage.delete(key: 'clientId');
  }

  Future<void> setUser(String token) async {
    final userDetails = getTokenDecodeData(token);
    await _storage.write(key: 'userType', value: userDetails['UserType']);
  }

  Future<String?> getUserType() async {
    final token = await getAuthToken();
    if (token != null) {
      final userDetails = getTokenDecodeData(token);
      return userDetails['UserType'];
    }
    return null;
  }

  Map<String, dynamic> getTokenDecodeData(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        throw Exception('Invalid token format');
      }

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final resp = utf8.decode(base64Url.decode(normalized));
      final payloadMap = json.decode(resp);
      if (payloadMap['UserType'] == 'Member') {
        payloadMap['LoginUserType'] = 'Member';
      } else if (payloadMap['UserType'] == 'Agent') {
        payloadMap['LoginUserType'] = 'Agent';
      } else {
        payloadMap['LoginUserType'] = 'Admin';
      }

      return payloadMap;
    } catch (e) {
      return {};
    }
  }

  // Enhanced JWT token decoder with detailed parsing
  Map<String, dynamic> decodeJwtToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        throw Exception('Invalid JWT token format - must have 3 parts separated by dots');
      }

      // Decode header
      final header = _decodeBase64Url(parts[0]);
      final headerMap = json.decode(header);

      // Decode payload
      final payload = _decodeBase64Url(parts[1]);
      final payloadMap = json.decode(payload);

      // Parse complex JSON fields
      final parsedPayload = _parseTokenPayload(payloadMap);

      // Add header information
      parsedPayload['_header'] = headerMap;

      // Add token validation info
      parsedPayload['_tokenInfo'] = _getTokenValidationInfo(parsedPayload);

      return parsedPayload;
    } catch (e) {
      throw Exception('Failed to decode JWT token: $e');
    }
  }

  // Helper function to decode base64url
  String _decodeBase64Url(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    // Add padding if needed
    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Invalid base64url string');
    }

    return utf8.decode(base64.decode(output));
  }

  // Parse complex fields in token payload
  Map<String, dynamic> _parseTokenPayload(Map<String, dynamic> payload) {
    final parsed = Map<String, dynamic>.from(payload);

    try {
      // Parse Role field if it's a JSON string
      if (parsed['Role'] is String && (parsed['Role'] as String).isNotEmpty) {
        try {
          parsed['RoleParsed'] = json.decode(parsed['Role']);
        } catch (e) {
          parsed['RoleParsed'] = null;
        }
      }

      // Parse LanguageDetails field if it's a JSON string
      if (parsed['LanguageDetails'] is String && (parsed['LanguageDetails'] as String).isNotEmpty) {
        try {
          parsed['LanguageDetailsParsed'] = json.decode(parsed['LanguageDetails']);
        } catch (e) {
          parsed['LanguageDetailsParsed'] = null;
        }
      }

      // Add user-friendly name field
      if (parsed['FirstName'] != null && parsed['LastName'] != null) {
        parsed['FullName'] = '${parsed['FirstName']} ${parsed['LastName']}';
      }

      // Convert boolean strings to actual booleans
      _convertBooleanFields(parsed, ['PhonenumberVerified', 'TwofactorEnabled', 'IsSuperUser']);

      // Convert V2 string to boolean
      if (parsed['V2'] == 'True') {
        parsed['V2'] = true;
      } else if (parsed['V2'] == 'False') {
        parsed['V2'] = false;
      }
    } catch (e) {}

    return parsed;
  }

  // Convert string boolean values to actual booleans
  void _convertBooleanFields(Map<String, dynamic> data, List<String> fields) {
    for (final field in fields) {
      if (data[field] is String) {
        final value = data[field] as String;
        if (value.toLowerCase() == 'true') {
          data[field] = true;
        } else if (value.toLowerCase() == 'false') {
          data[field] = false;
        }
      }
    }
  }

  // Get token validation information
  Map<String, dynamic> _getTokenValidationInfo(Map<String, dynamic> payload) {
    final info = <String, dynamic>{};

    try {
      // Check expiration
      if (payload['exp'] != null) {
        final expTimestamp = payload['exp'] as int;
        final expDateTime = DateTime.fromMillisecondsSinceEpoch(expTimestamp * 1000);
        final now = DateTime.now();

        info['expiresAt'] = expDateTime.toIso8601String();
        info['isExpired'] = now.isAfter(expDateTime);
        info['timeUntilExpiry'] = expDateTime.difference(now).inMinutes;
      }

      // Check not before
      if (payload['nbf'] != null) {
        final nbfTimestamp = payload['nbf'] as int;
        final nbfDateTime = DateTime.fromMillisecondsSinceEpoch(nbfTimestamp * 1000);
        final now = DateTime.now();

        info['notBefore'] = nbfDateTime.toIso8601String();
        info['isValidNow'] = now.isAfter(nbfDateTime);
      }

      // Token type information
      info['tokenType'] = payload['TokenType'] ?? 'Unknown';
      info['userType'] = payload['UserType'] ?? 'Unknown';
      info['clientAppType'] = payload['ClientAppType'] ?? 'Unknown';
    } catch (e) {}

    return info;
  }

  // Convenience methods to extract specific data
  String? getUserIdFromToken(String token) {
    try {
      final decoded = decodeJwtToken(token);
      return decoded['UserId'] as String?;
    } catch (e) {
      return null;
    }
  }

  String? getFullNameFromToken(String token) {
    try {
      final decoded = decodeJwtToken(token);
      return decoded['FullName'] as String?;
    } catch (e) {
      return null;
    }
  }

  String? getEmailFromToken(String token) {
    try {
      final decoded = decodeJwtToken(token);
      return decoded['Email'] as String?;
    } catch (e) {
      return null;
    }
  }

  bool isTokenExpired(String token) {
    try {
      final decoded = decodeJwtToken(token);
      return decoded['_tokenInfo']?['isExpired'] ?? true;
    } catch (e) {
      return true; // Assume expired if we can't decode
    }
  }

  List<Map<String, dynamic>>? getUserRolesFromToken(String token) {
    try {
      final decoded = decodeJwtToken(token);
      return (decoded['RoleParsed'] as List?)?.cast<Map<String, dynamic>>();
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic>? getLanguageDetailsFromToken(String token) {
    try {
      final decoded = decodeJwtToken(token);
      return decoded['LanguageDetailsParsed'] as Map<String, dynamic>?;
    } catch (e) {
      return null;
    }
  }

  // Get current user ID from stored auth token
  Future<String?> getCurrentUserId() async {
    try {
      final token = await getAuthToken();
      if (token != null) {
        return getUserIdFromToken(token);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Get stored tokens
  Future<String?> getClientToken() async {
    return await _storage.read(key: 'clientId');
  }

  Future<String?> getVerificationToken() async {
    return await _storage.read(key: 'verificationToken');
  }

  Future<String?> getResetToken() async {
    return await _storage.read(key: 'resetToken');
  }

  // Email validation helper
  bool isEmail(String value) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
  }

  // User Data Management for User → Member model
  Future<void> setUserData(Map<String, dynamic> userData) async {
    await _storage.write(key: 'userData', value: json.encode(userData));
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final userDataString = await _storage.read(key: 'userData');
    if (userDataString != null) {
      return json.decode(userDataString);
    }
    return null;
  }

  Future<void> setCurrentMemberId(String memberId) async {
    await _storage.write(key: 'currentMemberId', value: memberId);
  }

  Future<String?> getCurrentMemberId() async {
    return await _storage.read(key: 'currentMemberId');
  }

  // Social Login - Google and Facebook authentication
  Future<ApiResponse<Map<String, dynamic>>> socialLogin(
      String provider, Map<String, dynamic> userDetails, String clientToken) async {
    try {
      final url = Uri.parse('$_baseUrl${ApiEndpoints.socialLogin}');

      final body = {
        'provider': provider,
        'userDetails': userDetails,
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': '*',
          'Authorization': 'Bearer $clientToken',
          'user-agent': 'Dart/3.5 (dart:io)',
        },
        body: json.encode(body),
      );

      final data = json.decode(response.body);

      // Parse the API response
      final apiResponse = ApiResponse.fromJson(data, (json) => json);

      // Handle successful social login
      if (!apiResponse.isError && apiResponse.result != null && apiResponse.result!['token'] != null) {
        final tokenType = apiResponse.result!['tokenType'];

        // If tokenType is UserVerificationToken (5), user needs OTP verification
        if (tokenType == TokenType.userVerificationToken.value) {
          // Store verification token for OTP verification
          await _storage.write(key: 'verificationToken', value: apiResponse.result!['token']);
        } else {
          // Normal login - set auth token and user data
          await setAuthToken(apiResponse.result!['token']);
          await setUser(apiResponse.result!['token']);

          // Store user data for User → Member model
          if (apiResponse.result!['user'] != null) {
            await _storage.write(key: 'userData', value: json.encode(apiResponse.result!['user']));
          }
        }
      }

      return apiResponse;
    } catch (e) {
      if (e is FormatException) {
        return ApiResponse.error('Invalid Response', 'Invalid response format from server', 400);
      }
      return ApiResponse.error('Social Login Error', 'Error during social login: $e', 500);
    }
  }

//
  Future<ApiResponse<User>> getUserDetails(String authToken) async {
    try {
      final url = Uri.parse('$_baseUrl${ApiEndpoints.getUserDetails}');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': '*',
          'Authorization': 'Bearer $authToken',
        },
      );

      final data = json.decode(response.body);

      // Parse the API response
      return ApiResponse.fromJson(data, (json) => User.fromJson(json));
    } catch (e) {
      if (e is FormatException) {
        return ApiResponse.error('Invalid Response', 'Invalid response format from server', 400);
      }
      return ApiResponse.error('Get User Details Error', 'Error getting user details: $e', 500);
    }
  }

  // Clear all stored data (logout)
  Future<void> clearAllData() async {
    await _storage.deleteAll();
  }
}
