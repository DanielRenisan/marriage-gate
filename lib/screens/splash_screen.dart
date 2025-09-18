import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:matrimony_flutter/services/auth_service.dart';
import 'package:matrimony_flutter/providers/user_provider.dart';
import 'package:matrimony_flutter/providers/member_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkUserStatusAndNavigate();
  }

  Future<void> _checkUserStatusAndNavigate() async {
    // Add a small delay to show splash screen
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    try {
      // Check if user is logged in
      final isLoggedIn = await _authService.isLoggedIn();

      if (!mounted) return;

      if (!isLoggedIn) {
        // User is not logged in, navigate to login
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      // User is logged in, get auth token
      final authToken = await _authService.getAuthToken();
      if (authToken == null) {
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      // Step 1: Get user details (GET /api/User)
      final userResponse = await _authService.getUserDetails(authToken);

      if (!mounted) return;

      if (userResponse.isError || userResponse.result == null) {
        // Failed to get user details, navigate to login
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      // Set user data in provider
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userResponse.result!;
      userProvider.setCurrentUser(user);

      // Check if user type is Member
      final userType = await _authService.getUserType();

      if (!mounted) return;

      if (userType == 'Member') {
        // Step 2: Get member profiles (GET /api/Profile/user)
        final memberProvider = Provider.of<MemberProvider>(context, listen: false);

        try {
          await memberProvider.loadMemberProfiles();

          if (!mounted) return;

          if (memberProvider.memberProfiles.isEmpty) {
            // No members found - navigate to member registration
            Navigator.pushReplacementNamed(context, '/member-registration');
          } else if (memberProvider.memberProfiles.length == 1) {
            // Single member - set as current and navigate to matching profiles (main screen)
            memberProvider.setCurrentUserProfile(memberProvider.memberProfiles.first);
            Navigator.pushReplacementNamed(context, '/main');
          } else {
            // Multiple members - navigate to profile selection
            Navigator.pushReplacementNamed(context, '/profile-selection');
          }
        } catch (e) {
          // If there's an error loading profiles, navigate to member registration
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/member-registration');
          }
        }
      } else {
        // Non-member user, navigate to appropriate screen
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      // If there's an error, navigate to login
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.favorite,
                size: 60,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 24),

            // App Name
            const Text(
              'Matrimony',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),

            // Tagline
            const Text(
              'Find your perfect match',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 40),

            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
