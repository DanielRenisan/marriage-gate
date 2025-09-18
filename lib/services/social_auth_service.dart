import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:matrimony_flutter/services/auth_service.dart';
import 'package:matrimony_flutter/models/api_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:matrimony_flutter/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SocialAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile'], signInOption: SignInOption.standard);
  final AuthService _authService = AuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Google Sign In - Firebase implementation
  Future<Map<String, dynamic>> signInWithGoogle(String clientToken) async {
    try {

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return {'success': false, 'error': 'Sign in cancelled by user', 'errorCode': 'USER_CANCELLED'};
      }


      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      if (googleAuth.idToken == null) {
        await _googleSignIn.signOut();
        return {'success': false, 'error': 'Failed to obtain Google ID token', 'errorCode': 'NO_ID_TOKEN'};
      }

      // Validate the ID token
      if (googleAuth.idToken == null || googleAuth.idToken!.isEmpty) {
        await _googleSignIn.signOut();
        return {'success': false, 'error': 'Google ID token is null or empty', 'errorCode': 'EMPTY_ID_TOKEN'};
      }
      String firstName = '';
      String lastName = '';

      if (googleUser.displayName != null && googleUser.displayName!.isNotEmpty) {
        final nameParts = googleUser.displayName!.trim().split(RegExp(r'\s+'));
        firstName = nameParts.isNotEmpty ? nameParts.first : '';
        lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
      }

      // Prepare the request body exactly like Angular
      final body = {
        'loginType': 3, // LoginType.Google = 3
        'socialToken': googleAuth.idToken ?? '', // Use Google ID token directly, empty string if null
        'socialClientId': '', // Empty for Google as per Angular
        'firstName': firstName,
        'lastName': lastName,
        'email': googleUser.email,
        'photoUrl': googleUser.photoUrl,
      };
      final response = await _makeSocialLoginRequest(body, clientToken);

      return {
        'success': !response.isError,
        'data': response.result,
        'error': response.error,
        'user': {
          'id': googleUser.id,
          'email': googleUser.email,
          'displayName': googleUser.displayName,
          'photoUrl': googleUser.photoUrl,
        }
      };
    } on PlatformException catch (e) {
      await _googleSignIn.signOut();
      return {
        'success': false,
        'error': 'Google Sign-In failed: ${e.message ?? e.code}',
        'errorCode': e.code,
      };
    } catch (e) {
      await _googleSignIn.signOut();
      return {
        'success': false,
        'error': 'Sign in failed: ${e.toString()}',
        'errorCode': 'UNKNOWN_ERROR',
      };
    }
  }

  // Facebook Sign In - Exact Angular implementation
  Future<Map<String, dynamic>> signInWithFacebook(String clientToken) async {
    try {

      // Sign out first to ensure fresh login
      await FacebookAuth.instance.logOut();

      // Trigger the authentication flow
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );


      if (result.status != LoginStatus.success) {
        return {'success': false, 'error': 'Facebook sign in failed: ${result.status}', 'errorCode': 'FACEBOOK_LOGIN_FAILED'};
      }


      // Validate access token
      if (result.accessToken?.token == null || result.accessToken!.token.isEmpty) {
        await FacebookAuth.instance.logOut();
        return {'success': false, 'error': 'Failed to obtain Facebook access token', 'errorCode': 'NO_FACEBOOK_TOKEN'};
      }


      // Get user data with error handling
      Map<String, dynamic> userData = {};
      try {
        userData = await FacebookAuth.instance.getUserData(
          fields: "id,name,email,first_name,last_name",
        );
      } catch (e) {
        // Continue with basic data
        userData = {
          'first_name': '',
          'last_name': '',
          'email': '',
          'name': '',
          'id': '',
        };
      }

      // Prepare the request body exactly like Angular
      final body = {
        'loginType': 4, // LoginType.Facebook = 4
        'socialToken': result.accessToken!.token, // Facebook access token
        'socialClientId': '2480872695583098', // fbAppId from Angular
        'firstName': userData['first_name'] ?? '',
        'lastName': userData['last_name'] ?? '',
        'email': userData['email'] ?? '',
      };


      // Send to backend using the exact same endpoint as Angular
      final response = await _makeSocialLoginRequest(body, clientToken);

      return {
        'success': !response.isError,
        'data': response.result,
        'error': response.error,
        'user': {
          'id': userData['id'],
          'email': userData['email'],
          'name': userData['name'],
          'firstName': userData['first_name'],
          'lastName': userData['last_name'],
        }
      };
    } on PlatformException catch (e) {
      await FacebookAuth.instance.logOut();
      return {
        'success': false,
        'error': 'Facebook Sign-In failed: ${e.message ?? e.code}',
        'errorCode': e.code,
      };
    } catch (e) {
      await FacebookAuth.instance.logOut();
      return {
        'success': false,
        'error': 'Facebook sign in failed: ${e.toString()}',
        'errorCode': 'UNKNOWN_ERROR',
      };
    }
  }

  // Make social login request - Exact Angular implementation
  Future<ApiResponse<Map<String, dynamic>>> _makeSocialLoginRequest(Map<String, dynamic> body, String clientToken) async {
    try {
      final url = Uri.parse('${ApiEndpoints.baseUrl}Auth/social-login');

      final jsonBody = json.encode(body);

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': '*',
          'Authorization': 'Bearer $clientToken',
        },
        body: jsonBody,
      );


      final data = json.decode(response.body);

      // Parse the API response
      final apiResponse = ApiResponse.fromJson(data, (json) => json);

      return apiResponse;
    } catch (e) {
      throw Exception('Social login request failed: $e');
    }
  }

  // Sign out from all social platforms
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      await FacebookAuth.instance.logOut();
    } catch (e) {
    }
  }
}
