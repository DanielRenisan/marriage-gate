import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:matrimony_flutter/providers/auth_provider.dart';
import 'package:matrimony_flutter/widgets/custom_button.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _darkMode = false;
  bool _locationSharing = true;
  bool _profileVisibility = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(),
            SizedBox(height: 24.h),
            _buildNotificationSection(),
            SizedBox(height: 24.h),
            _buildPrivacySection(),
            SizedBox(height: 24.h),
            _buildAppSettingsSection(),
            SizedBox(height: 24.h),
            _buildSupportSection(),
            SizedBox(height: 24.h),
            _buildAccountSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16.h),
            _buildSettingTile(
              icon: Icons.person,
              title: 'Edit Profile',
              subtitle: 'Update your personal information',
              onTap: () {
                // TODO: Navigate to edit profile
                Fluttertoast.showToast(
                  msg: 'Edit profile coming soon!',
                  backgroundColor: Colors.blue,
                );
              },
            ),
            _buildSettingTile(
              icon: Icons.photo_camera,
              title: 'Change Profile Photo',
              subtitle: 'Update your profile picture',
              onTap: () {
                // TODO: Image picker functionality
                Fluttertoast.showToast(
                  msg: 'Photo upload coming soon!',
                  backgroundColor: Colors.blue,
                );
              },
            ),
            _buildSettingTile(
              icon: Icons.favorite,
              title: 'Match Preferences',
              subtitle: 'Set your matching criteria',
              onTap: () {
                // TODO: Navigate to match preferences
                Fluttertoast.showToast(
                  msg: 'Match preferences coming soon!',
                  backgroundColor: Colors.blue,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSection() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notifications',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16.h),
            _buildSwitchTile(
              icon: Icons.notifications,
              title: 'Push Notifications',
              subtitle: 'Receive notifications on your device',
              value: _pushNotifications,
              onChanged: (value) {
                setState(() {
                  _pushNotifications = value;
                });
              },
            ),
            _buildSwitchTile(
              icon: Icons.email,
              title: 'Email Notifications',
              subtitle: 'Receive notifications via email',
              value: _emailNotifications,
              onChanged: (value) {
                setState(() {
                  _emailNotifications = value;
                });
              },
            ),
            _buildSettingTile(
              icon: Icons.notification_important,
              title: 'Notification Settings',
              subtitle: 'Customize notification preferences',
              onTap: () {
                // TODO: Navigate to detailed notification settings
                Fluttertoast.showToast(
                  msg: 'Notification settings coming soon!',
                  backgroundColor: Colors.blue,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacySection() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy & Security',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16.h),
            _buildSwitchTile(
              icon: Icons.visibility,
              title: 'Profile Visibility',
              subtitle: 'Make your profile visible to others',
              value: _profileVisibility,
              onChanged: (value) {
                setState(() {
                  _profileVisibility = value;
                });
              },
            ),
            _buildSwitchTile(
              icon: Icons.location_on,
              title: 'Location Sharing',
              subtitle: 'Share your location with matches',
              value: _locationSharing,
              onChanged: (value) {
                setState(() {
                  _locationSharing = value;
                });
              },
            ),
            _buildSettingTile(
              icon: Icons.security,
              title: 'Privacy Settings',
              subtitle: 'Manage your privacy preferences',
              onTap: () {
                // TODO: Navigate to privacy settings
                Fluttertoast.showToast(
                  msg: 'Privacy settings coming soon!',
                  backgroundColor: Colors.blue,
                );
              },
            ),
            _buildSettingTile(
              icon: Icons.block,
              title: 'Blocked Users',
              subtitle: 'Manage blocked profiles',
              onTap: () {
                // TODO: Navigate to blocked users
                Fluttertoast.showToast(
                  msg: 'Blocked users coming soon!',
                  backgroundColor: Colors.blue,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppSettingsSection() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'App Settings',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16.h),
            _buildSwitchTile(
              icon: Icons.dark_mode,
              title: 'Dark Mode',
              subtitle: 'Switch to dark theme',
              value: _darkMode,
              onChanged: (value) {
                setState(() {
                  _darkMode = value;
                });
                // TODO: Implement dark mode
                Fluttertoast.showToast(
                  msg: 'Dark mode coming soon!',
                  backgroundColor: Colors.blue,
                );
              },
            ),
            _buildSettingTile(
              icon: Icons.language,
              title: 'Language',
              subtitle: 'English',
              onTap: () {
                // TODO: Language selection
                Fluttertoast.showToast(
                  msg: 'Language selection coming soon!',
                  backgroundColor: Colors.blue,
                );
              },
            ),
            _buildSettingTile(
              icon: Icons.storage,
              title: 'Clear Cache',
              subtitle: 'Free up storage space',
              onTap: () {
                _showClearCacheDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportSection() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Support & Help',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16.h),
            _buildSettingTile(
              icon: Icons.help,
              title: 'Help Center',
              subtitle: 'Get help and support',
              onTap: () {
                // TODO: Navigate to help center
                Fluttertoast.showToast(
                  msg: 'Help center coming soon!',
                  backgroundColor: Colors.blue,
                );
              },
            ),
            _buildSettingTile(
              icon: Icons.feedback,
              title: 'Send Feedback',
              subtitle: 'Share your thoughts with us',
              onTap: () {
                // TODO: Feedback functionality
                Fluttertoast.showToast(
                  msg: 'Feedback coming soon!',
                  backgroundColor: Colors.blue,
                );
              },
            ),
            _buildSettingTile(
              icon: Icons.bug_report,
              title: 'Report a Bug',
              subtitle: 'Report technical issues',
              onTap: () {
                // TODO: Bug report functionality
                Fluttertoast.showToast(
                  msg: 'Bug report coming soon!',
                  backgroundColor: Colors.blue,
                );
              },
            ),
            _buildSettingTile(
              icon: Icons.info,
              title: 'About',
              subtitle: 'App version and information',
              onTap: () {
                _showAboutDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSection() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16.h),
            _buildSettingTile(
              icon: Icons.lock,
              title: 'Change Password',
              subtitle: 'Update your account password',
              onTap: () {
                // TODO: Navigate to change password
                Fluttertoast.showToast(
                  msg: 'Change password coming soon!',
                  backgroundColor: Colors.blue,
                );
              },
            ),
            _buildSettingTile(
              icon: Icons.delete_forever,
              title: 'Delete Account',
              subtitle: 'Permanently delete your account',
              onTap: () {
                _showDeleteAccountDialog();
              },
              textColor: Colors.red,
            ),
            SizedBox(height: 16.h),
            CustomButton(
              text: 'Logout',
              onPressed: () {
                _showLogoutDialog();
              },
              backgroundColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: textColor ?? Colors.grey[600],
        size: 24.sp,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12.sp,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey[400],
      ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.grey[600],
        size: 24.sp,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12.sp,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.red,
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('Are you sure you want to clear the app cache?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Fluttertoast.showToast(
                msg: 'Cache cleared successfully!',
                backgroundColor: Colors.green,
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Matrimony'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Version: 1.0.0'),
            SizedBox(height: 8.h),
            const Text('Build: 1'),
            SizedBox(height: 8.h),
            const Text('© 2024 Matrimony App. All rights reserved.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to permanently delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement account deletion
              Fluttertoast.showToast(
                msg: 'Account deletion coming soon!',
                backgroundColor: Colors.red,
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _logout();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _logout() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.logout();
    
    if (mounted) {
      Fluttertoast.showToast(
        msg: 'Logged out successfully!',
        backgroundColor: Colors.green,
      );
      // TODO: Navigate to login screen
    }
  }
}
