import 'package:flutter/material.dart';
import 'package:matrimony_flutter/models/member.dart';
import 'package:matrimony_flutter/models/profile_response.dart';
import 'package:matrimony_flutter/models/profile_request.dart';
import 'package:matrimony_flutter/models/matching_profiles_request.dart';
import 'package:matrimony_flutter/models/notification_item.dart';
import 'package:matrimony_flutter/services/member_service.dart';
import 'package:matrimony_flutter/utils/enum.dart';
import 'dart:io';

import '../models/matching_profile_response.dart';

class MemberProvider extends ChangeNotifier {
  final MemberService _memberService = MemberService();

  List<MemberProfile> _memberProfiles = [];
  List<MemberProfile> get memberProfiles => _memberProfiles;

  MatchingProfileResponse? _matchingProfilesResponse;
  MatchingProfileResponse? get matchingProfilesResponse => _matchingProfilesResponse;

  List<MatchingProfile> get matchingProfiles => _matchingProfilesResponse?.result.data ?? [];

  int get matchingProfilesTotalCount => _matchingProfilesResponse?.result.totalCount ?? 0;
  int get currentMatchingPage => _matchingProfilesResponse?.result.pageNumber ?? 1;

  MemberProfile? _currentUserProfile;
  MemberProfile? get currentUserProfile => _currentUserProfile;

  List<ChatParticipant> _chatParticipants = [];
  List<ChatParticipant> get chatParticipants => _chatParticipants;

  List<ChatMessage> _chatMessages = [];
  List<ChatMessage> get chatMessages => _chatMessages;

  List<FriendRequest> _friendRequests = [];
  List<FriendRequest> get friendRequests => _friendRequests;

  List<MemberProfile> _friends = [];
  List<MemberProfile> get friends => _friends;

  List<NotificationItem> _notifications = [];
  List<NotificationItem> get allNotifications => _notifications;
  List<NotificationItem> get unreadNotifications => _notifications.where((n) => !n.isRead).toList();
  int _totalUnreadCount = 0;
  int get totalUnreadCount => _totalUnreadCount;

  bool _isLoadingProfiles = false;
  bool get isLoadingProfiles => _isLoadingProfiles;

  bool _isLoadingMatchingProfiles = false;
  bool get isLoadingMatchingProfiles => _isLoadingMatchingProfiles;

  bool _isLoadingChat = false;
  bool get isLoadingChat => _isLoadingChat;

  bool _isLoadingFriends = false;
  bool get isLoadingFriends => _isLoadingFriends;

  bool _isLoadingCurrentUserProfile = false;
  bool get isLoadingCurrentUserProfile => _isLoadingCurrentUserProfile;

  bool _isLoadingNotifications = false;
  bool get isLoadingNotifications => _isLoadingNotifications;

  ChatParticipant? _selectedChatParticipant;
  ChatParticipant? get selectedChatParticipant => _selectedChatParticipant;

  String _searchTerm = '';
  String get searchTerm => _searchTerm;

  void setSearchTerm(String term) {
    _searchTerm = term;
    notifyListeners();
  }

  List<MatchingProfile> get filteredMatchingProfiles {
    if (_searchTerm.isEmpty) {
      return matchingProfiles;
    }
    return matchingProfiles.where((profile) {
      final fullName = '${profile.firstName} ${profile.lastName}'.toLowerCase();
      final city = profile.city?.toLowerCase() ?? '';
      final jobTitle = profile.jobTitle.toLowerCase();
      final searchLower = _searchTerm.toLowerCase();

      return fullName.contains(searchLower) || city.contains(searchLower) || jobTitle.contains(searchLower);
    }).toList();
  }

  List<ChatParticipant> get filteredChatParticipants {
    if (_searchTerm.isEmpty) {
      return _chatParticipants;
    }
    return _chatParticipants.where((participant) {
      final name = '${participant.firstName} ${participant.lastName}'.toLowerCase();
      final searchLower = _searchTerm.toLowerCase();
      return name.contains(searchLower);
    }).toList();
  }
  //

  Future<void> loadMemberProfiles() async {
    try {
      _isLoadingProfiles = true;
      notifyListeners();

      _memberProfiles = await _memberService.getMemberProfiles();

      _isLoadingProfiles = false;
      notifyListeners();
    } catch (e) {
      _isLoadingProfiles = false;
      notifyListeners();
      throw Exception('Failed to load member profiles: $e');
    }
  }

  void setMemberProfiles(List<MemberProfile> profiles) {
    _memberProfiles = profiles;
    notifyListeners();
  }

  void setCurrentUserProfile(MemberProfile profile) {
    _currentUserProfile = profile;
    loadMatchingProfiles(null, profile.id, 1, 20);
    notifyListeners();
  }

  Future<void> loadMatchingProfiles(MatchingProfilesRequest? filters, String userId, int pageNumber, int pageSize) async {
    try {
      _isLoadingMatchingProfiles = true;
      notifyListeners();

      _matchingProfilesResponse = await _memberService.getAllMatchedProfiles(filters, userId, pageNumber, pageSize);

      _isLoadingMatchingProfiles = false;
      notifyListeners();
    } catch (e) {
      _isLoadingMatchingProfiles = false;
      notifyListeners();
      throw Exception('Failed to load matching profiles: $e');
    }
  }

  Future<void> loadChatParticipants() async {
    try {
      _isLoadingChat = true;
      notifyListeners();

      _chatParticipants = await _memberService.getChatParticipants();

      _isLoadingChat = false;
      notifyListeners();
    } catch (e) {
      _isLoadingChat = false;
      notifyListeners();
      throw Exception('Failed to load chat participants: $e');
    }
  }

  Future<void> loadChatMessages(String participantId) async {
    try {
      _isLoadingChat = true;
      notifyListeners();

      _chatMessages = await _memberService.getChatMessages(participantId, 1, 50);

      _isLoadingChat = false;
      notifyListeners();
    } catch (e) {
      _isLoadingChat = false;
      notifyListeners();
      throw Exception('Failed to load chat messages: $e');
    }
  }

  Future<void> sendMessage(String participantId, String message) async {
    try {
      await _memberService.sendMessage(participantId, message, [], 'text');
      await loadChatMessages(participantId);
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  Future<void> loadFriendRequests() async {
    try {
      _isLoadingFriends = true;
      notifyListeners();

      _friendRequests = await _memberService.getFriendRequests(1, 10);

      _isLoadingFriends = false;
      notifyListeners();
    } catch (e) {
      _isLoadingFriends = false;
      notifyListeners();
      throw Exception('Failed to load friend requests: $e');
    }
  }

  Future<void> acceptFriendRequest(String requestId) async {
    try {
      await _memberService.acceptFriendRequest(requestId);
      await loadFriendRequests();
    } catch (e) {
      throw Exception('Failed to accept friend request: $e');
    }
  }

  Future<void> rejectFriendRequest(String requestId) async {
    try {
      await _memberService.rejectFriendRequest(requestId);
      await loadFriendRequests();
    } catch (e) {
      throw Exception('Failed to reject friend request: $e');
    }
  }

  Future<void> sendFriendRequest(String profileId) async {
    try {
      await _memberService.sendFriendRequest(profileId);
    } catch (e) {
      throw Exception('Failed to send friend request: $e');
    }
  }

  Future<void> loadFriends() async {
    try {
      _isLoadingFriends = true;
      notifyListeners();

      _friends = await _memberService.getFriends();

      _isLoadingFriends = false;
      notifyListeners();
    } catch (e) {
      _isLoadingFriends = false;
      notifyListeners();
      throw Exception('Failed to load friends: $e');
    }
  }

  void setSelectedChatParticipant(ChatParticipant participant) {
    _selectedChatParticipant = participant;
    notifyListeners();
  }

  void clearSelectedChatParticipant() {
    _selectedChatParticipant = null;
    notifyListeners();
  }

  MemberProfile? getProfileById(String id) {
    try {
      return _memberProfiles.firstWhere((profile) => profile.id == id);
    } catch (e) {
      return null;
    }
  }

  MatchingProfile? getMatchingProfileById(String id) {
    try {
      return matchingProfiles.firstWhere((profile) => profile.id == id);
    } catch (e) {
      return null;
    }
  }

  bool get hasProfiles => _memberProfiles.isNotEmpty;

  bool get hasMatchingProfiles => matchingProfiles.isNotEmpty;

  bool get hasChatParticipants => _chatParticipants.isNotEmpty;

  bool get hasFriendRequests => _friendRequests.isNotEmpty;

  bool get hasFriends => _friends.isNotEmpty;

  int get unreadMessageCount {
    return _chatParticipants.fold(0, (count, participant) => count + participant.unreadCount);
  }

  int get pendingFriendRequestCount {
    return _friendRequests.where((request) => request.status == FriendRequestStatus.pending.value.toString()).length;
  }

  void clearAllData() {
    _memberProfiles.clear();
    _matchingProfilesResponse = null;
    _currentUserProfile = null;
    _chatParticipants.clear();
    _chatMessages.clear();
    _friendRequests.clear();
    _friends.clear();
    _notifications.clear();
    _totalUnreadCount = 0;
    _selectedChatParticipant = null;
    _searchTerm = '';
    notifyListeners();
  }

  Future<void> updateProfile(String profileId, Map<String, dynamic> data) async {
    try {
      await _memberService.updateProfile(profileId, data);
      await loadMemberProfiles();
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  Future<void> deleteProfile(String profileId) async {
    try {
      await _memberService.deleteProfile(profileId);
      await loadMemberProfiles();
    } catch (e) {
      throw Exception('Failed to delete profile: $e');
    }
  }

  Future<ProfileResponse> createMemberProfile(ProfileRequest profileRequest) async {
    try {
      final response = await _memberService.createMemberProfile(profileRequest);
      return response;
    } catch (e) {
      throw Exception('Failed to create profile: $e');
    }
  }

  Future<void> loadCurrentUserProfile(String userId) async {
    try {
      _isLoadingCurrentUserProfile = true;
      notifyListeners();

      final profile = await _memberService.getMemberProfileById(userId);
      _currentUserProfile = profile;

      _isLoadingCurrentUserProfile = false;
      notifyListeners();
    } catch (e) {
      _isLoadingCurrentUserProfile = false;
      notifyListeners();
      throw Exception('Failed to load current user profile: $e');
    }
  }

  Future<void> deleteMemberProfile(String profileId) async {
    try {
      await _memberService.deleteProfile(profileId);
      await loadMemberProfiles();
    } catch (e) {
      throw Exception('Failed to delete member profile: $e');
    }
  }

  Future<String> uploadProfileImage(File file) async {
    try {
      return await _memberService.uploadFileFromPath(file);
    } catch (e) {
      throw Exception('Failed to upload profile image: $e');
    }
  }

  Future<void> loadNotifications(int pageNumber, int pageSize, bool? isRead) async {
    try {
      _isLoadingNotifications = true;
      notifyListeners();

      final response = await _memberService.getNotifications(pageNumber, pageSize, isRead);
      _notifications = response.data;
      _totalUnreadCount = response.totalUnreadCount;

      _isLoadingNotifications = false;
      notifyListeners();
    } catch (e) {
      _isLoadingNotifications = false;
      notifyListeners();
      throw Exception('Failed to load notifications: $e');
    }
  }

  Future<List<NotificationItem>> loadMoreNotifications(int pageNumber, int pageSize, bool? isRead) async {
    try {
      final response = await _memberService.getNotifications(pageNumber, pageSize, isRead);
      _notifications.addAll(response.data);
      notifyListeners();
      return response.data;
    } catch (e) {
      throw Exception('Failed to load more notifications: $e');
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _memberService.markNotificationAsRead(notificationId);

      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        final notification = _notifications[index];
        _notifications[index] = NotificationItem(
          id: notification.id,
          title: notification.title,
          body: notification.body,
          payload: notification.payload,
          parsedPayload: notification.parsedPayload,
          notificationType: notification.notificationType,
          receivedProfileId: notification.receivedProfileId,
          receivedUserId: notification.receivedUserId,
          isRead: true,
          readAt: notification.readAt,
          createdDate: notification.createdDate,
        );
        _totalUnreadCount = (_totalUnreadCount - 1).clamp(0, double.infinity).toInt();
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  Future<void> markAllNotificationsAsRead() async {
    try {
      await _memberService.markAllNotificationsAsRead();

      _notifications = _notifications.map((notification) {
        return NotificationItem(
          id: notification.id,
          title: notification.title,
          body: notification.body,
          payload: notification.payload,
          parsedPayload: notification.parsedPayload,
          notificationType: notification.notificationType,
          receivedProfileId: notification.receivedProfileId,
          receivedUserId: notification.receivedUserId,
          isRead: true,
          readAt: notification.readAt,
          createdDate: notification.createdDate,
        );
      }).toList();
      _totalUnreadCount = 0;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to mark all notifications as read: $e');
    }
  }

  void addNotification(NotificationItem notification) {
    _notifications.insert(0, notification);
    if (!notification.isRead) {
      _totalUnreadCount++;
    }
    notifyListeners();
  }
}
