import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:matrimony_flutter/providers/member_provider.dart';
import 'package:matrimony_flutter/models/member.dart';
import 'package:matrimony_flutter/screens/member-registration/member_registration_screen.dart';
import 'package:matrimony_flutter/screens/main/main_screen.dart';
import 'package:matrimony_flutter/utils/dialog_utils.dart';

class ProfileSelectionScreen extends StatefulWidget {
  const ProfileSelectionScreen({super.key});

  @override
  State<ProfileSelectionScreen> createState() => _ProfileSelectionScreenState();
}

class _ProfileSelectionScreenState extends State<ProfileSelectionScreen> {
  @override
  void initState() {
    super.initState();
    // Defer the API call until after the build phase is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMemberProfiles();
    });
  }

  Future<void> _loadMemberProfiles() async {
    try {
      final memberProvider = Provider.of<MemberProvider>(context, listen: false);
      await memberProvider.loadMemberProfiles();
    } catch (e) {
      if (mounted) {
        DialogUtils.showErrorDialog(
          context,
          title: 'Error',
          message: 'Failed to load member profiles: ${e.toString().replaceAll('Exception: ', '')}',
        );
      }
    }
  }

  void _selectMemberProfile(UserProfile profile) {
    final memberProvider = Provider.of<MemberProvider>(context, listen: false);
    memberProvider.setCurrentUserProfile(profile);

    // Navigate to main screen (with bottom navigation)
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const MainScreen()),
      (route) => false,
    );
  }

  void _createNewMember() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const MemberRegistrationScreen()),
    );
  }

  void _deleteMemberProfile(String profileId) {
    DialogUtils.showConfirmationDialog(
      context,
      title: 'Delete Profile',
      message: 'Are you sure you want to delete this member profile? This action cannot be undone.',
      onConfirm: () async {
        try {
          final memberProvider = Provider.of<MemberProvider>(context, listen: false);
          await memberProvider.deleteMemberProfile(profileId);

          if (mounted) {
            DialogUtils.showSuccessDialog(
              context,
              title: 'Success',
              message: 'Member profile deleted successfully.',
            );
          }
        } catch (e) {
          if (mounted) {
            DialogUtils.showErrorDialog(
              context,
              title: 'Error',
              message: 'Failed to delete member profile: ${e.toString().replaceAll('Exception: ', '')}',
            );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Member Profile'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Consumer<MemberProvider>(
        builder: (context, memberProvider, child) {
          if (memberProvider.isLoadingProfiles) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            );
          }

          return Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    Text(
                      'Member Profiles',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Select a member profile to continue or create a new one',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              // Member Profiles List
              Expanded(
                child: memberProvider.memberProfiles.isEmpty ? _buildEmptyState() : _buildMemberProfilesList(memberProvider),
              ),

              // Add New Member Button
              Container(
                padding: EdgeInsets.all(16.w),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _createNewMember,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 20.sp),
                        SizedBox(width: 8.w),
                        Text(
                          'Add New Member',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
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
            Icons.person_add,
            size: 80.sp,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            'No Member Profiles Found',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Create your first member profile to get started',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberProfilesList(MemberProvider memberProvider) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: memberProvider.memberProfiles.length,
      itemBuilder: (context, index) {
        final profile = memberProvider.memberProfiles[index];
        return _buildMemberProfileCard(profile);
      },
    );
  }

  Widget _buildMemberProfileCard(UserProfile profile) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: InkWell(
        onTap: () => _selectMemberProfile(profile),
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              // Profile Image
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.r),
                  image: DecorationImage(
                    image: NetworkImage(
                      profile.profileImages.isNotEmpty ? profile.profileImages.first.url : 'https://via.placeholder.com/80',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 16.w),

              // Profile Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${profile.firstName} ${profile.lastName}',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      profile.email,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    // SizedBox(height: 4.h),
                    // Text(
                    //   '${profile.age} years old',
                    //   style: TextStyle(
                    //     fontSize: 14.sp,
                    //     color: Colors.grey[600],
                    //   ),
                    // ),
                  ],
                ),
              ),

              // Action Buttons
              Column(
                children: [
                  IconButton(
                    onPressed: () => _selectMemberProfile(profile),
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.red,
                      size: 20.sp,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _deleteMemberProfile(profile.id),
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red[300],
                      size: 20.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
