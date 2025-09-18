import 'package:matrimony_flutter/services/auth_service.dart';

class TokenService {
  final AuthService _authService = AuthService();

  TokenService();

  // Get current token
  Future<String?> getCurrentToken() async {
    return await _authService.getAuthToken();
  }

  // Check if token is valid
  Future<bool> isTokenValid() async {
    final token = await getCurrentToken();
    if (token == null) return false;
    
    try {
      final decodedData = _authService.getTokenDecodeData(token);
      // Check if token has required fields
      return decodedData.containsKey('UserType') && 
             decodedData.containsKey('LoginUserType');
    } catch (e) {
      return false;
    }
  }

  // Get user type from token
  Future<String?> getUserType() async {
    final token = await getCurrentToken();
    if (token == null) return null;
    
    try {
      final decodedData = _authService.getTokenDecodeData(token);
      return decodedData['UserType'];
    } catch (e) {
      return null;
    }
  }

  // Get login user type from token
  Future<String?> getLoginUserType() async {
    final token = await getCurrentToken();
    if (token == null) return null;
    
    try {
      final decodedData = _authService.getTokenDecodeData(token);
      return decodedData['LoginUserType'];
    } catch (e) {
      return null;
    }
  }

  // Clear token
  Future<void> clearToken() async {
    await _authService.removeAuthToken();
  }
}
