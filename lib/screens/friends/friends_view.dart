import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:matrimony_flutter/providers/member_provider.dart';
import 'package:matrimony_flutter/models/member.dart';

class FriendsView extends StatefulWidget {
  const FriendsView({super.key});

  @override
  State<FriendsView> createState() => _FriendsViewState();
}

class _FriendsViewState extends State<FriendsView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late MemberProvider _memberProvider;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _memberProvider = context.read<MemberProvider>();
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _memberProvider.loadFriendRequests(),
      _memberProvider.loadFriends(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Friend Requests'),
            Tab(text: 'My Friends'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFriendRequestsTab(),
          _buildFriendsTab(),
        ],
      ),
    );
  }

  Widget _buildFriendRequestsTab() {
    return Consumer<MemberProvider>(
      builder: (context, memberProvider, child) {
        if (memberProvider.isLoadingFriends) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!memberProvider.hasFriendRequests) {
          return const Center(
            child: Text('No friend requests'),
          );
        }

        return RefreshIndicator(
          onRefresh: _loadData,
          child: ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: memberProvider.friendRequests.length,
            itemBuilder: (context, index) {
              final request = memberProvider.friendRequests[index];
              return _buildFriendRequestCard(request, memberProvider);
            },
          ),
        );
      },
    );
  }

  Widget _buildFriendsTab() {
    return Consumer<MemberProvider>(
      builder: (context, memberProvider, child) {
        if (memberProvider.isLoadingFriends) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!memberProvider.hasFriends) {
          return const Center(
            child: Text('No friends yet'),
          );
        }

        return RefreshIndicator(
          onRefresh: _loadData,
          child: ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: memberProvider.friends.length,
            itemBuilder: (context, index) {
              final friend = memberProvider.friends[index];
              return _buildFriendCard(friend);
            },
          ),
        );
      },
    );
  }

  Widget _buildFriendRequestCard(FriendRequest request, MemberProvider memberProvider) {
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
            request.senderImage ?? 'https://via.placeholder.com/60x60',
          ),
        ),
        title: Text(
          request.senderName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
        subtitle: Text(
          'Sent on ${_formatDate(request.requestDate)}',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12.sp,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: () => _acceptFriendRequest(request.id, memberProvider),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () => _rejectFriendRequest(request.id, memberProvider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendCard(MemberProfile friend) {
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
            friend.profileImages.isNotEmpty ? friend.profileImages.first.url : 'https://via.placeholder.com/60x60',
          ),
        ),
        title: Text(
          '${friend.firstName} ${friend.lastName}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
        subtitle: Text(
          '${_calculateAge(friend.dateOfBirth)} • ${friend.profileAddresses.isNotEmpty ? friend.profileAddresses.first.city : 'Location not specified'}',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12.sp,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.message, color: Colors.red),
          onPressed: () {
            // TODO: Navigate to chat with this friend
          },
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Unknown date';
    }
  }

  String _calculateAge(String? dateOfBirth) {
    if (dateOfBirth == null) return 'N/A';

    try {
      final birthDate = DateTime.parse(dateOfBirth);
      final now = DateTime.now();
      int age = now.year - birthDate.year;
      if (now.month < birthDate.month || (now.month == birthDate.month && now.day < birthDate.day)) {
        age--;
      }
      return '$age years';
    } catch (e) {
      return 'N/A';
    }
  }

  void _acceptFriendRequest(String requestId, MemberProvider memberProvider) async {
    try {
      await memberProvider.acceptFriendRequest(requestId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Friend request accepted!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to accept request: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _rejectFriendRequest(String requestId, MemberProvider memberProvider) async {
    try {
      await memberProvider.rejectFriendRequest(requestId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Friend request rejected'),
          backgroundColor: Colors.orange,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to reject request: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
