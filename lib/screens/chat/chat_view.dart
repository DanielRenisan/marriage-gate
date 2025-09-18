import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:matrimony_flutter/viewmodels/chat_view_model.dart';
import 'package:matrimony_flutter/models/member.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late ChatViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<ChatViewModel>();
    _loadChatParticipants();
  }

  Future<void> _loadChatParticipants() async {
    await _viewModel.loadChatParticipants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Consumer<ChatViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${viewModel.errorMessage}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  ElevatedButton(
                    onPressed: _loadChatParticipants,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (!viewModel.hasParticipants) {
            return const Center(
              child: Text('No chat conversations yet'),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: viewModel.chatParticipants.length,
            itemBuilder: (context, index) {
              final participant = viewModel.chatParticipants[index];
              return _buildChatCard(participant, viewModel);
            },
          );
        },
      ),
    );
  }

  Widget _buildChatCard(ChatParticipant participant, ChatViewModel viewModel) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(12.w),
        leading: CircleAvatar(
          radius: 30.r,
          backgroundImage: NetworkImage(
            participant.profileImage ?? 'https://via.placeholder.com/60x60',
          ),
        ),
        title: Text(
          participant.name ?? '${participant.firstName} ${participant.lastName}',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          participant.lastMessage,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: participant.unreadCount > 0
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  participant.unreadCount.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : null,
        onTap: () => _openChat(participant.id, viewModel),
      ),
    );
  }

  void _openChat(String participantId, ChatViewModel viewModel) async {
    await viewModel.loadMessages(participantId);
    if (mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => _ChatDetailView(participantId: participantId),
        ),
      );
    }
  }
}

class _ChatDetailView extends StatefulWidget {
  final String participantId;

  const _ChatDetailView({required this.participantId});

  @override
  State<_ChatDetailView> createState() => _ChatDetailViewState();
}

class _ChatDetailViewState extends State<_ChatDetailView> {
  final TextEditingController _messageController = TextEditingController();
  late ChatViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<ChatViewModel>();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<ChatViewModel>(
          builder: (context, viewModel, child) {
            final participant = viewModel.selectedParticipant;
            return Text(participant?.name ?? 'Chat');
          },
        ),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Consumer<ChatViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  reverse: true,
                  itemCount: viewModel.messages.length,
                  itemBuilder: (context, index) {
                    final message = viewModel.messages[viewModel.messages.length - 1 - index];
                    return _buildMessageBubble(message, viewModel);
                  },
                ),
              ),
              _buildMessageInput(viewModel),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, ChatViewModel viewModel) {
    final isFromMe = viewModel.isMessageFromMe(message);
    
    return Align(
      alignment: isFromMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 8.h,
          left: isFromMe ? 50.w : 0,
          right: isFromMe ? 0 : 50.w,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isFromMe ? Colors.red : Colors.grey[200],
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Text(
          message.textContent ?? message.content,
          style: TextStyle(
            color: isFromMe ? Colors.white : Colors.black87,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput(ChatViewModel viewModel) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          IconButton(
            onPressed: () => _sendMessage(viewModel),
            icon: const Icon(Icons.send),
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  void _sendMessage(ChatViewModel viewModel) async {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      await viewModel.sendMessage(message);
      _messageController.clear();
    }
  }
}
