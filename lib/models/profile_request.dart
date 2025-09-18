class ProfileRequest {
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
  final String? knownLanguages;
  final int bloodGroup;
  final int skinComplexion;
  final bool isVisibleCommunity;
  final String userId;
  final String religionId;
  final String? communityId;
  final ProfileJobRequest? profileJob;
  final ProfileLookingForRequest profileLookingFor;
  final ProfileFamilyRequest profileFamily;
  final ProfileAstrologyRequest profileAstrology;
  final List<dynamic> profileImages;
  final List<ProfileAddressRequest> profileAddresses;
  final List<ProfileEducationRequest>? profileEducations;

  ProfileRequest({
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
    this.knownLanguages,
    required this.bloodGroup,
    required this.skinComplexion,
    required this.isVisibleCommunity,
    required this.userId,
    required this.religionId,
    this.communityId,
    this.profileJob,
    required this.profileLookingFor,
    required this.profileFamily,
    required this.profileAstrology,
    required this.profileImages,
    required this.profileAddresses,
    this.profileEducations,
  });

  Map<String, dynamic> toJson() {
    return {
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
      'knownLanguages': knownLanguages,
      'bloodGroup': bloodGroup,
      'skinComplexion': skinComplexion,
      'isVisibleCommunity': isVisibleCommunity,
      'userId': userId,
      'religionId': religionId,
      'communityId': communityId,
      'profileJob': profileJob?.toJson(),
      'profileLookingFor': profileLookingFor.toJson(),
      'profileFamily': profileFamily.toJson(),
      'profileAstrology': profileAstrology.toJson(),
      'profileImages': profileImages,
      'profileAddresses': profileAddresses.map((x) => x.toJson()).toList(),
      'profileEducations': profileEducations?.map((x) => x.toJson()).toList(),
    };
  }
}

class ProfileJobRequest {
  final String title;
  final String companyName;
  final int sector;
  final String jobTypeId;
  final ProfileSalaryRequest profileSalary;

  ProfileJobRequest({
    required this.title,
    required this.companyName,
    required this.sector,
    required this.jobTypeId,
    required this.profileSalary,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'companyName': companyName,
      'sector': sector,
      'jobTypeId': jobTypeId,
      'profileSalary': profileSalary.toJson(),
    };
  }
}

class ProfileSalaryRequest {
  final bool isAnnual;
  final double amount;
  final String currencyCode;
  final bool isVisible;

  ProfileSalaryRequest({
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
}

class ProfileLookingForRequest {
  final int gender;
  final int minAge;
  final int maxAge;
  final String country;

  ProfileLookingForRequest({
    required this.gender,
    required this.minAge,
    required this.maxAge,
    required this.country,
  });

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'minAge': minAge,
      'maxAge': maxAge,
      'country': country,
    };
  }
}

class ProfileFamilyRequest {
  final String fatherName;
  final String fatherOccupation;
  final String motherName;
  final String motherOccupation;
  final int numberOfSiblings;
  final int familyType;

  ProfileFamilyRequest({
    required this.fatherName,
    required this.fatherOccupation,
    required this.motherName,
    required this.motherOccupation,
    required this.numberOfSiblings,
    required this.familyType,
  });

  Map<String, dynamic> toJson() {
    return {
      'fatherName': fatherName,
      'fatherOccupation': fatherOccupation,
      'motherName': motherName,
      'motherOccupation': motherOccupation,
      'numberOfSiblings': numberOfSiblings,
      'familyType': familyType,
    };
  }
}

class ProfileAstrologyRequest {
  final int nakshathiram;
  final int raasi;
  final String? timeOfBirth;

  ProfileAstrologyRequest({
    required this.nakshathiram,
    required this.raasi,
    this.timeOfBirth,
  });

  Map<String, dynamic> toJson() {
    return {
      'nakshathiram': nakshathiram,
      'raasi': raasi,
      'timeOfBirth': timeOfBirth,
    };
  }
}

class ProfileAddressRequest {
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

  ProfileAddressRequest({
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

class ProfileEducationRequest {
  final String qualification;
  final String institute;
  final int sortNo;
  final String educationQualificationId;

  ProfileEducationRequest({
    required this.qualification,
    required this.institute,
    required this.sortNo,
    required this.educationQualificationId,
  });

  Map<String, dynamic> toJson() {
    return {
      'qualification': qualification,
      'institute': institute,
      'sortNo': sortNo,
      'educationQualificationId': educationQualificationId,
    };
  }
}