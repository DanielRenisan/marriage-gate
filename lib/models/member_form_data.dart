// Member Form Data Models - Matches Angular Form Structure
// Based on Angular form components and interfaces

import 'member_registration_request.dart';

// Match Preferences - Looking For Form
class MatchPreferences {
  final int profileFor;
  final int gender;
  final int minAge;
  final int maxAge;
  final String country;

  MatchPreferences({
    required this.profileFor,
    required this.gender,
    required this.minAge,
    required this.maxAge,
    required this.country,
  });

  Map<String, dynamic> toJson() {
    return {
      'profileFor': profileFor,
      'gender': gender,
      'minAge': minAge,
      'maxAge': maxAge,
      'country': country,
    };
  }
}

// User Basic Form - Member Profile Form
class UserBasicForm {
  final String firstName;
  final String lastName;
  final int gender;
  final String dateOfBirth;
  final int maritalStatus;
  final double height;
  final double weight;
  final List<ProfileImageData> profilesImg;

  UserBasicForm({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dateOfBirth,
    required this.maritalStatus,
    required this.height,
    required this.weight,
    required this.profilesImg,
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
      'profilesImg': profilesImg.map((x) => x.toJson()).toList(),
    };
  }
}

// Profile Image Data
class ProfileImageData {
  final String url;
  final bool isProfile;
  final bool isVisible;

  ProfileImageData({
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

// User Contact Form - Contact Info Form
class UserContactForm {
  final BasicDetails basicDetails;
  final List<AddressData> address;

  UserContactForm({
    required this.basicDetails,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'basicDetails': basicDetails.toJson(),
      'address': address.map((x) => x.toJson()).toList(),
    };
  }
}

// Basic Details
class BasicDetails {
  final String email;
  final String phoneNumber;
  final String phoneCode;

  BasicDetails({
    required this.email,
    required this.phoneNumber,
    required this.phoneCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phoneNumber': phoneNumber,
      'phoneCode': phoneCode,
    };
  }
}

// Address Data
class AddressData {
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

  AddressData({
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

// Personal Details - Personal Details Form
class PersonalDetails {
  final String aboutMe;
  final String disability;
  final int motherTongue;
  final int diet;
  final int smoking;
  final int drinking;
  final String languages; // Comma-separated string
  final int bodyType;
  final int canReLocated; // 1: Yes, 2: No, 3: Maybe
  final int bloodGroup;
  final int complexion;

  PersonalDetails({
    required this.aboutMe,
    required this.disability,
    required this.motherTongue,
    required this.diet,
    required this.smoking,
    required this.drinking,
    required this.languages,
    required this.bodyType,
    required this.canReLocated,
    required this.bloodGroup,
    required this.complexion,
  });

  Map<String, dynamic> toJson() {
    return {
      'aboutMe': aboutMe,
      'disability': disability,
      'motherTongue': motherTongue,
      'diet': diet,
      'smoking': smoking,
      'drinking': drinking,
      'languages': languages,
      'bodyType': bodyType,
      'canReLocated': canReLocated,
      'bloodGroup': bloodGroup,
      'complexion': complexion,
    };
  }
}

// User Family Info - Family Information Form
class UserFamilyInfo {
  final String fatherName;
  final String motherName;
  final String fatherOccupation;
  final String matherOccupation; // Note: Angular typo
  final int siblings;
  final int familyType;
  final String originCountry;

  UserFamilyInfo({
    required this.fatherName,
    required this.motherName,
    required this.fatherOccupation,
    required this.matherOccupation,
    required this.siblings,
    required this.familyType,
    required this.originCountry,
  });

  Map<String, dynamic> toJson() {
    return {
      'fatherName': fatherName,
      'motherName': motherName,
      'fatherOccupation': fatherOccupation,
      'matherOccupation': matherOccupation,
      'siblings': siblings,
      'familyType': familyType,
      'originCountry': originCountry,
    };
  }
}

// User Religious Info - Religious Background Form
class UserReligiousInfo {
  final String religion;
  final String communityCast;
  final String? timeOfBirth;
  final bool isVisible;
  final int starNakshathra;
  final int raasi;
  final int chevvaiDosham;
  final int horoscopeMatching;
  final AddressData address;

  UserReligiousInfo({
    required this.religion,
    required this.communityCast,
    this.timeOfBirth,
    required this.isVisible,
    required this.starNakshathra,
    required this.raasi,
    required this.chevvaiDosham,
    required this.horoscopeMatching,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'religion': religion,
      'communityCast': communityCast,
      'timeOfBirth': timeOfBirth,
      'isVisible': isVisible,
      'starNakshathra': starNakshathra,
      'raasi': raasi,
      'chevvaiDosham': chevvaiDosham,
      'horoscopeMatching': horoscopeMatching,
      'address': address.toJson(),
    };
  }
}

// User Education Details - Education Details Form
class UserEducationDetails {
  final String? highestEducation;
  final String? qualification;
  final String? institute;
  final String? jobTitle;
  final String? companyName;
  final int? sector;
  final String? jobType;
  final double? salaryDetails;
  final String? currency;
  final bool? isYearly;
  final bool? isVisible;

  UserEducationDetails({
    this.highestEducation,
    this.qualification,
    this.institute,
    this.jobTitle,
    this.companyName,
    this.sector,
    this.jobType,
    this.salaryDetails,
    this.currency,
    this.isYearly,
    this.isVisible,
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

// Form Builder Helper Class
class MemberFormBuilder {
  static MemberRegistrationRequest buildRegistrationRequest({
    required MatchPreferences matchingInfo,
    required UserBasicForm userBasicDetails,
    required UserContactForm userContactDetails,
    required PersonalDetails userPersonalDetails,
    required UserFamilyInfo userFamilyDetails,
    required UserReligiousInfo userReligiousDetails,
    required UserEducationDetails userEducationDetails,
    required String userId,
  }) {
    // Build profile job if sector is provided
    ProfileJobRequest? profileJob;
    if (userEducationDetails.sector != null) {
      profileJob = ProfileJobRequest(
        title: userEducationDetails.jobTitle,
        companyName: userEducationDetails.companyName,
        sector: userEducationDetails.sector!,
        jobTypeId: userEducationDetails.jobType,
        profileSalary: ProfileSalaryRequest(
          isAnnual: userEducationDetails.isYearly ?? true,
          amount: userEducationDetails.salaryDetails ?? 0.0,
          currencyCode: userEducationDetails.currency,
          isVisible: userEducationDetails.isVisible ?? false,
        ),
      );
    }

    // Build profile education if highest education is provided
    List<ProfileEducationRequest>? profileEducations;
    if (userEducationDetails.highestEducation != null) {
      profileEducations = [
        ProfileEducationRequest(
          qualification: userEducationDetails.qualification,
          institute: userEducationDetails.institute,
          sortNo: 0,
          educationQualificationId: userEducationDetails.highestEducation!,
        ),
      ];
    }

    // Convert profile images
    final profileImages = userBasicDetails.profilesImg.map((img) {
      return ProfileImageRequest(
        url: img.url,
        isProfile: img.isProfile,
        isVisible: img.isVisible,
      );
    }).toList();

    // Convert addresses
    final profileAddresses = userContactDetails.address.map((addr) {
      return ProfileAddressRequest(
        id: addr.id,
        number: addr.number,
        street: addr.street,
        city: addr.city,
        state: addr.state,
        zipcode: addr.zipcode,
        country: addr.country,
        latitude: addr.latitude,
        longitude: addr.longitude,
        addressType: addr.addressType,
        residentStatus: addr.residentStatus,
        isDefault: addr.isDefault,
      );
    }).toList();

    // Add religious address to profile addresses
    profileAddresses.add(
      ProfileAddressRequest(
        id: userReligiousDetails.address.id,
        number: userReligiousDetails.address.number,
        street: userReligiousDetails.address.street,
        city: userReligiousDetails.address.city,
        state: userReligiousDetails.address.state,
        zipcode: userReligiousDetails.address.zipcode,
        country: userReligiousDetails.address.country,
        latitude: userReligiousDetails.address.latitude,
        longitude: userReligiousDetails.address.longitude,
        addressType: userReligiousDetails.address.addressType,
        residentStatus: userReligiousDetails.address.residentStatus,
        isDefault: userReligiousDetails.address.isDefault,
      ),
    );

    return MemberRegistrationRequest(
      profileFor: matchingInfo.profileFor,
      isActive: true,
      firstName: userBasicDetails.firstName,
      lastName: userBasicDetails.lastName,
      email: userContactDetails.basicDetails.email,
      phoneNumber: userContactDetails.basicDetails.phoneNumber,
      phoneCode: userContactDetails.basicDetails.phoneCode,
      aboutMe: userPersonalDetails.aboutMe,
      gender: userBasicDetails.gender,
      dateOfBirth: userBasicDetails.dateOfBirth,
      foodHabit: userPersonalDetails.diet,
      drinksHabit: userPersonalDetails.drinking,
      smokeHabit: userPersonalDetails.smoking,
      marriageStatus: userBasicDetails.maritalStatus,
      bodyType: userPersonalDetails.bodyType,
      willingToRelocate: userPersonalDetails.canReLocated == 1 ? 1 : 0, // Convert to boolean-like int
      height: userBasicDetails.height,
      weight: userBasicDetails.weight,
      disability: userPersonalDetails.disability,
      originCountry: userFamilyDetails.originCountry,
      motherTongue: userPersonalDetails.motherTongue.toString(),
      knownLanguages: userPersonalDetails.languages,
      bloodGroup: userPersonalDetails.bloodGroup,
      skinComplexion: userPersonalDetails.complexion,
      isVisibleCommunity: userReligiousDetails.isVisible,
      userId: userId,
      religionId: userReligiousDetails.religion,
      communityId: userReligiousDetails.communityCast,
      profileJob: profileJob,
      profileLookingFor: ProfileLookingForRequest(
        gender: matchingInfo.gender,
        minAge: matchingInfo.minAge,
        maxAge: matchingInfo.maxAge,
        country: matchingInfo.country,
      ),
      profileFamily: ProfileFamilyRequest(
        fatherName: userFamilyDetails.fatherName,
        fatherOccupation: userFamilyDetails.fatherOccupation,
        motherName: userFamilyDetails.motherName,
        motherOccupation: userFamilyDetails.matherOccupation,
        numberOfSiblings: userFamilyDetails.siblings,
        familyType: userFamilyDetails.familyType,
      ),
      profileAstrology: ProfileAstrologyRequest(
        nakshathiram: userReligiousDetails.starNakshathra,
        raasi: userReligiousDetails.raasi,
        timeOfBirth: userReligiousDetails.timeOfBirth,
      ),
      profileImages: profileImages,
      profileAddresses: profileAddresses,
      profileEducations: profileEducations,
    );
  }
}
