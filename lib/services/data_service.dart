import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:matrimony_flutter/models/education_qualification.dart';
import 'package:matrimony_flutter/models/community.dart';
import 'package:matrimony_flutter/models/job_type.dart';
import 'package:matrimony_flutter/models/religion.dart';
import 'package:matrimony_flutter/models/member.dart' as member_models;
import 'package:matrimony_flutter/utils/constants.dart';

class DataService {
  final String _baseUrl = ApiEndpoints.baseUrl;

  // Get Education Qualifications
  Future<List<EducationQualification>> getEducationQualifications() async {
    try {
      final url = Uri.parse('$_baseUrl${ApiEndpoints.getEducationQualifications}');
      
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': '*',
        },
      );


      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Result'] != null) {
          final response = EducationQualificationResponse.fromJson(data['Result']);
          return response.data.where((item) => item.isActive).toList();
        } else {
          throw Exception('Invalid response format: Result not found');
        }
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['Message'] ?? 'Failed to fetch education qualifications (Status: ${response.statusCode})';
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Invalid response format from server');
      }
      throw Exception('Error fetching education qualifications: $e');
    }
  }

  // Get Communities
  Future<List<Community>> getCommunities() async {
    try {
      final url = Uri.parse('$_baseUrl${ApiEndpoints.getCommunities}');
      
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': '*',
        },
      );


      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Result'] != null) {
          final response = CommunityResponse.fromJson(data['Result']);
          return response.data.where((item) => item.isActive).toList();
        } else {
          throw Exception('Invalid response format: Result not found');
        }
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['Message'] ?? 'Failed to fetch communities (Status: ${response.statusCode})';
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Invalid response format from server');
      }
      throw Exception('Error fetching communities: $e');
    }
  }

  // Get Job Types
  Future<List<JobType>> getJobTypes() async {
    try {
      final url = Uri.parse('$_baseUrl${ApiEndpoints.getJobTypes}');
      
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': '*',
        },
      );


      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Result'] != null) {
          final response = JobTypeResponse.fromJson(data['Result']);
          return response.data.where((item) => item.isActive).toList();
        } else {
          throw Exception('Invalid response format: Result not found');
        }
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['Message'] ?? 'Failed to fetch job types (Status: ${response.statusCode})';
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Invalid response format from server');
      }
      throw Exception('Error fetching job types: $e');
    }
  }

  // Get Religions
  Future<List<Religion>> getReligions() async {
    try {
      final url = Uri.parse('$_baseUrl${ApiEndpoints.getReligions}');
      
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': '*',
        },
      );


      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Result'] != null) {
          final response = ReligionResponse.fromJson(data['Result']);
          return response.data.where((item) => item.isActive).toList();
        } else {
          throw Exception('Invalid response format: Result not found');
        }
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['Message'] ?? 'Failed to fetch religions (Status: ${response.statusCode})';
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Invalid response format from server');
      }
      throw Exception('Error fetching religions: $e');
    }
  }

  // Get Countries
  Future<List<member_models.Country>> getCountries() async {
    try {
      final url = Uri.parse('$_baseUrl${ApiEndpoints.getCountryCodes}');
      
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': '*',
        },
      );


      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Result'] != null) {
          return (data['Result'] as List)
              .map((item) => member_models.Country.fromJson(item))
              .toList();
        } else {
          throw Exception('Invalid response format: Result not found');
        }
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['Message'] ?? 'Failed to fetch countries (Status: ${response.statusCode})';
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Invalid response format from server');
      }
      throw Exception('Error fetching countries: $e');
    }
  }
}
