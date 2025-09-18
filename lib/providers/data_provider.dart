import 'package:flutter/material.dart';
import 'package:matrimony_flutter/services/data_service.dart';
import 'package:matrimony_flutter/models/education_qualification.dart';
import 'package:matrimony_flutter/models/community.dart';
import 'package:matrimony_flutter/models/job_type.dart';
import 'package:matrimony_flutter/models/religion.dart';
import 'package:matrimony_flutter/models/member.dart' as member_models;

class DataProvider extends ChangeNotifier {
  final DataService _dataService = DataService();

  // Data lists
  List<EducationQualification> _educationQualifications = [];
  List<Community> _communities = [];
  List<JobType> _jobTypes = [];
  List<Religion> _religions = [];
  List<member_models.Country> _countries = [];

  // Loading states
  bool _isLoadingEducation = false;
  bool _isLoadingCommunities = false;
  bool _isLoadingJobTypes = false;
  bool _isLoadingReligions = false;
  bool _isLoadingCountries = false;

  // Getters
  List<EducationQualification> get educationQualifications => _educationQualifications;
  List<Community> get communities => _communities;
  List<JobType> get jobTypes => _jobTypes;
  List<Religion> get religions => _religions;
  List<member_models.Country> get countries => _countries;

  bool get isLoadingEducation => _isLoadingEducation;
  bool get isLoadingCommunities => _isLoadingCommunities;
  bool get isLoadingJobTypes => _isLoadingJobTypes;
  bool get isLoadingReligions => _isLoadingReligions;
  bool get isLoadingCountries => _isLoadingCountries;

  // Initialize data
  Future<void> initializeData() async {
    await Future.wait([
      fetchEducationQualifications(),
      fetchCommunities(),
      fetchJobTypes(),
      fetchReligions(),
      fetchCountries(),
    ]);
  }

  // Fetch Education Qualifications
  Future<void> fetchEducationQualifications() async {
    try {
      _isLoadingEducation = true;
      notifyListeners();

      _educationQualifications = await _dataService.getEducationQualifications();
      
    } catch (e) {
      _educationQualifications = [];
    } finally {
      _isLoadingEducation = false;
      notifyListeners();
    }
  }

  // Fetch Communities
  Future<void> fetchCommunities() async {
    try {
      _isLoadingCommunities = true;
      notifyListeners();

      _communities = await _dataService.getCommunities();
      
    } catch (e) {
      _communities = [];
    } finally {
      _isLoadingCommunities = false;
      notifyListeners();
    }
  }

  // Fetch Job Types
  Future<void> fetchJobTypes() async {
    try {
      _isLoadingJobTypes = true;
      notifyListeners();

      _jobTypes = await _dataService.getJobTypes();
      
    } catch (e) {
      _jobTypes = [];
    } finally {
      _isLoadingJobTypes = false;
      notifyListeners();
    }
  }

  // Fetch Religions
  Future<void> fetchReligions() async {
    try {
      _isLoadingReligions = true;
      notifyListeners();

      _religions = await _dataService.getReligions();
      
    } catch (e) {
      _religions = [];
    } finally {
      _isLoadingReligions = false;
      notifyListeners();
    }
  }

  // Get Education Qualification by ID
  EducationQualification? getEducationQualificationById(String id) {
    try {
      return _educationQualifications.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get Community by ID
  Community? getCommunityById(String id) {
    try {
      return _communities.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get Job Type by ID
  JobType? getJobTypeById(String id) {
    try {
      return _jobTypes.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get Religion by ID
  Religion? getReligionById(String id) {
    try {
      return _religions.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get Sub-Community by ID
  SubCommunity? getSubCommunityById(String communityId, String subCommunityId) {
    try {
      final community = _communities.firstWhere((item) => item.id == communityId);
      return community.subCommunities.firstWhere((item) => item.id == subCommunityId);
    } catch (e) {
      return null;
    }
  }

  // Convert to dropdown options format
  List<Map<String, dynamic>> getEducationQualificationOptions() {
    return _educationQualifications.map((item) => {
      'id': item.id,
      'name': item.name,
    }).toList();
  }

  List<Map<String, dynamic>> getCommunityOptions() {
    return _communities.map((item) => {
      'id': item.id,
      'name': item.name,
    }).toList();
  }

  List<Map<String, dynamic>> getJobTypeOptions() {
    return _jobTypes.map((item) => {
      'id': item.id,
      'name': item.name,
    }).toList();
  }

  List<Map<String, dynamic>> getReligionOptions() {
    return _religions.map((item) => {
      'id': item.id,
      'name': item.name,
    }).toList();
  }

  // Get sub-communities for a specific community
  List<Map<String, dynamic>> getSubCommunityOptions(String communityId) {
    try {
      final community = _communities.firstWhere((item) => item.id == communityId);
      return community.subCommunities.map((item) => {
        'id': item.id,
        'name': item.name,
      }).toList();
    } catch (e) {
      return [];
    }
  }

  // Fetch Countries
  Future<void> fetchCountries() async {
    try {
      _isLoadingCountries = true;
      notifyListeners();

      _countries = await _dataService.getCountries();
      
    } catch (e) {
      _countries = [];
    } finally {
      _isLoadingCountries = false;
      notifyListeners();
    }
  }

  // Check if data is loaded
  bool get isDataLoaded => 
    _educationQualifications.isNotEmpty && 
    _communities.isNotEmpty && 
    _jobTypes.isNotEmpty && 
    _religions.isNotEmpty &&
    _countries.isNotEmpty;

  // Check if any data is loading
  bool get isAnyLoading => 
    _isLoadingEducation || 
    _isLoadingCommunities || 
    _isLoadingJobTypes || 
    _isLoadingReligions ||
    _isLoadingCountries;
}
