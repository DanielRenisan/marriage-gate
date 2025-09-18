class UserBasicForm {
  final String firstName;
  final String lastName;
  final int gender;
  final String dateOfBirth;
  final int maritalStatus;
  final double height;
  final double weight;
  final List<String> profileImages;
  final bool isVisible;

  UserBasicForm({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dateOfBirth,
    required this.maritalStatus,
    required this.height,
    required this.weight,
    required this.profileImages,
    this.isVisible = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'maritalStatus': maritalStatus,
      'height': height,
      'weight': weight,
      'profileImages': profileImages,
      'isVisible': isVisible,
    };
  }
}

class UserContactForm {
  final String email;
  final String phoneNumber;
  final String city;
  final String state;
  final String country;
  final String address;

  UserContactForm({
    required this.email,
    required this.phoneNumber,
    required this.city,
    required this.state,
    required this.country,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phoneNumber': phoneNumber,
      'city': city,
      'state': state,
      'country': country,
      'address': address,
    };
  }
}

class PersonalDetails {
  final String aboutMe;
  final String? disability;
  final int motherTongue;
  final int diet;
  final int smoking;
  final int drinking;
  final int bodyType;
  final int? bloodGroup;
  final int complexion;
  final List<int> knownLanguages;
  final int canRelocate;

  PersonalDetails({
    required this.aboutMe,
    this.disability,
    required this.motherTongue,
    required this.diet,
    required this.smoking,
    required this.drinking,
    required this.bodyType,
    this.bloodGroup,
    required this.complexion,
    required this.knownLanguages,
    required this.canRelocate,
  });

  Map<String, dynamic> toJson() {
    return {
      'aboutMe': aboutMe,
      'disability': disability,
      'motherTongue': motherTongue,
      'diet': diet,
      'smoking': smoking,
      'drinking': drinking,
      'bodyType': bodyType,
      'bloodGroup': bloodGroup,
      'complexion': complexion,
      'knownLanguages': knownLanguages,
      'canRelocate': canRelocate,
    };
  }
}

class UserFamilyInfo {
  final String fatherName;
  final String motherName;
  final String fatherOccupation;
  final String motherOccupation;
  final int siblings;
  final int familyType;
  final String originCountry;

  UserFamilyInfo({
    required this.fatherName,
    required this.motherName,
    required this.fatherOccupation,
    required this.motherOccupation,
    required this.siblings,
    required this.familyType,
    required this.originCountry,
  });

  Map<String, dynamic> toJson() {
    return {
      'fatherName': fatherName,
      'motherName': motherName,
      'fatherOccupation': fatherOccupation,
      'motherOccupation': motherOccupation,
      'siblings': siblings,
      'familyType': familyType,
      'originCountry': originCountry,
    };
  }
}

class UserReligiousInfo {
  final int religion;
  final int? communityCast;
  final String? timeOfBirth;
  final bool isVisible;
  final String? subCast;
  final int? starNakshathra;
  final int? raasi;
  final String street;
  final String city;
  final String stateProvince;
  final String country;
  final double latitude;
  final double longitude;

  UserReligiousInfo({
    required this.religion,
    this.communityCast,
    this.timeOfBirth,
    this.isVisible = true,
    this.subCast,
    this.starNakshathra,
    this.raasi,
    required this.street,
    required this.city,
    required this.stateProvince,
    required this.country,
    this.latitude = 0,
    this.longitude = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'religion': religion,
      'communityCast': communityCast,
      'timeOfBirth': timeOfBirth,
      'isVisible': isVisible,
      'subCast': subCast,
      'starNakshathra': starNakshathra,
      'raasi': raasi,
      'street': street,
      'city': city,
      'stateProvince': stateProvince,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class UserEducationDetails {
  final int? highestEducation;
  final String qualification;
  final String institute;
  final String jobTitle;
  final String companyName;
  final int? sector;
  final String? jobType;
  final double? salaryDetails;
  final String? currency;
  final bool? isYearly;
  final bool isVisible;

  UserEducationDetails({
    this.highestEducation,
    required this.qualification,
    required this.institute,
    required this.jobTitle,
    required this.companyName,
    this.sector,
    this.jobType,
    this.salaryDetails,
    this.currency,
    this.isYearly,
    this.isVisible = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'highestEducation': highestEducation,
      'qualification': qualification,
      'institute': institute,
      'jobTitle': jobTitle,
      'companyName': companyName,
      'sector': sector,
      'jobType': jobType,
      'salaryDetails': salaryDetails,
      'currency': currency,
      'isYearly': isYearly,
      'isVisible': isVisible,
    };
  }
}

class MatchPreferences {
  final int profileFor;
  final int gender;
  final int? ageFrom;
  final int? ageTo;
  final int? heightFrom;
  final int? heightTo;
  final int? maritalStatus;
  final int? religion;
  final int? education;
  final int? occupation;
  final int? income;
  final int? location;

  MatchPreferences({
    required this.profileFor,
    required this.gender,
    this.ageFrom,
    this.ageTo,
    this.heightFrom,
    this.heightTo,
    this.maritalStatus,
    this.religion,
    this.education,
    this.occupation,
    this.income,
    this.location,
  });

  Map<String, dynamic> toJson() {
    return {
      'profileFor': profileFor,
      'gender': gender,
      'ageFrom': ageFrom,
      'ageTo': ageTo,
      'heightFrom': heightFrom,
      'heightTo': heightTo,
      'maritalStatus': maritalStatus,
      'religion': religion,
      'education': education,
      'occupation': occupation,
      'income': income,
      'location': location,
    };
  }
}

class CompleteRegistrationData {
  final UserBasicForm basicInfo;
  final UserContactForm contactInfo;
  final PersonalDetails personalDetails;
  final UserFamilyInfo familyInfo;
  final UserReligiousInfo religiousInfo;
  final UserEducationDetails educationDetails;
  final MatchPreferences matchPreferences;

  CompleteRegistrationData({
    required this.basicInfo,
    required this.contactInfo,
    required this.personalDetails,
    required this.familyInfo,
    required this.religiousInfo,
    required this.educationDetails,
    required this.matchPreferences,
  });

  Map<String, dynamic> toJson() {
    return {
      'basicInfo': basicInfo.toJson(),
      'contactInfo': contactInfo.toJson(),
      'personalDetails': personalDetails.toJson(),
      'familyInfo': familyInfo.toJson(),
      'religiousInfo': religiousInfo.toJson(),
      'educationDetails': educationDetails.toJson(),
      'matchPreferences': matchPreferences.toJson(),
    };
  }
}
