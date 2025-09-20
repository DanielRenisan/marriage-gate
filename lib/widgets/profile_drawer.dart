import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:matrimony_flutter/viewmodels/profile_view_model.dart';
import 'package:matrimony_flutter/services/auth_service.dart';

class ProfileDrawer extends StatelessWidget {
  final AuthService _authService = AuthService();

  ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, viewModel, child) {
        return Drawer(
          child: Column(
            children: [
              _buildProfileHeader(context, viewModel),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildMenuItem(
                      context,
                      icon: Icons.person_outline,
                      title: 'User Details',
                      onTap: () {
                        // Navigate to user details
                        Navigator.pop(context);
                        viewModel.navigateToUserDetails();
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.person_outline,
                      title: 'Current member',
                      onTap: () {
                        // Navigate to user details
                        Navigator.pop(context);
                        viewModel.navigateToUserDetails();
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.people_outline,
                      title: 'Members List',
                      onTap: () {
                        // Navigate to members list
                        Navigator.pop(context);
                        viewModel.navigateToMembersList();
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.star_outline,
                      title: 'Upgrade Plans',
                      onTap: () {
                        // Navigate to upgrade plans
                        Navigator.pop(context);
                        viewModel.navigateToUpgradePlans();
                      },
                    ),
                  ],
                ),
              ),
              _buildBottomSection(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(BuildContext context, ProfileViewModel viewModel) {
    final currentMember = viewModel.userProfile;

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        bottom: 16,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.red,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 40.r,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 38.r,
                  backgroundImage: currentMember?.profileImages != null && currentMember!.profileImages.isNotEmpty
                      ? NetworkImage(currentMember.profileImages.first.url)
                      : null,
                  child: currentMember?.profileImages == null || currentMember!.profileImages.isEmpty
                      ? Icon(Icons.person, size: 40.r, color: Colors.grey)
                      : null,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.all(2.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    width: 12.r,
                    height: 12.r,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            '${currentMember?.firstName ?? ''} ${currentMember?.lastName ?? ''}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (currentMember?.email != null)
            Text(
              currentMember!.email,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14.sp,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.grey[700]),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: onTap,
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey[200],
          ),
      ],
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(
          top: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // App Icon/Logo
          Image.asset(
            'assets/icons/app_icon/icon.png', // Make sure this path is correct
            height: 40.h,
          ),
          SizedBox(height: 16.h),
          // Logout Button
          TextButton.icon(
            onPressed: () async {
              await _authService.clearAllData();
              // Navigate to login screen and clear all routes
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (route) => false,
                );
              }
            },
            icon: const Icon(Icons.logout, color: Colors.red),
            label: Text(
              'Logout',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
