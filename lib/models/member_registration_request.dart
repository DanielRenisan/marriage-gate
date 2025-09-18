class MemberRegistrationRequest {
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
  final String motherTongue;
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
  final List<ProfileImageRequest> profileImages;
  final List<ProfileAddressRequest> profileAddresses;
  final List<ProfileEducationRequest>? profileEducations;

  MemberRegistrationRequest({
    required this.profileFor,
    this.isActive = true,
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
    required this.motherTongue,
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
      'motherTongue': motherTongue,
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
      'profileImages': profileImages.map((x) => x.toJson()).toList(),
      'profileAddresses': profileAddresses.map((x) => x.toJson()).toList(),
      'profileEducations': profileEducations?.map((x) => x.toJson()).toList(),
    };
  }
}

class ProfileJobRequest {
  final String? title;
  final String? companyName;
  final int sector;
  final String? jobTypeId;
  final ProfileSalaryRequest profileSalary;

  ProfileJobRequest({
    this.title,
    this.companyName,
    required this.sector,
    this.jobTypeId,
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
  final String? currencyCode;
  final bool isVisible;

  ProfileSalaryRequest({
    required this.isAnnual,
    required this.amount,
    this.currencyCode,
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

class ProfileImageRequest {
  final String url;
  final bool isProfile;
  final bool isVisible;

  ProfileImageRequest({
    required this.url,
    required this.isProfile,
    required this.isVisible,
  });

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'isProfile': isProfile,
      'isVisible': isVisible,
    };
  }
}

class ProfileAddressRequest {
  final String? id;
  final String? number;
  final String street;
  final String city;
  final String state;
  final String? zipcode;
  final String country;
  final double latitude;
  final double longitude;
  final int addressType;
  final int? residentStatus;
  final bool isDefault;

  ProfileAddressRequest({
    this.id,
    this.number,
    required this.street,
    required this.city,
    required this.state,
    this.zipcode,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.addressType,
    this.residentStatus,
    required this.isDefault,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'street': street,
      'city': city,
      'state': state,
      'zipcode': zipcode,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'addressType': addressType,
      'residentStatus': residentStatus,
      'isDefault': isDefault,
    };
  }
}

class ProfileEducationRequest {
  final String? qualification;
  final String? institute;
  final int sortNo;
  final String educationQualificationId;

  ProfileEducationRequest({
    this.qualification,
    this.institute,
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

enum AddressType {
  living(0),
  temporary(1),
  birth(3);

  const AddressType(this.value);
  final int value;
}

class MemberRegistrationValidator {
  static String? validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'First name is required';
    }
    if (value.trim().length < 2) {
      return 'First name must be at least 2 characters';
    }
    return null;
  }

  static String? validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Last name is required';
    }
    if (value.trim().length < 2) {
      return 'Last name must be at least 2 characters';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final phoneRegex = RegExp(r'^\d{7,15}$');
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[\s\-\(\)]'), ''))) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? validateAboutMe(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'About me is required';
    }
    if (value.trim().length < 50) {
      return 'About me must be at least 50 characters';
    }
    if (value.trim().length > 500) {
      return 'About me must not exceed 500 characters';
    }
    return null;
  }

  static String? validateDateOfBirth(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Date of birth is required';
    }
    try {
      final date = DateTime.parse(value);
      final now = DateTime.now();
      final age = now.year - date.year;
      if (age < 18) {
        return 'You must be at least 18 years old';
      }
      if (age > 100) {
        return 'Please enter a valid date of birth';
      }
    } catch (e) {
      return 'Please enter a valid date';
    }
    return null;
  }

  static String? validateHeight(double? value) {
    if (value == null || value <= 0) {
      return 'Height is required';
    }
    if (value < 100 || value > 250) {
      return 'Please enter a valid height (100-250 cm)';
    }
    return null;
  }

  static String? validateWeight(double? value) {
    if (value == null || value <= 0) {
      return 'Weight is required';
    }
    if (value < 30 || value > 200) {
      return 'Please enter a valid weight (30-200 kg)';
    }
    return null;
  }

  static String? validateFatherName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Father name is required';
    }
    return null;
  }

  static String? validateMotherName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mother name is required';
    }
    return null;
  }

  static String? validateFatherOccupation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Father occupation is required';
    }
    return null;
  }

  static String? validateMotherOccupation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mother occupation is required';
    }
    return null;
  }

  static String? validateStreet(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Street is required';
    }
    return null;
  }

  static String? validateCity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'City is required';
    }
    return null;
  }

  static String? validateState(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'State/Province is required';
    }
    return null;
  }

  static String? validateCountry(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Country is required';
    }
    return null;
  }

  static String? validateZipCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Zip code is required';
    }
    return null;
  }
}
