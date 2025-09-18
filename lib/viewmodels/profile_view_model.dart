import 'package:flutter/material.dart';
import 'package:matrimony_flutter/models/member.dart';
import 'package:matrimony_flutter/services/auth_service.dart';
import 'package:matrimony_flutter/providers/member_provider.dart';
import 'package:matrimony_flutter/viewmodels/base_view_model.dart';

class ProfileViewModel extends BaseViewModel {
  final AuthService _authService = AuthService();
  final MemberProvider _memberProvider;
  
  UserProfile? _userProfile;
  bool _isProfileLoaded = false;

  ProfileViewModel(this._memberProvider);

  UserProfile? get userProfile => _userProfile;
  bool get isProfileLoaded => _isProfileLoaded;


  Future<void> loadUserProfile() async {
    await handleAsyncOperation(() async {
      final token = await _authService.getAuthToken();
      if (token != null) {
        final userData = _authService.getTokenDecodeData(token);
        final userId = userData['UserId'];
        if (userId != null) {
          await _memberProvider.loadCurrentUserProfile(userId.toString());
          _userProfile = _memberProvider.currentUserProfile;
          _isProfileLoaded = true;
        } else {
          throw Exception('User ID not found in token');
        }
      } else {
        throw Exception('Authentication token not found');
      }
    });
  }

  String calculateAge(String? dateOfBirth) {
    if (dateOfBirth == null) return 'N/A';
    
    try {
      final birthDate = DateTime.parse(dateOfBirth);
      final now = DateTime.now();
      int age = now.year - birthDate.year;
      if (now.month < birthDate.month || 
          (now.month == birthDate.month && now.day < birthDate.day)) {
        age--;
      }
      return '$age years';
    } catch (e) {
      return 'N/A';
    }
  }

  String getBloodGroupText(int? bloodGroup) {
    switch (bloodGroup) {
      case 1: return 'A+';
      case 2: return 'A-';
      case 3: return 'B+';
      case 4: return 'B-';
      case 5: return 'AB+';
      case 6: return 'AB-';
      case 7: return 'O+';
      case 8: return 'O-';
      default: return 'Not specified';
    }
  }

  String getBodyTypeText(int? bodyType) {
    switch (bodyType) {
      case 1: return 'Average';
      case 2: return 'Slim';
      case 3: return 'Athletic';
      case 4: return 'Heavy';
      default: return 'Not specified';
    }
  }

  Future<void> deleteProfile() async {
    if (_userProfile?.id == null) {
      setError('Profile not found');
      return;
    }

    await handleAsyncOperation(() async {
      await _memberProvider.deleteMemberProfile(_userProfile!.id);
    });
  }

  void showDeleteConfirmation(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Profile'),
        content: const Text(
          'Are you sure you want to delete your profile? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void navigateToEditProfile() {
    // TODO: Implement navigation to edit profile screen
    debugPrint('Navigate to edit profile');
  }

  void navigateToMatches() {
    // TODO: Implement navigation to matches screen
    debugPrint('Navigate to matches');
  }

  void navigateToPrivacySettings() {
    // TODO: Implement navigation to privacy settings
    debugPrint('Navigate to privacy settings');
  }
}
