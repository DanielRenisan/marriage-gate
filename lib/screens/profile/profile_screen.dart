import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:matrimony_flutter/providers/member_provider.dart';
import 'package:matrimony_flutter/models/member.dart';
import 'package:matrimony_flutter/services/auth_service.dart';
import 'package:matrimony_flutter/widgets/custom_button.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserProfile();
    });
  }

  void _loadUserProfile() async {
    final authService = AuthService();
    final memberProvider = context.read<MemberProvider>();
    
    try {
      final token = await authService.getAuthToken();
      if (token != null) {
        final userData = authService.getTokenDecodeData(token);
        final userId = userData['UserId'];
        if (userId != null) {
          await memberProvider.loadCurrentUserProfile(userId.toString());
        }
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to load profile',
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit profile screen
              Fluttertoast.showToast(
                msg: 'Edit profile coming soon!',
                backgroundColor: Colors.blue,
              );
            },
          ),
        ],
      ),
      body: Consumer<MemberProvider>(
        builder: (context, memberProvider, child) {
          final profile = memberProvider.currentUserProfile;
          
          if (profile == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                _buildProfileHeader(profile),
                SizedBox(height: 24.h),
                _buildProfileSections(profile),
                SizedBox(height: 24.h),
                _buildActionButtons(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(UserProfile profile) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 60.r,
                  backgroundImage: NetworkImage(
                    profile.profileImage ?? 
                    profile.profileImages.firstOrNull?.url ?? 
                    'https://via.placeholder.com/120x120?text=No+Image',
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 30.w,
                    height: 30.h,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              '${profile.firstName ?? ''} ${profile.lastName ?? ''}',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              '${_calculateAge(profile.dateOfBirth)} • ${profile.city ?? 'Location not specified'}',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
              ),
            ),
            if (profile.aboutMe.isNotEmpty) ...[
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  profile.aboutMe,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[700],
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSections(UserProfile profile) {
    return Column(
      children: [
        _buildSection(
          'Personal Information',
          Icons.person,
          [
            _buildInfoRow('Age', _calculateAge(profile.dateOfBirth)),
            _buildInfoRow('Gender', profile.gender == 1 ? 'Male' : 'Female'),
            _buildInfoRow('Marital Status', profile.maritalStatus ?? 'Not specified'),
            _buildInfoRow('Height', '${profile.height} cm'),
            _buildInfoRow('Weight', '${profile.weight} kg'),
            _buildInfoRow('Blood Group', profile.bloodGroup == 1 ? 'A+' : profile.bloodGroup == 2 ? 'A-' : profile.bloodGroup == 3 ? 'B+' : profile.bloodGroup == 4 ? 'B-' : profile.bloodGroup == 5 ? 'AB+' : profile.bloodGroup == 6 ? 'AB-' : profile.bloodGroup == 7 ? 'O+' : profile.bloodGroup == 8 ? 'O-' : 'Not specified'),
            _buildInfoRow('Complexion', profile.complexion ?? 'Not specified'),
          ],
        ),
        SizedBox(height: 16.h),
        _buildSection(
          'Contact Information',
          Icons.contact_mail,
          [
            _buildInfoRow('Email', profile.email ?? 'Not specified'),
            _buildInfoRow('Phone', profile.phoneNumber ?? 'Not specified'),
            _buildInfoRow('Address', profile.address ?? 'Not specified'),
            _buildInfoRow('City', profile.city ?? 'Not specified'),
            _buildInfoRow('State', profile.state ?? 'Not specified'),
            _buildInfoRow('Country', profile.country ?? 'Not specified'),
            _buildInfoRow('Pincode', profile.pincode ?? 'Not specified'),
          ],
        ),
        SizedBox(height: 16.h),
        _buildSection(
          'Education & Career',
          Icons.school,
          [
            _buildInfoRow('Education', profile.education ?? 'Not specified'),
            _buildInfoRow('Occupation', profile.occupation ?? 'Not specified'),
            _buildInfoRow('Income', profile.income ?? 'Not specified'),
          ],
        ),
        SizedBox(height: 16.h),
        _buildSection(
          'Religious Background',
          Icons.church,
          [
            _buildInfoRow('Religion', profile.religion ?? 'Not specified'),
            _buildInfoRow('Caste', profile.caste ?? 'Not specified'),
            _buildInfoRow('Gotra', profile.gotra ?? 'Not specified'),
            _buildInfoRow('Manglik', profile.manglik ?? 'Not specified'),
          ],
        ),
        SizedBox(height: 16.h),
        _buildSection(
          'Family Information',
          Icons.family_restroom,
          [
            _buildInfoRow('Family Type', profile.familyType ?? 'Not specified'),
            _buildInfoRow('Family Status', profile.familyStatus ?? 'Not specified'),
            _buildInfoRow('Family Income', profile.familyIncome ?? 'Not specified'),
            _buildInfoRow('Father\'s Name', profile.fatherName ?? 'Not specified'),
            _buildInfoRow('Mother\'s Name', profile.motherName ?? 'Not specified'),
            _buildInfoRow('Siblings', profile.siblings?.toString() ?? 'Not specified'),
          ],
        ),
        SizedBox(height: 16.h),
        _buildSection(
          'Personal Details',
          Icons.info,
          [
            _buildInfoRow('Mother Tongue', profile.motherTongue ?? 'Not specified'),
            _buildInfoRow('Diet', profile.diet ?? 'Not specified'),
            _buildInfoRow('Drink Habit', profile.drinkHabit ?? 'Not specified'),
            _buildInfoRow('Smoke Habit', profile.smokeHabitText ?? 'Not specified'),
            _buildInfoRow('Body Type', profile.bodyType == 1 ? 'Average' : profile.bodyType == 2 ? 'Slim' : profile.bodyType == 3 ? 'Athletic' : profile.bodyType == 4 ? 'Heavy' : 'Not specified'),
            if (profile.knownLanguages != null && profile.knownLanguages!.isNotEmpty)
              _buildInfoRow('Known Languages', profile.knownLanguages!),
            if (profile.disability.isNotEmpty)
              _buildInfoRow('Disability', profile.disability),
          ],
        ),
        if (profile.matchPreferences != null) ...[
          SizedBox(height: 16.h),
          _buildSection(
            'Match Preferences',
            Icons.favorite,
            [
              _buildInfoRow('Preferred Gender', profile.matchPreferences!.gender ?? 'Not specified'),
              _buildInfoRow('Age Range', '${profile.matchPreferences!.minAge ?? 'N/A'} - ${profile.matchPreferences!.maxAge ?? 'N/A'}'),
              _buildInfoRow('Preferred Marital Status', profile.matchPreferences!.maritalStatus ?? 'Not specified'),
              _buildInfoRow('Preferred Religion', profile.matchPreferences!.religion ?? 'Not specified'),
              _buildInfoRow('Preferred Caste', profile.matchPreferences!.caste ?? 'Not specified'),
              _buildInfoRow('Preferred Education', profile.matchPreferences!.education ?? 'Not specified'),
              _buildInfoRow('Preferred Occupation', profile.matchPreferences!.occupation ?? 'Not specified'),
              _buildInfoRow('Preferred Income', profile.matchPreferences!.income ?? 'Not specified'),
              _buildInfoRow('Preferred City', profile.matchPreferences!.city ?? 'Not specified'),
              _buildInfoRow('Preferred State', profile.matchPreferences!.state ?? 'Not specified'),
              _buildInfoRow('Preferred Country', profile.matchPreferences!.country ?? 'Not specified'),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
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
            Row(
              children: [
                Icon(
                  icon,
                  color: Colors.red,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
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

  Widget _buildActionButtons() {
    return Column(
      children: [
        CustomButton(
          text: 'Edit Profile',
          onPressed: () {
            // TODO: Navigate to edit profile screen
            Fluttertoast.showToast(
              msg: 'Edit profile coming soon!',
              backgroundColor: Colors.blue,
            );
          },
        ),
        SizedBox(height: 12.h),
        CustomButton(
          text: 'View My Matches',
          onPressed: () {
            // TODO: Navigate to matches screen
            Fluttertoast.showToast(
              msg: 'Viewing your matches!',
              backgroundColor: Colors.green,
            );
          },
          backgroundColor: Colors.green,
        ),
        SizedBox(height: 12.h),
        CustomButton(
          text: 'Privacy Settings',
          onPressed: () {
            // TODO: Navigate to privacy settings
            Fluttertoast.showToast(
              msg: 'Privacy settings coming soon!',
              backgroundColor: Colors.orange,
            );
          },
          backgroundColor: Colors.orange,
        ),
        SizedBox(height: 12.h),
        CustomButton(
          text: 'Delete Profile',
          onPressed: () {
            _showDeleteConfirmation();
          },
          backgroundColor: Colors.red,
        ),
      ],
    );
  }

  String _calculateAge(String? dateOfBirth) {
    if (dateOfBirth == null) return 'N/A';
    
    try {
      final birthDate = DateTime.parse(dateOfBirth);
      final now = DateTime.now();
      int age = now.year - birthDate.year;
      if (now.month < birthDate.month || 
          (now.month == birthDate.month && now.day < birthDate.day)) {
        age--;
      }
      return '$age years';
    } catch (e) {
      return 'N/A';
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Profile'),
        content: const Text(
          'Are you sure you want to delete your profile? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteProfile();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deleteProfile() async {
    final memberProvider = context.read<MemberProvider>();
    final profile = memberProvider.currentUserProfile;
    
    if (profile?.id == null) {
      Fluttertoast.showToast(
        msg: 'Profile not found',
        backgroundColor: Colors.red,
      );
      return;
    }

    try {
      await memberProvider.deleteMemberProfile(profile!.id);
      Fluttertoast.showToast(
        msg: 'Profile deleted successfully',
        backgroundColor: Colors.green,
      );
      // TODO: Navigate to login screen or handle logout
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to delete profile',
        backgroundColor: Colors.red,
      );
    }
  }
}
