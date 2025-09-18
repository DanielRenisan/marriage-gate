import 'package:flutter/material.dart';
import 'package:matrimony_flutter/models/member.dart';
import 'package:matrimony_flutter/providers/member_provider.dart';
import 'package:matrimony_flutter/viewmodels/base_view_model.dart';

class ChatViewModel extends BaseViewModel {
  final MemberProvider _memberProvider;
  
  List<ChatParticipant> _chatParticipants = [];
  List<ChatMessage> _messages = [];
  ChatParticipant? _selectedParticipant;
  String _searchTerm = '';
  final bool _isSearching = false;

  ChatViewModel(this._memberProvider);

  List<ChatParticipant> get chatParticipants => _chatParticipants;
  List<ChatMessage> get messages => _messages;
  ChatParticipant? get selectedParticipant => _selectedParticipant;
  String get searchTerm => _searchTerm;
  bool get isSearching => _isSearching;
  bool get hasParticipants => _chatParticipants.isNotEmpty;


  Future<void> loadChatParticipants() async {
    await handleAsyncOperation(() async {
      // TODO: Implement loading chat participants from API
      // For now, using mock data
      _chatParticipants = [
        ChatParticipant(
          id: '1',
          firstName: 'John',
          lastName: 'Doe',
          imageUrl: 'https://via.placeholder.com/50x50',
          lastMessage: 'Hello, how are you?',
          lastMessageTime: '2 hours ago',
          isOnline: true,
          unreadCount: 2,
        ),
        ChatParticipant(
          id: '2',
          firstName: 'Jane',
          lastName: 'Smith',
          imageUrl: 'https://via.placeholder.com/50x50',
          lastMessage: 'Thanks for connecting!',
          lastMessageTime: '1 day ago',
          isOnline: false,
          unreadCount: 0,
        ),
      ];
    });
  }

  void setSearchTerm(String term) {
    _searchTerm = term;
    _filterParticipants();
  }

  void _filterParticipants() {
    if (_searchTerm.isEmpty) {
      // Reset to original list
      loadChatParticipants();
    } else {
      _chatParticipants = _chatParticipants.where((participant) {
        final fullName = '${participant.firstName} ${participant.lastName}'.toLowerCase();
        final searchLower = _searchTerm.toLowerCase();
        return fullName.contains(searchLower);
      }).toList();
    }
    notifyListeners();
  }

  Future<void> loadMessages(String participantId) async {
    await handleAsyncOperation(() async {
      // TODO: Implement loading messages from API
      // For now, using mock data
      _messages = [
        ChatMessage(
          id: '1',
          senderId: participantId,
          receiverId: 'current_user',
          content: 'Hello, how are you?',
          messageType: 'text',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
          isRead: false,
        ),
        ChatMessage(
          id: '2',
          senderId: 'current_user',
          receiverId: participantId,
          content: 'I\'m doing great, thanks! How about you?',
          messageType: 'text',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)).toIso8601String(),
          isRead: true,
        ),
        ChatMessage(
          id: '3',
          senderId: participantId,
          receiverId: 'current_user',
          content: 'I\'m good too! Would you like to meet sometime?',
          messageType: 'text',
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)).toIso8601String(),
          isRead: false,
        ),
      ];
      
      // Find the selected participant
      _selectedParticipant = _chatParticipants.firstWhere(
        (p) => p.id == participantId,
        orElse: () => ChatParticipant(
          id: participantId,
          firstName: 'Unknown',
          lastName: 'User',
          lastMessage: '',
          lastMessageTime: '',
          isOnline: false,
          unreadCount: 0,
        ),
      );
    });
  }

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty || _selectedParticipant == null) return;

    await handleAsyncOperation(() async {
      // TODO: Implement sending message to API
      final newMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: 'current_user',
        receiverId: _selectedParticipant!.id,
        content: content.trim(),
        messageType: 'text',
        timestamp: DateTime.now().toIso8601String(),
        isRead: false,
      );
      
      _messages.add(newMessage);
      
      // Update the last message in participants list
      final participantIndex = _chatParticipants.indexWhere(
        (p) => p.id == _selectedParticipant!.id,
      );
      
      if (participantIndex != -1) {
        _chatParticipants[participantIndex] = ChatParticipant(
          id: _chatParticipants[participantIndex].id,
          firstName: _chatParticipants[participantIndex].firstName,
          lastName: _chatParticipants[participantIndex].lastName,
          imageUrl: _chatParticipants[participantIndex].imageUrl,
          lastMessage: content.trim(),
          lastMessageTime: 'Just now',
          isOnline: _chatParticipants[participantIndex].isOnline,
          unreadCount: 0,
        );
      }
    });
  }

  Future<void> markMessageAsRead(String messageId) async {
    await handleAsyncOperation(() async {
      // TODO: Implement marking message as read in API
      final messageIndex = _messages.indexWhere((m) => m.id == messageId);
      if (messageIndex != -1) {
        _messages[messageIndex] = ChatMessage(
          id: _messages[messageIndex].id,
          senderId: _messages[messageIndex].senderId,
          receiverId: _messages[messageIndex].receiverId,
          content: _messages[messageIndex].content,
          messageType: _messages[messageIndex].messageType,
          timestamp: _messages[messageIndex].timestamp,
          isRead: true,
          readAt: DateTime.now().toIso8601String(),
        );
      }
    });
  }

  Future<void> deleteMessage(String messageId) async {
    await handleAsyncOperation(() async {
      // TODO: Implement deleting message in API
      _messages.removeWhere((m) => m.id == messageId);
    });
  }

  Future<void> blockUser(String participantId) async {
    await handleAsyncOperation(() async {
      // TODO: Implement blocking user in API
      _chatParticipants.removeWhere((p) => p.id == participantId);
      if (_selectedParticipant?.id == participantId) {
        _selectedParticipant = null;
        _messages.clear();
      }
    });
  }

  Future<void> reportUser(String participantId, String reason) async {
    await handleAsyncOperation(() async {
      // TODO: Implement reporting user in API
      debugPrint('Reporting user $participantId for reason: $reason');
    });
  }

  String formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Unknown';
    }
  }

  bool isMessageFromMe(ChatMessage message) {
    return message.senderId == 'current_user';
  }

  void clearSelectedParticipant() {
    _selectedParticipant = null;
    _messages.clear();
    notifyListeners();
  }

  void showUserProfile(BuildContext context, ChatParticipant participant) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildUserProfileSheet(context, participant),
    );
  }

  Widget _buildUserProfileSheet(BuildContext context, ChatParticipant participant) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      participant.imageUrl ?? 'https://via.placeholder.com/100x100',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${participant.firstName} ${participant.lastName}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: participant.isOnline ? Colors.green : Colors.grey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      participant.isOnline ? 'Online' : 'Offline',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildActionButton(
                    context,
                    'View Full Profile',
                    Icons.person,
                    () {
                      Navigator.of(context).pop();
                      // TODO: Navigate to full profile
                    },
                  ),
                  _buildActionButton(
                    context,
                    'Block User',
                    Icons.block,
                    () {
                      Navigator.of(context).pop();
                      blockUser(participant.id);
                    },
                    isDestructive: true,
                  ),
                  _buildActionButton(
                    context,
                    'Report User',
                    Icons.report,
                    () {
                      Navigator.of(context).pop();
                      _showReportDialog(context, participant.id);
                    },
                    isDestructive: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String text,
    IconData icon,
    VoidCallback onPressed, {
    bool isDestructive = false,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: isDestructive ? Colors.white : Colors.red),
        label: Text(
          text,
          style: TextStyle(
            color: isDestructive ? Colors.white : Colors.red,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isDestructive ? Colors.red : Colors.white,
          side: BorderSide(color: isDestructive ? Colors.red : Colors.grey),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  void _showReportDialog(BuildContext context, String participantId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please select a reason for reporting:'),
            const SizedBox(height: 16),
            _buildReportOption(context, participantId, 'Inappropriate behavior'),
            _buildReportOption(context, participantId, 'Spam or fake profile'),
            _buildReportOption(context, participantId, 'Harassment'),
            _buildReportOption(context, participantId, 'Other'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildReportOption(BuildContext context, String participantId, String reason) {
    return ListTile(
      title: Text(reason),
      onTap: () {
        Navigator.of(context).pop();
        reportUser(participantId, reason);
      },
    );
  }
}
