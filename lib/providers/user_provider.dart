import 'package:flutter/material.dart';
import 'package:matrimony_flutter/models/user.dart';
import 'package:matrimony_flutter/models/member.dart';
import 'package:matrimony_flutter/services/member_service.dart';

class UserProvider extends ChangeNotifier {
  final MemberService _memberService = MemberService();

  User? _currentUser;
  User? get currentUser => _currentUser;

  List<MemberProfile> _userMemberProfiles = [];
  List<MemberProfile> get userMemberProfiles => _userMemberProfiles;

  MemberProfile? _selectedMemberProfile;
  MemberProfile? get selectedMemberProfile => _selectedMemberProfile;

  final bool _isLoadingUser = false;
  bool get isLoadingUser => _isLoadingUser;

  bool _isLoadingMemberProfiles = false;
  bool get isLoadingMemberProfiles => _isLoadingMemberProfiles;

  bool get hasMemberProfiles => _userMemberProfiles.isNotEmpty;
//
  void setCurrentUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  Future<void> loadUserMemberProfiles() async {
    try {
      _isLoadingMemberProfiles = true;
      notifyListeners();

      _userMemberProfiles = await _memberService.getMemberProfiles();

      _isLoadingMemberProfiles = false;
      notifyListeners();
    } catch (e) {
      _isLoadingMemberProfiles = false;
      notifyListeners();
      throw Exception('Failed to load member profiles: $e');
    }
  }

  void setSelectedMemberProfile(MemberProfile profile) {
    _selectedMemberProfile = profile;
    notifyListeners();
  }

  MemberProfile? getMemberProfileById(String id) {
    try {
      return _userMemberProfiles.firstWhere((profile) => profile.id == id);
    } catch (e) {
      return null;
    }
  }

  void addMemberProfile(MemberProfile profile) {
    _userMemberProfiles.add(profile);
    notifyListeners();
  }

  void updateMemberProfile(MemberProfile updatedProfile) {
    final index = _userMemberProfiles.indexWhere((p) => p.id == updatedProfile.id);
    if (index != -1) {
      _userMemberProfiles[index] = updatedProfile;
      notifyListeners();
    }
  }

  void removeMemberProfile(String profileId) {
    _userMemberProfiles.removeWhere((profile) => profile.id == profileId);
    notifyListeners();
  }

  void clearAllData() {
    _currentUser = null;
    _userMemberProfiles.clear();
    _selectedMemberProfile = null;
    notifyListeners();
  }
}
