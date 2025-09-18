import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:matrimony_flutter/providers/member_provider.dart';
import 'package:matrimony_flutter/screens/matches/matches_view.dart';
import 'package:matrimony_flutter/screens/chat/chat_view.dart';
import 'package:matrimony_flutter/screens/profile/profile_view.dart';
import 'package:matrimony_flutter/screens/friends/friends_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const MatchesView(),
    const ChatView(),
    const FriendsView(),
    const ProfileView(),
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final memberProvider = context.read<MemberProvider>();

    // Load member profiles first
    await memberProvider.loadMemberProfiles();

    // Load other data
    await Future.wait([
      memberProvider.loadMatchingProfiles(null, memberProvider.currentUserProfile?.id ?? '', 1, 20),
      memberProvider.loadChatParticipants(),
      memberProvider.loadFriendRequests(),
      memberProvider.loadFriends(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Matches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
