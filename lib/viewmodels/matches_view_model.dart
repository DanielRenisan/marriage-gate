import 'package:flutter/material.dart';
import 'package:matrimony_flutter/providers/member_provider.dart';
import 'package:matrimony_flutter/viewmodels/base_view_model.dart';

import '../models/matching_profile_response.dart';
import '../models/matching_profiles_request.dart';

class MatchesViewModel extends BaseViewModel {
  final MemberProvider _memberProvider;

  List<MatchingProfile> _matchingProfiles = [];
  List<MatchingProfile> _filteredProfiles = [];
  String _searchTerm = '';
  final bool _isSearching = false;
  MatchingProfilesRequest? _activeFilters;

  MatchesViewModel(this._memberProvider);

  List<MatchingProfile> get matchingProfiles => _matchingProfiles;
  List<MatchingProfile> get filteredProfiles => _filteredProfiles;
  String get searchTerm => _searchTerm;
  bool get isSearching => _isSearching;
  bool get hasProfiles => _filteredProfiles.isNotEmpty;
  MatchingProfilesRequest? get activeFilters => _activeFilters;

  Future<void> loadMatchingProfiles() async {
    await handleAsyncOperation(() async {
      await _memberProvider.loadMatchingProfiles(_activeFilters, _memberProvider.currentUserProfile?.id ?? '', 1, 20);
      _matchingProfiles = _memberProvider.matchingProfiles;
      _filteredProfiles = _matchingProfiles;
    });
  }

  void setSearchTerm(String term) {
    _searchTerm = term;
    _filterProfiles();
  }

  void _filterProfiles() {
    if (_searchTerm.isEmpty) {
      _filteredProfiles = _matchingProfiles;
    } else {
      _filteredProfiles = _matchingProfiles.where((profile) {
        final fullName = '${profile.firstName} ${profile.lastName}'.toLowerCase();
        final city = profile.livingAddresses.city.isNotEmpty ? profile.livingAddresses.city.toLowerCase() : '';
        final jobTitle = profile.jobTitle.toLowerCase();
        final searchLower = _searchTerm.toLowerCase();

        return fullName.contains(searchLower) || city.contains(searchLower) || jobTitle.contains(searchLower);
      }).toList();
    }
    notifyListeners();
  }

  // Apply new filters and reload from API
  Future<void> applyFilters(MatchingProfilesRequest filters) async {
    _activeFilters = filters;
    await loadMatchingProfiles();
  }

  // Clear filters back to defaults and reload
  Future<void> clearFilters() async {
    _activeFilters = null;
    await loadMatchingProfiles();
  }

  String calculateAge(String? dateOfBirth) {
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

  Future<void> sendFriendRequest(String profileId) async {
    await handleAsyncOperation(() async {
      await _memberProvider.sendFriendRequest(profileId);
    });
  }

  void showProfileDetails(BuildContext context, MatchingProfile profile) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildProfileDetailsSheet(context, profile),
    );
  }

  Widget _buildProfileDetailsSheet(BuildContext context, MatchingProfile profile) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(context, profile),
                  const SizedBox(height: 24),
                  _buildDetailSection('Personal Information', [
                    _buildDetailRow('Name', '${profile.firstName} ${profile.lastName}'),
                    _buildDetailRow('Age', calculateAge(profile.dateOfBirth)),
                    _buildDetailRow('Gender', profile.gender == 1 ? 'Male' : 'Female'),
                    // _buildDetailRow('Marital Status', profile. ?? 'Not specified'),
                    // _buildDetailRow('Height', '${profile.height} cm'),
                    // _buildDetailRow('Weight', '${profile.weight} kg'),
                  ]),
                  const SizedBox(height: 16),
                  _buildDetailSection('Contact Information', [
                    _buildDetailRow('City', profile.city ?? 'Not specified'),
                    _buildDetailRow('State', profile.state ?? 'Not specified'),
                    _buildDetailRow('Country', profile.country ?? 'Not specified'),
                  ]),
                  const SizedBox(height: 16),
                  _buildDetailSection('Education & Career', [
                    // _buildDetailRow('Education', profile.education ?? 'Not specified'),
                    _buildDetailRow('Occupation', profile.occupation ?? 'Not specified'),
                    // _buildDetailRow('Income', profile.income ?? 'Not specified'),
                  ]),
                  // if (profile.aboutMe.isNotEmpty) ...[
                  //   const SizedBox(height: 16),
                  //   _buildDetailSection('About', [
                  //     _buildDetailRow('', profile.aboutMe),
                  //   ]),
                  // ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, MatchingProfile profile) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage(
            profile.profileImage ?? 'https://via.placeholder.com/80x80?text=No+Image',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${profile.firstName} ${profile.lastName}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${calculateAge(profile.dateOfBirth)} • ${profile.city ?? 'Location not specified'}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty) ...[
            SizedBox(
              width: 100,
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
