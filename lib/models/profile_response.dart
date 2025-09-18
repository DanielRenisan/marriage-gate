class ProfileResponse {
  final ProfileResult? result;
  final bool isError;
  final String? error;

  ProfileResponse({
    this.result,
    required this.isError,
    this.error,
  });

  Map<String, dynamic> toJson() {
    return {
      'Result': result?.toJson(),
      'IsError': isError,
      'Error': error,
    };
  }

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      result: json['Result'] != null ? ProfileResult.fromJson(json['Result']) : null,
      isError: json['IsError'] ?? false,
      error: json['Error'],
    );
  }
}

class ProfileResult {
  final String id;
  final int profileFor;
  final bool isActive;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String phoneCode;
  final String aboutMe;
  final int gender;
  final String dateOfBirth;
  final int foodHabit;
  final int drinksHabit;
  final int smokeHabit;
  final int marriageStatus;
  final int bodyType;
  final int willingToRelocate;
  final double height;
  final double weight;
  final String disability;
  final String originCountry;
  final String? motherTongue;
  final String? knownLanguages;
  final int bloodGroup;
  final int skinComplexion;
  final bool isVisibleCommunity;
  final String userId;
  final String religionId;
  final String? communityId;
  final String? subCommunityId;
  final ProfileJobResponse? profileJob;
  final ProfileLookingForResponse? profileLookingFor;
  final ProfileFamilyResponse? profileFamily;
  final ProfileAstrologyResponse? profileAstrology;
  final List<ProfileImageResponse> profileImages;
  final List<ProfileAddressResponse> profileAddresses;
  final List<ProfileEducationResponse> profileEducations;

  ProfileResult({
    required this.id,
    required this.profileFor,
    required this.isActive,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.phoneCode,
    required this.aboutMe,
    required this.gender,
    required this.dateOfBirth,
    required this.foodHabit,
    required this.drinksHabit,
    required this.smokeHabit,
    required this.marriageStatus,
    required this.bodyType,
    required this.willingToRelocate,
    required this.height,
    required this.weight,
    required this.disability,
    required this.originCountry,
    this.motherTongue,
    this.knownLanguages,
    required this.bloodGroup,
    required this.skinComplexion,
    required this.isVisibleCommunity,
    required this.userId,
    required this.religionId,
    this.communityId,
    this.subCommunityId,
    this.profileJob,
    this.profileLookingFor,
    this.profileFamily,
    this.profileAstrology,
    required this.profileImages,
    required this.profileAddresses,
    required this.profileEducations,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profileFor': profileFor,
      'isActive': isActive,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'phoneCode': phoneCode,
      'aboutMe': aboutMe,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'foodHabit': foodHabit,
      'drinksHabit': drinksHabit,
      'smokeHabit': smokeHabit,
      'marriageStatus': marriageStatus,
      'bodyType': bodyType,
      'willingToRelocate': willingToRelocate,
      'height': height,
      'weight': weight,
      'disability': disability,
      'originCountry': originCountry,
      'motherTongue': motherTongue,
      'knownLanguages': knownLanguages,
      'bloodGroup': bloodGroup,
      'skinComplexion': skinComplexion,
      'isVisibleCommunity': isVisibleCommunity,
      'userId': userId,
      'religionId': religionId,
      'communityId': communityId,
      'subCommunityId': subCommunityId,
      'profileJob': profileJob?.toJson(),
      'profileLookingFor': profileLookingFor?.toJson(),
      'profileFamily': profileFamily?.toJson(),
      'profileAstrology': profileAstrology?.toJson(),
      'profileImages': profileImages.map((x) => x.toJson()).toList(),
      'profileAddresses': profileAddresses.map((x) => x.toJson()).toList(),
      'profileEducations': profileEducations.map((x) => x.toJson()).toList(),
    };
  }

  factory ProfileResult.fromJson(Map<String, dynamic> json) {
    return ProfileResult(
      id: json['id']?.toString() ?? '',
      profileFor: json['profileFor'] ?? 0,
      isActive: json['isActive'] ?? false,
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      phoneCode: json['phoneCode']?.toString() ?? '',
      aboutMe: json['aboutMe']?.toString() ?? '',
      gender: json['gender'] ?? 0,
      dateOfBirth: json['dateOfBirth']?.toString() ?? '',
      foodHabit: json['foodHabit'] ?? 0,
      drinksHabit: json['drinksHabit'] ?? 0,
      smokeHabit: json['smokeHabit'] ?? 0,
      marriageStatus: json['marriageStatus'] ?? 0,
      bodyType: json['bodyType'] ?? 0,
      willingToRelocate: json['willingToRelocate'] ?? 0,
      height: (json['height'] ?? 0).toDouble(),
      weight: (json['weight'] ?? 0).toDouble(),
      disability: json['disability']?.toString() ?? '',
      originCountry: json['originCountry']?.toString() ?? '',
      motherTongue: json['motherTongue']?.toString(),
      knownLanguages: json['knownLanguages']?.toString(),
      bloodGroup: json['bloodGroup'] ?? 0,
      skinComplexion: json['skinComplexion'] ?? 0,
      isVisibleCommunity: json['isVisibleCommunity'] ?? false,
      userId: json['userId']?.toString() ?? '',
      religionId: json['religionId']?.toString() ?? '',
      communityId: json['communityId']?.toString(),
      subCommunityId: json['subCommunityId']?.toString(),
      profileJob: json['profileJob'] != null ? ProfileJobResponse.fromJson(json['profileJob'] as Map<String, dynamic>) : null,
      profileLookingFor: json['profileLookingFor'] != null ? ProfileLookingForResponse.fromJson(json['profileLookingFor'] as Map<String, dynamic>) : null,
      profileFamily: json['profileFamily'] != null ? ProfileFamilyResponse.fromJson(json['profileFamily'] as Map<String, dynamic>) : null,
      profileAstrology: json['profileAstrology'] != null ? ProfileAstrologyResponse.fromJson(json['profileAstrology'] as Map<String, dynamic>) : null,
      profileImages: (json['profileImages'] as List<dynamic>? ?? []).map((x) => ProfileImageResponse.fromJson(x as Map<String, dynamic>)).toList(),
      profileAddresses: (json['profileAddresses'] as List<dynamic>? ?? []).map((x) => ProfileAddressResponse.fromJson(x as Map<String, dynamic>)).toList(),
      profileEducations: (json['profileEducations'] as List<dynamic>? ?? []).map((x) => ProfileEducationResponse.fromJson(x as Map<String, dynamic>)).toList(),
    );
  }
}

class ProfileJobResponse {
  final String id;
  final String title;
  final String companyName;
  final int sector;
  final String jobTypeId;
  final ProfileSalaryResponse profileSalary;

  ProfileJobResponse({
    required this.id,
    required this.title,
    required this.companyName,
    required this.sector,
    required this.jobTypeId,
    required this.profileSalary,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'companyName': companyName,
      'sector': sector,
      'jobTypeId': jobTypeId,
      'profileSalary': profileSalary.toJson(),
    };
  }

  factory ProfileJobResponse.fromJson(Map<String, dynamic> json) {
    return ProfileJobResponse(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      companyName: json['companyName']?.toString() ?? '',
      sector: json['sector'] ?? 0,
      jobTypeId: json['jobTypeId']?.toString() ?? '',
      profileSalary: ProfileSalaryResponse.fromJson(json['profileSalary'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class ProfileSalaryResponse {
  final bool isAnnual;
  final double amount;
  final String currencyCode;
  final bool isVisible;

  ProfileSalaryResponse({
    required this.isAnnual,
    required this.amount,
    required this.currencyCode,
    required this.isVisible,
  });

  Map<String, dynamic> toJson() {
    return {
      'isAnnual': isAnnual,
      'amount': amount,
      'currencyCode': currencyCode,
      'isVisible': isVisible,
    };
  }

  factory ProfileSalaryResponse.fromJson(Map<String, dynamic> json) {
    return ProfileSalaryResponse(
      isAnnual: json['isAnnual'] ?? false,
      amount: (json['amount'] ?? 0).toDouble(),
      currencyCode: json['currencyCode']?.toString() ?? '',
      isVisible: json['isVisible'] ?? false,
    );
  }
}

class ProfileLookingForResponse {
  final String id;
  final int gender;
  final int minAge;
  final int maxAge;
  final String country;

  ProfileLookingForResponse({
    required this.id,
    required this.gender,
    required this.minAge,
    required this.maxAge,
    required this.country,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gender': gender,
      'minAge': minAge,
      'maxAge': maxAge,
      'country': country,
    };
  }

  factory ProfileLookingForResponse.fromJson(Map<String, dynamic> json) {
    return ProfileLookingForResponse(
      id: json['id']?.toString() ?? '',
      gender: json['gender'] ?? 0,
      minAge: json['minAge'] ?? 0,
      maxAge: json['maxAge'] ?? 0,
      country: json['country']?.toString() ?? '',
    );
  }
}

class ProfileFamilyResponse {
  final String id;
  final String fatherName;
  final String fatherOccupation;
  final String motherName;
  final String motherOccupation;
  final int numberOfSiblings;
  final int familyType;

  ProfileFamilyResponse({
    required this.id,
    required this.fatherName,
    required this.fatherOccupation,
    required this.motherName,
    required this.motherOccupation,
    required this.numberOfSiblings,
    required this.familyType,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fatherName': fatherName,
      'fatherOccupation': fatherOccupation,
      'motherName': motherName,
      'motherOccupation': motherOccupation,
      'numberOfSiblings': numberOfSiblings,
      'familyType': familyType,
    };
  }

  factory ProfileFamilyResponse.fromJson(Map<String, dynamic> json) {
    return ProfileFamilyResponse(
      id: json['id']?.toString() ?? '',
      fatherName: json['fatherName']?.toString() ?? '',
      fatherOccupation: json['fatherOccupation']?.toString() ?? '',
      motherName: json['motherName']?.toString() ?? '',
      motherOccupation: json['motherOccupation']?.toString() ?? '',
      numberOfSiblings: json['numberOfSiblings'] ?? 0,
      familyType: json['familyType'] ?? 0,
    );
  }
}

class ProfileAstrologyResponse {
  final String id;
  final int nakshathiram;
  final int raasi;
  final String? timeOfBirth;

  ProfileAstrologyResponse({
    required this.id,
    required this.nakshathiram,
    required this.raasi,
    this.timeOfBirth,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nakshathiram': nakshathiram,
      'raasi': raasi,
      'timeOfBirth': timeOfBirth,
    };
  }

  factory ProfileAstrologyResponse.fromJson(Map<String, dynamic> json) {
    return ProfileAstrologyResponse(
      id: json['id']?.toString() ?? '',
      nakshathiram: json['nakshathiram'] ?? 0,
      raasi: json['raasi'] ?? 0,
      timeOfBirth: json['timeOfBirth']?.toString(),
    );
  }
}

class ProfileImageResponse {
  final String id;
  final String url;
  final bool isProfile;
  final bool isVisible;

  ProfileImageResponse({
    required this.id,
    required this.url,
    required this.isProfile,
    required this.isVisible,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'isProfile': isProfile,
      'isVisible': isVisible,
    };
  }

  factory ProfileImageResponse.fromJson(Map<String, dynamic> json) {
    return ProfileImageResponse(
      id: json['id']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      isProfile: json['isProfile'] ?? false,
      isVisible: json['isVisible'] ?? false,
    );
  }
}

class ProfileAddressResponse {
  final String id;
  final int addressType;
  final int? residentStatus;
  final bool isDefault;
  final String? number;
  final String street;
  final String city;
  final String state;
  final String? zipcode;
  final String country;
  final double latitude;
  final double longitude;

  ProfileAddressResponse({
    required this.id,
    required this.addressType,
    this.residentStatus,
    required this.isDefault,
    this.number,
    required this.street,
    required this.city,
    required this.state,
    this.zipcode,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

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

  factory ProfileAddressResponse.fromJson(Map<String, dynamic> json) {
    return ProfileAddressResponse(
      id: json['id']?.toString() ?? '',
      addressType: json['addressType'] ?? 0,
      residentStatus: json['residentStatus'],
      isDefault: json['isDefault'] ?? false,
      number: json['number']?.toString(),
      street: json['street']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      zipcode: json['zipcode']?.toString(),
      country: json['country']?.toString() ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
    );
  }
}

class ProfileEducationResponse {
  final String id;
  final String qualification;
  final String institute;
  final int sortNo;
  final String educationQualificationId;

  ProfileEducationResponse({
    required this.id,
    required this.qualification,
    required this.institute,
    required this.sortNo,
    required this.educationQualificationId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'qualification': qualification,
      'institute': institute,
      'sortNo': sortNo,
      'educationQualificationId': educationQualificationId,
    };
  }

  factory ProfileEducationResponse.fromJson(Map<String, dynamic> json) {
    return ProfileEducationResponse(
      id: json['id']?.toString() ?? '',
      qualification: json['qualification']?.toString() ?? '',
      institute: json['institute']?.toString() ?? '',
      sortNo: json['sortNo'] ?? 0,
      educationQualificationId: json['educationQualificationId']?.toString() ?? '',
    );
  }
}
