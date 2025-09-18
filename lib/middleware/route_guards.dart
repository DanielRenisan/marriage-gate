import 'package:flutter/material.dart';
import 'package:matrimony_flutter/services/auth_service.dart';
import 'package:matrimony_flutter/screens/auth/login_screen.dart';
import 'package:matrimony_flutter/screens/main/main_screen.dart';

class RouteGuards {
  static final AuthService _authService = AuthService();

  // Can Active Service - Check if user is logged in
  static Future<bool> canActivate(BuildContext context) async {
    final isLoggedIn = await _authService.isLoggedIn();
    
    if (!isLoggedIn) {
      // Redirect to login if not authenticated
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
      return false;
    }
    
    return true;
  }

  // De Active Service - Check if user is NOT logged in
  static Future<bool> deActivate(BuildContext context) async {
    final isLoggedIn = await _authService.isLoggedIn();
    
          if (isLoggedIn) {
        // Redirect to main screen if already authenticated
        if (context.mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        }
        return false;
      }
    
    return true;
  }

  // Auth Guard Service - Check if user has specific role
  static Future<bool> authGuard(BuildContext context, {List<String>? allowedRoles}) async {
    final isLoggedIn = await _authService.isLoggedIn();
    
    if (!isLoggedIn) {
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
      return false;
    }

    // Check role if specified
    if (allowedRoles != null && allowedRoles.isNotEmpty) {
      final userType = await _authService.getUserType();
      if (userType == null || !allowedRoles.contains(userType)) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Access denied. Insufficient permissions.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return false;
      }
    }
    
    return true;
  }

  // Check if user is admin
  static Future<bool> isAdmin() async {
    final userType = await _authService.getUserType();
    return userType == 'Admin';
  }

  // Check if user is agent
  static Future<bool> isAgent() async {
    final userType = await _authService.getUserType();
    return userType == 'Agent';
  }

  // Check if user is member
  static Future<bool> isMember() async {
    final userType = await _authService.getUserType();
    return userType == 'Member';
  }
}
