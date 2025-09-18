import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:matrimony_flutter/providers/member_provider.dart';
import 'package:matrimony_flutter/models/member.dart';
import 'package:matrimony_flutter/widgets/custom_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MemberProvider>().loadChatParticipants();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        elevation: 0,
      ),
      body: Consumer<MemberProvider>(
        builder: (context, memberProvider, child) {
          if (memberProvider.isLoadingChat) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (memberProvider.chatParticipants.isEmpty) {
            return _buildEmptyState();
          }

          return Column(
            children: [
              _buildSearchBar(memberProvider),
              Expanded(
                child: _buildChatList(memberProvider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(MemberProvider memberProvider) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: CustomTextField(
        controller: _searchController,
        labelText: 'Search',
        hintText: 'Search conversations...',
        suffixIcon: const Icon(Icons.search),
        onChanged: (value) {
          memberProvider.setSearchTerm(value);
        },
      ),
    );
  }

  Widget _buildChatList(MemberProvider memberProvider) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: memberProvider.filteredChatParticipants.length,
      itemBuilder: (context, index) {
        final participant = memberProvider.filteredChatParticipants[index];
        return _buildChatItem(participant, memberProvider);
      },
    );
  }

  Widget _buildChatItem(ChatParticipant participant, MemberProvider memberProvider) {
    return Card(
      margin: EdgeInsets.only(bottom: 8.h),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(12.w),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 25.r,
              backgroundImage: NetworkImage(
                participant.profileImage ?? 
                'https://via.placeholder.com/50x50?text=No+Image',
              ),
            ),
            if (participant.isOnline == true)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 12.w,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          participant.name ?? 'Unknown',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Text(
              participant.lastMessage ?? 'No messages yet',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              participant.lastSentAt ?? '',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
        trailing: participant.isRead == false && participant.isSentByMe == false
            ? Container(
                width: 20.w,
                height: 20.h,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '1',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            : null,
        onTap: () {
          _openChat(participant, memberProvider);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80.sp,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            'No conversations yet',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Start connecting with people to begin chatting',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _openChat(ChatParticipant participant, MemberProvider memberProvider) {
    memberProvider.setSelectedChatParticipant(participant);
    memberProvider.loadChatMessages(participant.receiverProfileId!);
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatDetailScreen(participant: participant),
      ),
    );
  }
}

class ChatDetailScreen extends StatefulWidget {
  final ChatParticipant participant;

  const ChatDetailScreen({
    super.key,
    required this.participant,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                widget.participant.profileImage ?? 
                'https://via.placeholder.com/40x40?text=No+Image',
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.participant.name ?? 'Unknown',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.participant.isOnline == true 
                        ? 'Online' 
                        : widget.participant.lastOnlineAt ?? 'Offline',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: Consumer<MemberProvider>(
        builder: (context, memberProvider, child) {
          return Column(
            children: [
              Expanded(
                child: _buildMessagesList(memberProvider),
              ),
              _buildMessageInput(memberProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMessagesList(MemberProvider memberProvider) {
    if (memberProvider.chatMessages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 60.sp,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16.h),
            Text(
              'No messages yet',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Start the conversation!',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      controller: _scrollController,
      itemCount: memberProvider.chatMessages.length,
      itemBuilder: (context, index) {
        final message = memberProvider.chatMessages[index];
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isMine = message.isMine == true;
    
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMine) ...[
            CircleAvatar(
              radius: 16.r,
              backgroundImage: NetworkImage(
                widget.participant.profileImage ?? 
                'https://via.placeholder.com/32x32?text=No+Image',
              ),
            ),
            SizedBox(width: 8.w),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: isMine ? Colors.red : Colors.grey[200],
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.textContent != null && message.textContent!.isNotEmpty)
                    Text(
                      message.textContent!,
                      style: TextStyle(
                        color: isMine ? Colors.white : Colors.black87,
                        fontSize: 14.sp,
                      ),
                    ),
                  if (message.fileUrls != null && message.fileUrls!.isNotEmpty)
                    ...message.fileUrls!.map((url) => Container(
                      margin: EdgeInsets.only(top: 8.h),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          url,
                          width: 200.w,
                          height: 150.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )),
                  SizedBox(height: 4.h),
                  Text(
                    message.sentAt ?? '',
                    style: TextStyle(
                      color: isMine ? Colors.white70 : Colors.grey[600],
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isMine) ...[
            SizedBox(width: 8.w),
            CircleAvatar(
              radius: 16.r,
              backgroundColor: Colors.red,
              child: Icon(
                Icons.person,
                size: 16.sp,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput(MemberProvider memberProvider) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: () {
              _sendMessage(memberProvider);
            },
            child: Container(
              width: 48.w,
              height: 48.h,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.send,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(MemberProvider memberProvider) async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    try {
      await memberProvider.sendMessage(
        widget.participant.receiverProfileId!,
        message,
      );
      
      _messageController.clear();
      _scrollToBottom();
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to send message. Please try again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
