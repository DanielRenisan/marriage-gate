// Matching Profiles Request Model - Based on Angular curl request
// Matches the exact structure from the working curl request

import 'salary_filter.dart';

class MatchingProfilesRequest {
  final String searchText;
  final int minAge;
  final int maxAge;
  final List<String> originCountries;
  final List<String> livingCountries;
  final List<int> foodHabits;
  final List<int> drinkHabits;
  final List<int> smokeHabits;
  final List<int> marriageStatus;
  final List<int> bodyTypes;
  final List<int> willingToRelocate;
  final List<int> skinComplexions;
  final double minHeight;
  final double maxHeight;
  final double minWeight;
  final double maxWeight;
  final List<String> knownLanguages;
  final List<String> religionIds;
  final List<String> communityIds;
  final List<int> jobSectors;
  final List<String> jobTypeIds;
  final List<String> educationQualificationIds;
  final List<String> nakshathiram;
  final List<String> raasi;
  final SalaryFilter? salaryFilter;

  MatchingProfilesRequest({
    this.searchText = "",
    this.minAge = 18,
    this.maxAge = 35,
    this.originCountries = const ["Sri Lanka"],
    this.livingCountries = const ["Sri Lanka"],
    this.foodHabits = const [],
    this.drinkHabits = const [],
    this.smokeHabits = const [],
    this.marriageStatus = const [],
    this.bodyTypes = const [],
    this.willingToRelocate = const [],
    this.skinComplexions = const [],
    this.minHeight = 100.0,
    this.maxHeight = 250.0,
    this.minWeight = 25.0,
    this.maxWeight = 150.0,
    this.knownLanguages = const [],
    this.religionIds = const [],
    this.communityIds = const [],
    this.jobSectors = const [],
    this.jobTypeIds = const [],
    this.educationQualificationIds = const [],
    this.nakshathiram = const [],
    this.raasi = const [],
    this.salaryFilter,
  });

  Map<String, dynamic> toJson() {
    return {
      'searchText': searchText,
      'minAge': minAge,
      'maxAge': maxAge,
      'OriginCountries': originCountries,
      'LivingCountries': livingCountries,
      'foodHabits': foodHabits,
      'drinkHabits': drinkHabits,
      'smokeHabits': smokeHabits,
      'marriageStatus': marriageStatus,
      'bodyTypes': bodyTypes,
      'willingToRelocate': willingToRelocate,
      'skinComplexions': skinComplexions,
      'minHeight': minHeight,
      'maxHeight': maxHeight,
      'minWeight': minWeight,
      'maxWeight': maxWeight,
      'knownLanguages': knownLanguages,
      'religionIds': religionIds,
      'communityIds': communityIds,
      'jobSectors': jobSectors,
      'jobTypeIds': jobTypeIds,
      'educationQualificationIds': educationQualificationIds,
      'nakshathiram': nakshathiram,
      'raasi': raasi,
      'salaryFilter': salaryFilter?.toJson(),
    };
  }

  factory MatchingProfilesRequest.fromJson(Map<String, dynamic> json) {
    return MatchingProfilesRequest(
      searchText: json['searchText'] ?? "",
      minAge: json['minAge'] ?? 18,
      maxAge: json['maxAge'] ?? 35,
      originCountries: List<String>.from(json['OriginCountries'] ?? ["Sri Lanka"]),
      livingCountries: List<String>.from(json['LivingCountries'] ?? ["Sri Lanka"]),
      foodHabits: List<int>.from(json['foodHabits'] ?? []),
      drinkHabits: List<int>.from(json['drinkHabits'] ?? []),
      smokeHabits: List<int>.from(json['smokeHabits'] ?? []),
      marriageStatus: List<int>.from(json['marriageStatus'] ?? []),
      bodyTypes: List<int>.from(json['bodyTypes'] ?? []),
      willingToRelocate: List<int>.from(json['willingToRelocate'] ?? []),
      skinComplexions: List<int>.from(json['skinComplexions'] ?? []),
      minHeight: (json['minHeight'] ?? 100.0).toDouble(),
      maxHeight: (json['maxHeight'] ?? 250.0).toDouble(),
      minWeight: (json['minWeight'] ?? 25.0).toDouble(),
      maxWeight: (json['maxWeight'] ?? 150.0).toDouble(),
      knownLanguages: List<String>.from(json['knownLanguages'] ?? []),
      religionIds: List<String>.from(json['religionIds'] ?? []),
      communityIds: List<String>.from(json['communityIds'] ?? []),
      jobSectors: List<int>.from(json['jobSectors'] ?? []),
      jobTypeIds: List<String>.from(json['jobTypeIds'] ?? []),
      educationQualificationIds: List<String>.from(json['educationQualificationIds'] ?? []),
      nakshathiram: List<String>.from(json['nakshathiram'] ?? []),
      raasi: List<String>.from(json['raasi'] ?? []),
    );
  }

  // Create default request for initial matching profiles load
  factory MatchingProfilesRequest.defaultRequest() {
    return MatchingProfilesRequest(
      searchText: "",
      minAge: 18,
      maxAge: 35,
      originCountries: ["Sri Lanka"],
      livingCountries: ["Sri Lanka"],
      foodHabits: [],
      drinkHabits: [],
      smokeHabits: [],
      marriageStatus: [],
      bodyTypes: [],
      willingToRelocate: [],
      skinComplexions: [],
      minHeight: 100.0,
      maxHeight: 250.0,
      minWeight: 25.0,
      maxWeight: 150.0,
      knownLanguages: [],
      religionIds: [],
      communityIds: [],
      jobSectors: [],
      jobTypeIds: [],
      educationQualificationIds: [],
      nakshathiram: [],
      raasi: [],
      salaryFilter: null,
    );
  }
}
