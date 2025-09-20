import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:matrimony_flutter/providers/member_provider.dart';
import 'package:matrimony_flutter/providers/auth_provider.dart';
import 'package:matrimony_flutter/providers/user_provider.dart';
import 'package:matrimony_flutter/providers/data_provider.dart';
import 'package:matrimony_flutter/viewmodels/profile_view_model.dart';
import 'package:matrimony_flutter/viewmodels/matches_view_model.dart';
import 'package:matrimony_flutter/viewmodels/chat_view_model.dart';
import 'package:matrimony_flutter/screens/profile/profile_view.dart';
import 'package:matrimony_flutter/screens/chat/chat_view.dart';
import 'package:matrimony_flutter/screens/member-registration/member_registration_screen.dart';
import 'package:matrimony_flutter/screens/profile_selection_screen.dart';
import 'package:matrimony_flutter/screens/main/main_screen.dart';
import 'package:matrimony_flutter/screens/auth/login_screen.dart';
import 'package:matrimony_flutter/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    if (kDebugMode) {
      print('Firebase initialization error: $e');
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => AuthProvider()),
            ChangeNotifierProvider(create: (context) => UserProvider()),
            ChangeNotifierProvider(create: (context) => MemberProvider()),
            ChangeNotifierProvider(create: (context) => DataProvider()),
            ChangeNotifierProxyProvider<MemberProvider, ProfileViewModel>(
              create: (context) => ProfileViewModel(context.read<MemberProvider>()),
              update: (context, memberProvider, previous) => previous ?? ProfileViewModel(memberProvider),
            ),
            ChangeNotifierProxyProvider<MemberProvider, MatchesViewModel>(
              create: (context) => MatchesViewModel(context.read<MemberProvider>()),
              update: (context, memberProvider, previous) => previous ?? MatchesViewModel(memberProvider),
            ),
            ChangeNotifierProxyProvider<MemberProvider, ChatViewModel>(
              create: (context) => ChatViewModel(context.read<MemberProvider>()),
              update: (context, memberProvider, previous) => previous ?? ChatViewModel(memberProvider),
            ),
          ],
          child: MaterialApp(
            title: 'Matrimony App',
            theme: ThemeData(
              primarySwatch: Colors.red,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            initialRoute: '/',
            routes: {
              '/': (context) => const SplashScreen(),
              '/login': (context) => const LoginScreen(),
              '/profile-selection': (context) => const ProfileSelectionScreen(),
              '/member-registration': (context) => const MemberRegistrationScreen(),
              '/main': (context) => const MainScreen(),
              '/profile': (context) => const ProfileView(),
              '/chat': (context) => const ChatView(),
            },
          ),
        );
      },
    );
  }
}
