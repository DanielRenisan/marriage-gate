import 'package:flutter/material.dart';
import 'package:matrimony_flutter/services/auth_service.dart';
import 'package:matrimony_flutter/services/member_service.dart';
import 'package:matrimony_flutter/models/member.dart';

class ProfileCheckService {
  final AuthService _authService = AuthService();
  final MemberService _memberService = MemberService();

  // Check if user has profiles (exact Angular implementation)
  Future<bool> hasProfiles() async {
    try {
      final token = await _authService.getAuthToken();
      if (token == null) {
        return false;
      }

      final profiles = await _memberService.getProfiles();
      return profiles.isNotEmpty;
    } catch (e) {
      debugPrint('Error checking profiles: $e');
      return false;
    }
  }

  // Get user profiles
  Future<List<UserProfile>> getUserProfiles() async {
    try {
      final token = await _authService.getAuthToken();
      if (token == null) {
        return [];
      }

      return await _memberService.getProfiles();
    } catch (e) {
      debugPrint('Error getting user profiles: $e');
      return [];
    }
  }

  // Check if user is logged in and has profiles
  Future<Map<String, dynamic>> checkUserStatus() async {
    final isLoggedIn = await _authService.isLoggedIn();
    
    if (!isLoggedIn) {
      return {
        'isLoggedIn': false,
        'hasProfiles': false,
        'shouldNavigateToLogin': true,
        'shouldNavigateToRegistration': false,
        'shouldNavigateToHome': false,
      };
    }

    final hasProfiles = await this.hasProfiles();
    
    if (hasProfiles) {
      return {
        'isLoggedIn': true,
        'hasProfiles': true,
        'shouldNavigateToLogin': false,
        'shouldNavigateToRegistration': false,
        'shouldNavigateToHome': true,
      };
    } else {
      return {
        'isLoggedIn': true,
        'hasProfiles': false,
        'shouldNavigateToLogin': false,
        'shouldNavigateToRegistration': true,
        'shouldNavigateToHome': false,
      };
    }
  }
}
