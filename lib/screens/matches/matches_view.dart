import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:matrimony_flutter/viewmodels/matches_view_model.dart';
import '../../models/matching_profile_response.dart';
import '../../models/matching_profiles_request.dart';
import 'matching_profile_filter.dart';

class MatchesView extends StatefulWidget {
  const MatchesView({super.key});

  @override
  State<MatchesView> createState() => _MatchesViewState();
}

class _MatchesViewState extends State<MatchesView> {
  late MatchesViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<MatchesViewModel>();
    _loadMatches();
  }

  Future<void> _loadMatches() async {
    await _viewModel.loadMatchingProfiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Matches'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Consumer<MatchesViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: TextField(
                          onChanged: (value) => viewModel.setSearchTerm(value),
                          decoration: InputDecoration(
                            hintText: 'Search by name, city, or occupation...',
                            prefixIcon: const Icon(Icons.search),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Container(
                      height: 40.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.filter_list, color: Colors.white),
                        onPressed: _openFilter,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
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
                              onPressed: _loadMatches,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (!viewModel.hasProfiles) {
                      return const Center(
                        child: Text('No matches found'),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: _loadMatches,
                      child: GridView.builder(
                        padding: EdgeInsets.all(16.w),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 12.h,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: viewModel.filteredProfiles.length,
                        itemBuilder: (context, index) {
                          final profile = viewModel.filteredProfiles[index];
                          return Container(
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
                            child: InkWell(
                              onTap: () => viewModel.showProfileDetails(context, profile),
                              borderRadius: BorderRadius.circular(12.r),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(12.r),
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(12.r),
                                        ),
                                        child: Image.network(
                                          profile.profileImage ?? 'https://via.placeholder.com/150',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.w),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            '${profile.firstName} ${profile.lastName}',
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            '${viewModel.calculateAge(profile.dateOfBirth)} yrs',
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          Text(
                                            profile.livingAddresses.city,
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: Colors.grey[600],
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _openFilter() async {
    final current = _viewModel.activeFilters ?? MatchingProfilesRequest.defaultRequest();

    final result = await showModalBottomSheet<MatchingProfilesRequest>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.95,
          minChildSize: 0.6,
          maxChildSize: 0.95,
          builder: (context, controller) {
            return MatchingProfileFilter(
              initial: current,
              scrollController: controller,
            );
          },
        );
      },
    );

    if (!mounted) return;

    if (result != null) {
      await _viewModel.applyFilters(result);
    }
  }

  Widget _buildMatchCard(MatchingProfile profile, MatchesViewModel viewModel) {
    return Container(
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
      child: InkWell(
        onTap: () => viewModel.showProfileDetails(context, profile),
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                  child: Stack(
                    children: [
                      // Profile Image with error handling
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Image.network(
                          profile.profileImage ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.person,
                                    size: 40.sp,
                                    color: Colors.grey[400],
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    'No Image',
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: Colors.grey[200],
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                      : null,
                                  strokeWidth: 2.0,
                                  color: Colors.red,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // Gradient Overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.1),
                            ],
                          ),
                        ),
                      ),
                      // View Icon Button
                      Positioned(
                        top: 8.h,
                        right: 8.w,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () => viewModel.showProfileDetails(context, profile),
                            icon: Icon(
                              Icons.visibility,
                              color: Colors.red,
                              size: 18.sp,
                            ),
                            padding: EdgeInsets.all(6.w),
                            constraints: BoxConstraints(
                              minWidth: 32.w,
                              minHeight: 32.h,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Profile Information
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Name
                    Text(
                      '${profile.firstName} ${profile.lastName}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Age and Location
                    Text(
                      '${viewModel.calculateAge(profile.dateOfBirth)} • ${profile.city ?? 'Location N/A'}',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Job Title
                    Text(
                      profile.occupation ?? 'Occupation N/A',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Religion
                    Text(
                      profile.religion,
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Removed _showSearchDialog as it's no longer needed with the new search bar
}
