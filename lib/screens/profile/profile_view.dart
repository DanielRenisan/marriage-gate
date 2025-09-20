import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:matrimony_flutter/viewmodels/profile_view_model.dart';
import 'package:matrimony_flutter/utils/popup_utils.dart';
import 'package:matrimony_flutter/models/member.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late ProfileViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<ProfileViewModel>();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    await _viewModel.loadUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _viewModel.navigateToEditProfile,
          ),
        ],
      ),
      body: Consumer<ProfileViewModel>(
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
                    onPressed: _loadProfile,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (!viewModel.isProfileLoaded || viewModel.userProfile == null) {
            return const Center(
              child: Text('No profile data available'),
            );
          }

          final profile = viewModel.userProfile!;
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(profile, viewModel),
                SizedBox(height: 24.h),
                _buildProfileSections(profile, viewModel),
                SizedBox(height: 24.h),
                _buildActionButtons(context, viewModel),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(MemberProfile profile, ProfileViewModel viewModel) {
    return Container(
      padding: EdgeInsets.all(16.w),
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
      child: Row(
        children: [
          CircleAvatar(
            radius: 50.r,
            backgroundImage: NetworkImage(
              profile.profileImage ?? profile.profileImages.firstOrNull?.url ?? 'https://via.placeholder.com/100x100',
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${profile.firstName} ${profile.lastName}',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${viewModel.calculateAge(profile.dateOfBirth)} • ${profile.city ?? 'Location not specified'}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8.h),
                if (profile.aboutMe.isNotEmpty)
                  Text(
                    profile.aboutMe,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[700],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSections(MemberProfile profile, ProfileViewModel viewModel) {
    return Column(
      children: [
        _buildInfoSection('Personal Information', [
          _buildInfoRow('Name', '${profile.firstName} ${profile.lastName}'),
          _buildInfoRow('Age', viewModel.calculateAge(profile.dateOfBirth)),
          _buildInfoRow('Gender', profile.gender == 1 ? 'Male' : 'Female'),
          _buildInfoRow('Marital Status', profile.maritalStatus ?? 'Not specified'),
          _buildInfoRow('Height', '${profile.height} cm'),
          _buildInfoRow('Weight', '${profile.weight} kg'),
          _buildInfoRow('Blood Group', viewModel.getBloodGroupText(profile.bloodGroup)),
          _buildInfoRow('Body Type', viewModel.getBodyTypeText(profile.bodyType)),
          _buildInfoRow('Complexion', profile.complexion ?? 'Not specified'),
        ]),
        SizedBox(height: 16.h),
        _buildInfoSection('Contact Information', [
          _buildInfoRow('Email', profile.email),
          _buildInfoRow('Phone', profile.phoneNumber),
          _buildInfoRow('Address', profile.address ?? 'Not specified'),
          _buildInfoRow('City', profile.city ?? 'Not specified'),
          _buildInfoRow('State', profile.state ?? 'Not specified'),
          _buildInfoRow('Country', profile.country ?? 'Not specified'),
          _buildInfoRow('Pincode', profile.pincode ?? 'Not specified'),
        ]),
        SizedBox(height: 16.h),
        _buildInfoSection('Education & Career', [
          _buildInfoRow('Education', profile.education ?? 'Not specified'),
          _buildInfoRow('Occupation', profile.occupation ?? 'Not specified'),
          _buildInfoRow('Income', profile.income ?? 'Not specified'),
        ]),
        SizedBox(height: 16.h),
        _buildInfoSection('Family Information', [
          _buildInfoRow('Father\'s Name', profile.fatherName ?? 'Not specified'),
          _buildInfoRow('Mother\'s Name', profile.motherName ?? 'Not specified'),
          _buildInfoRow('Family Type', profile.familyType ?? 'Not specified'),
          _buildInfoRow('Family Status', profile.familyStatus ?? 'Not specified'),
          _buildInfoRow('Family Income', profile.familyIncome ?? 'Not specified'),
        ]),
        SizedBox(height: 16.h),
        _buildInfoSection('Religious Background', [
          _buildInfoRow('Religion', profile.religion ?? 'Not specified'),
          _buildInfoRow('Caste', profile.caste ?? 'Not specified'),
          _buildInfoRow('Gotra', profile.gotra ?? 'Not specified'),
          _buildInfoRow('Manglik', profile.manglik ?? 'Not specified'),
        ]),
        SizedBox(height: 16.h),
        _buildInfoSection('Lifestyle', [
          _buildInfoRow('Diet', profile.diet ?? 'Not specified'),
          _buildInfoRow('Drinking Habit', profile.drinkHabit ?? 'Not specified'),
          _buildInfoRow('Smoking Habit', profile.smokeHabitText ?? 'Not specified'),
          _buildInfoRow('Known Languages', profile.knownLanguages ?? 'Not specified'),
        ]),
        if (profile.matchPreferences != null) ...[
          SizedBox(height: 16.h),
          _buildInfoSection('Match Preferences', [
            _buildInfoRow('Preferred Gender', profile.matchPreferences!.gender ?? 'Not specified'),
            _buildInfoRow(
                'Age Range', '${profile.matchPreferences!.minAge ?? 'N/A'} - ${profile.matchPreferences!.maxAge ?? 'N/A'}'),
            _buildInfoRow('Preferred Caste', profile.matchPreferences!.caste ?? 'Not specified'),
            _buildInfoRow('Preferred Occupation', profile.matchPreferences!.occupation ?? 'Not specified'),
            _buildInfoRow('Preferred Income', profile.matchPreferences!.income ?? 'Not specified'),
            _buildInfoRow('Preferred Location', profile.matchPreferences!.city ?? 'Not specified'),
          ]),
        ],
      ],
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(16.w),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          SizedBox(height: 12.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
                fontSize: 14.sp,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, ProfileViewModel viewModel) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: viewModel.navigateToMatches,
            icon: const Icon(Icons.favorite),
            label: const Text('View Matches'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12.h),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: viewModel.navigateToPrivacySettings,
            icon: const Icon(Icons.privacy_tip),
            label: const Text('Privacy Settings'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              padding: EdgeInsets.symmetric(vertical: 12.h),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _showDeleteConfirmation(context, viewModel),
            icon: const Icon(Icons.delete_forever),
            label: const Text('Delete Profile'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              padding: EdgeInsets.symmetric(vertical: 12.h),
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, ProfileViewModel viewModel) {
    viewModel.showDeleteConfirmation(context, () async {
      await viewModel.deleteProfile();
      if (viewModel.hasError) {
        DialogUtils.showErrorDialog(
          context,
          title: 'Error',
          message: viewModel.errorMessage ?? 'Failed to delete profile',
        );
      } else {
        DialogUtils.showSuccessDialog(
          context,
          title: 'Success',
          message: 'Profile deleted successfully',
          onConfirm: () {
            // TODO: Navigate to login screen
            Navigator.of(context).pushReplacementNamed('/login');
          },
        );
      }
    });
  }
}
