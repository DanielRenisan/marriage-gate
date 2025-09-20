class MatchingProfileResponse {
  final MatchingProfileResult result;
  final bool isError;
  final String? error;

  MatchingProfileResponse({
    required this.result,
    required this.isError,
    this.error,
  });

  factory MatchingProfileResponse.fromJson(Map<String, dynamic> json) {
    return MatchingProfileResponse(
      result: MatchingProfileResult.fromJson(json['Result'] ?? {}),
      isError: json['IsError'] ?? false,
      error: json['Error'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Result': result.toJson(),
      'IsError': isError,
      'Error': error,
    };
  }
}

class MatchingProfileResult {
  final List<MatchingProfile> data;
  final int totalCount;
  final int pageNumber;
  final int pageSize;

  MatchingProfileResult({
    required this.data,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
  });

  factory MatchingProfileResult.fromJson(Map<String, dynamic> json) {
    return MatchingProfileResult(
      data: (json['data'] as List<dynamic>?)?.map((item) => MatchingProfile.fromJson(item)).toList() ?? [],
      totalCount: json['totalCount'] ?? 0,
      pageNumber: json['pageNumber'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => item.toJson()).toList(),
      'totalCount': totalCount,
      'pageNumber': pageNumber,
      'pageSize': pageSize,
    };
  }
}

class MatchingProfile {
  final String id;
  final String firstName;
  final String lastName;
  final int gender;
  final String dateOfBirth;
  final int age;
  final String religion;
  final String jobTitle;
  final String imageUrl;
  final LivingAddress livingAddresses;

  MatchingProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dateOfBirth,
    required this.age,
    required this.religion,
    required this.jobTitle,
    required this.imageUrl,
    required this.livingAddresses,
  });

  factory MatchingProfile.fromJson(Map<String, dynamic> json) {
    return MatchingProfile(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      gender: json['gender'] ?? 0,
      dateOfBirth: json['dateOfBirth'] ?? '',
      age: json['age'] ?? 0,
      religion: json['religion'] ?? '',
      jobTitle: json['jobTitle'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      livingAddresses: LivingAddress.fromJson(json['livingAddresses'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'age': age,
      'religion': religion,
      'jobTitle': jobTitle,
      'imageUrl': imageUrl,
      'livingAddresses': livingAddresses.toJson(),
    };
  }

  // Convenience getters for compatibility
  String get fullName => '$firstName $lastName';
  String? get profileImage => imageUrl.isNotEmpty ? imageUrl : null;
  String? get occupation => jobTitle.isNotEmpty ? jobTitle : null;
  String? get city => livingAddresses.city;
  String? get state => livingAddresses.state;
  String? get country => livingAddresses.country;
  String? get address => '${livingAddresses.street}, ${livingAddresses.city}';
}

class LivingAddress {
  final String id;
  final int addressType;
  final int residentStatus;
  final bool isDefault;
  final String number;
  final String street;
  final String city;
  final String state;
  final String zipcode;
  final String country;
  final double latitude;
  final double longitude;

  LivingAddress({
    required this.id,
    required this.addressType,
    required this.residentStatus,
    required this.isDefault,
    required this.number,
    required this.street,
    required this.city,
    required this.state,
    required this.zipcode,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  factory LivingAddress.fromJson(Map<String, dynamic> json) {
    return LivingAddress(
      id: json['id'] ?? '',
      addressType: json['addressType'] ?? 0,
      residentStatus: json['residentStatus'] ?? 0,
      isDefault: json['isDefault'] ?? false,
      number: json['number'] ?? '',
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zipcode: json['zipcode'] ?? '',
      country: json['country'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'addressType': addressType,
      'residentStatus': residentStatus,
      'isDefault': isDefault,
      'number': number,
      'street': street,
      'city': city,
      'state': state,
      'zipcode': zipcode,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
