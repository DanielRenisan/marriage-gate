import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:matrimony_flutter/models/member.dart';
import 'package:matrimony_flutter/models/profile_response.dart';
import 'package:matrimony_flutter/models/profile_request.dart';
import 'package:matrimony_flutter/models/matching_profile_response.dart';
import 'package:matrimony_flutter/models/notification_item.dart';
import 'package:matrimony_flutter/utils/enum.dart';
import 'package:matrimony_flutter/services/auth_service.dart';

import '../models/matching_profiles_request.dart';

class MemberService {
  final String _baseUrl = ApiEndpoints.baseUrl;
  final AuthService _authService = AuthService();

  // Get all member profiles
  Future<List<MemberProfile>> getMemberProfiles() async {
    try {
      final token = await _authService.getAuthToken();
      final url = Uri.parse('$_baseUrl${ApiEndpoints.getUserProfiles}');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Result'] != null) {
          return (data['Result'] as List).map((item) => MemberProfile.fromJson(item)).toList();
        }
        return [];
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['Message'] ?? 'Failed to get user profiles';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Error getting user profiles: $e');
    }
  }

  // Get member profile by ID
  Future<MemberProfile> getMemberProfileById(String id) async {
    try {
      final token = await _authService.getAuthToken();
      final url = Uri.parse('$_baseUrl${ApiEndpoints.getMemberById}$id');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Result'] != null) {
          return MemberProfile.fromJson(data['Result']);
        }
        throw Exception('Profile not found');
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['Message'] ?? 'Failed to get profile';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Error getting profile: $e');
    }
  }

  // Create member profile
  Future<ProfileResponse> createMemberProfile(ProfileRequest profileRequest) async {
    try {
      final token = await _authService.getAuthToken();
      final url = Uri.parse('$_baseUrl${ApiEndpoints.createProfile}');
      final requestBody = profileRequest.toJson();
      String jsonBody;
      try {
        jsonBody = json.encode(requestBody);
      } catch (e) {
        throw Exception('Failed to encode request body as JSON: $e');
      }

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return ProfileResponse.fromJson(responseData);
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['Result']?['errors']?['\$']?.first ??
            errorData['Result']?['errors']?['profileRequestDTO']?.first ??
            errorData['Error']?['Detail'] ??
            errorData['Message'] ??
            'Failed to create profile';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Error creating profile: $e');
    }
  }

  // Update member profile
  Future<Map<String, dynamic>> updateProfile(String id, Map<String, dynamic> body) async {
    try {
      final token = await _authService.getAuthToken();
      final url = Uri.parse('$_baseUrl${ApiEndpoints.updateMember}');

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['Message'] ?? 'Failed to update profile';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Error updating profile: $e');
    }
  }

  // Delete member profile
  Future<bool> deleteProfile(String id) async {
    try {
      final token = await _authService.getAuthToken();
      final url = Uri.parse('$_baseUrl${ApiEndpoints.deleteMember}');

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error deleting profile: $e');
    }
  }

  // Get all matched profiles
  Future<MatchingProfileResponse> getAllMatchedProfiles(
      MatchingProfilesRequest? filters, String userId, int pageNumber, int pageSize) async {
    try {
      final token = await _authService.getAuthToken();
      final url = Uri.parse('$_baseUrl${ApiEndpoints.getProfileMatchingData}/$userId?pageNumber=$pageNumber&pageSize=$pageSize');

      // Use default filters if none provided
      final requestFilters = filters ?? MatchingProfilesRequest.defaultRequest();

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(requestFilters.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return MatchingProfileResponse.fromJson(data);
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['Error']?['Detail'] ?? errorData['Message'] ?? 'Failed to get matched profiles';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Error getting matched profiles: $e');
    }
  }

  // Send friend request
  Future<bool> sendFriendRequest(String receiverId) async {
    try {
      final token = await _authService.getAuthToken();
      final url = Uri.parse('$_baseUrl${ApiEndpoints.sendFriendRequest}');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'receiverId': receiverId}),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error sending friend request: $e');
    }
  }

  // Get friend requests
  Future<List<FriendRequest>> getFriendRequests(int pageNumber, int pageSize) async {
    try {
      final token = await _authService.getAuthToken();
      final url = Uri.parse('$_baseUrl${ApiEndpoints.getFriendRequests}?pageNumber=$pageNumber&pageSize=$pageSize');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Result'] != null && data['Result']['data'] != null) {
          return (data['Result']['data'] as List).map((item) => FriendRequest.fromJson(item)).toList();
        }
        return [];
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['Message'] ?? 'Failed to get friend requests';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Error getting friend requests: $e');
    }
  }

  // Accept friend request
  Future<bool> acceptFriendRequest(String requestId) async {
    try {
      final token = await _authService.getAuthToken();
      final url = Uri.parse('$_baseUrl${ApiEndpoints.acceptFriendRequest}');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'requestId': requestId}),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error accepting friend request: $e');
    }
  }

  // Reject friend request
  Future<bool> rejectFriendRequest(String requestId) async {
    try {
      final token = await _authService.getAuthToken();
      final url = Uri.parse('$_baseUrl${ApiEndpoints.rejectFriendRequest}');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'requestId': requestId}),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error rejecting friend request: $e');
    }
  }

  // Get friends list
  Future<List<MemberProfile>> getFriends() async {
    try {
      final token = await _authService.getAuthToken();
      final url = Uri.parse('$_baseUrl${ApiEndpoints.getFriends}');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Result'] != null) {
          return (data['Result'] as List).map((item) => MemberProfile.fromJson(item)).toList();
        }
        return [];
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['Message'] ?? 'Failed to get friends';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Error getting friends: $e');
    }
  }

  // Get chat participants
  Future<List<ChatParticipant>> getChatParticipants() async {
    try {
      final token = await _authService.getAuthToken();
      final url = Uri.parse('$_baseUrl${ApiEndpoints.getChatParticipants}');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Result'] != null) {
          return (data['Result'] as List).map((item) => ChatParticipant.fromJson(item)).toList();
        }
        return [];
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['Message'] ?? 'Failed to get chat participants';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Error getting chat participants: $e');
    }
  }

  // Get chat messages
  Future<List<ChatMessage>> getChatMessages(String withProfileId, int pageNumber, int pageSize) async {
    try {
      final token = await _authService.getAuthToken();
      final url = Uri.parse(
          '$_baseUrl${ApiEndpoints.getChatMessages}?withProfileId=$withProfileId&pageNumber=$pageNumber&pageSize=$pageSize');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Result'] != null && data['Result']['data'] != null) {
          return (data['Result']['data'] as List).map((item) => ChatMessage.fromJson(item)).toList();
        }
        return [];
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['Message'] ?? 'Failed to get chat messages';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Error getting chat messages: $e');
    }
  }

  // Send message
  Future<bool> sendMessage(String receiverId, String content, List<String> fileUrls, String fileType) async {
    try {
      final token = await _authService.getAuthToken();
      final url = Uri.parse('$_baseUrl${ApiEndpoints.sendMessage}');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'receiverId': receiverId,
          'content': content,
          'fileUrls': fileUrls,
          'fileType': fileType,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error sending message: $e');
    }
  }

  // Mark message as read
  Future<bool> markMessageAsRead(String messageId) async {
    try {
      final token = await _authService.getAuthToken();
      final url = Uri.parse('$_baseUrl${ApiEndpoints.markMessageAsRead}');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'messageId': messageId}),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error marking message as read: $e');
    }
  }

  // Upload file from File object
  Future<String> uploadFileFromPath(File file) async {
    try {
      final token = await _authService.getAuthToken();
      final url = Uri.parse('$_baseUrl${ApiEndpoints.uploadFile}');

      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      request.files.add(
        await http.MultipartFile.fromPath('file', file.path),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final result = data['Result'];
        final isError = data['IsError'] ?? false;
        final error = data['Error'];

        if (isError || error != null) {
          throw Exception('Upload failed: $error');
        }

        if (result != null && result is String) {
          return result;
        } else {
          throw Exception('Invalid response format from upload API');
        }
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['Message'] ?? 'Failed to upload file';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Error uploading file: $e');
    }
  }

  // Notification methods
  Future<NotificationResponse> getNotifications(int pageNumber, int pageSize, bool? isRead) async {
    try {
      final token = await _authService.getAuthToken();
      final url = Uri.parse('$_baseUrl${ApiEndpoints.getNotifications}');

      final queryParams = {
        'pageNumber': pageNumber.toString(),
        'pageSize': pageSize.toString(),
        if (isRead != null) 'isRead': isRead.toString(),
      };

      final uri = url.replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Result'] != null) {
          final result = data['Result'];
          final notifications = (result['data'] as List).map((item) => NotificationItem.fromJson(item)).toList();

          return NotificationResponse(
            data: notifications,
            totalCount: result['totalCount'] ?? 0,
            totalUnreadCount: result['totalUnreadCount'] ?? 0,
          );
        }
        return NotificationResponse(data: [], totalCount: 0, totalUnreadCount: 0);
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['Message'] ?? 'Failed to get notifications';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Error getting notifications: $e');
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      final token = await _authService.getAuthToken();
      final url = Uri.parse('$_baseUrl${ApiEndpoints.markNotificationAsRead}');

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'notificationId': notificationId,
        }),
      );

      if (response.statusCode != 200) {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['Message'] ?? 'Failed to mark notification as read';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Error marking notification as read: $e');
    }
  }

  Future<void> markAllNotificationsAsRead() async {
    try {
      final token = await _authService.getAuthToken();
      final url = Uri.parse('$_baseUrl${ApiEndpoints.markAllNotificationsAsRead}');

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['Message'] ?? 'Failed to mark all notifications as read';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Error marking all notifications as read: $e');
    }
  }
}

class NotificationResponse {
  final List<NotificationItem> data;
  final int totalCount;
  final int totalUnreadCount;

  NotificationResponse({
    required this.data,
    required this.totalCount,
    required this.totalUnreadCount,
  });
}
