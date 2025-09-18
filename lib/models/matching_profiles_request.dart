// Matching Profiles Request Model - Based on Angular curl request
// Matches the exact structure from the working curl request

class MatchingProfilesRequest {
  final String searchText;
  final int minAge;
  final int maxAge;
  final List<String> originCountries;
  final List<String> livingCountries;
  final List<String> foodHabits;
  final List<String> drinkHabits;
  final List<String> smokeHabits;
  final List<String> bodyTypes;
  final List<String> willingToRelocate;
  final List<String> skinComplexions;
  final int minHeight;
  final int maxHeight;
  final int minWeight;
  final int maxWeight;
  final List<String> jobSectors;
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
    this.bodyTypes = const [],
    this.willingToRelocate = const [],
    this.skinComplexions = const [],
    this.minHeight = 100,
    this.maxHeight = 250,
    this.minWeight = 25,
    this.maxWeight = 150,
    this.jobSectors = const [],
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
      'bodyTypes': bodyTypes,
      'willingToRelocate': willingToRelocate,
      'skinComplexions': skinComplexions,
      'minHeight': minHeight,
      'maxHeight': maxHeight,
      'minWeight': minWeight,
      'maxWeight': maxWeight,
      'jobSectors': jobSectors,
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
      foodHabits: List<String>.from(json['foodHabits'] ?? []),
      drinkHabits: List<String>.from(json['drinkHabits'] ?? []),
      smokeHabits: List<String>.from(json['smokeHabits'] ?? []),
      bodyTypes: List<String>.from(json['bodyTypes'] ?? []),
      willingToRelocate: List<String>.from(json['willingToRelocate'] ?? []),
      skinComplexions: List<String>.from(json['skinComplexions'] ?? []),
      minHeight: json['minHeight'] ?? 100,
      maxHeight: json['maxHeight'] ?? 250,
      minWeight: json['minWeight'] ?? 25,
      maxWeight: json['maxWeight'] ?? 150,
      jobSectors: List<String>.from(json['jobSectors'] ?? []),
      salaryFilter: json['salaryFilter'] != null ? SalaryFilter.fromJson(json['salaryFilter']) : null,
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
      bodyTypes: [],
      willingToRelocate: [],
      skinComplexions: [],
      minHeight: 100,
      maxHeight: 250,
      minWeight: 25,
      maxWeight: 150,
      jobSectors: [],
      salaryFilter: null,
    );
  }
}

class SalaryFilter {
  final double? minSalary;
  final double? maxSalary;
  final String? currency;
  final bool? isAnnual;

  SalaryFilter({
    this.minSalary,
    this.maxSalary,
    this.currency,
    this.isAnnual,
  });

  Map<String, dynamic> toJson() {
    return {
      'minSalary': minSalary,
      'maxSalary': maxSalary,
      'currency': currency,
      'isAnnual': isAnnual,
    };
  }

  factory SalaryFilter.fromJson(Map<String, dynamic> json) {
    return SalaryFilter(
      minSalary: json['minSalary']?.toDouble(),
      maxSalary: json['maxSalary']?.toDouble(),
      currency: json['currency'],
      isAnnual: json['isAnnual'],
    );
  }
}
