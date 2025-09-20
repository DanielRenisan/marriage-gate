// Profile Job Model
class ProfileJob {
  final String? id;
  final String title;
  final String companyName;
  final int sector;
  final String? jobTypeId;
  final ProfileSalary? profileSalary;

  ProfileJob({
    this.id,
    required this.title,
    required this.companyName,
    required this.sector,
    this.jobTypeId,
    this.profileSalary,
  });

  factory ProfileJob.fromJson(Map<String, dynamic> json) {
    return ProfileJob(
      id: json['id'],
      title: json['title'] ?? '',
      companyName: json['companyName'] ?? '',
      sector: json['sector'] ?? 0,
      jobTypeId: json['jobTypeId'],
      profileSalary: json['profileSalary'] != null ? ProfileSalary.fromJson(json['profileSalary']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'companyName': companyName,
      'sector': sector,
      'jobTypeId': jobTypeId,
      'profileSalary': profileSalary?.toJson(),
    };
  }
}

// Profile Salary Model
class ProfileSalary {
  final bool isAnnual;
  final double amount;
  final String currencyCode;
  final bool isVisible;

  ProfileSalary({
    this.isAnnual = false,
    required this.amount,
    this.currencyCode = 'USD',
    this.isVisible = false,
  });

  factory ProfileSalary.fromJson(Map<String, dynamic> json) {
    return ProfileSalary(
      isAnnual: json['isAnnual'] ?? false,
      amount: (json['amount'] ?? 0).toDouble(),
      currencyCode: json['currencyCode'] ?? 'USD',
      isVisible: json['isVisible'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isAnnual': isAnnual,
      'amount': amount,
      'currencyCode': currencyCode,
      'isVisible': isVisible,
    };
  }
}

// Profile Looking For Model
class ProfileLookingFor {
  final String? id;
  final int gender;
  final int minAge;
  final int maxAge;
  final String country;

  ProfileLookingFor({
    this.id,
    required this.gender,
    required this.minAge,
    required this.maxAge,
    required this.country,
  });

  factory ProfileLookingFor.fromJson(Map<String, dynamic> json) {
    return ProfileLookingFor(
      id: json['id'],
      gender: json['gender'] ?? 0,
      minAge: json['minAge'] ?? 0,
      maxAge: json['maxAge'] ?? 0,
      country: json['country'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gender': gender,
      'minAge': minAge,
      'maxAge': maxAge,
      'country': country,
    };
  }
}

// Profile Family Model
class ProfileFamily {
  final String? id;
  final String? fatherName;
  final String? fatherOccupation;
  final String? motherName;
  final String? motherOccupation;
  final int numberOfSiblings;
  final int familyType;

  ProfileFamily({
    this.id,
    this.fatherName,
    this.fatherOccupation,
    this.motherName,
    this.motherOccupation,
    required this.numberOfSiblings,
    required this.familyType,
  });

  factory ProfileFamily.fromJson(Map<String, dynamic> json) {
    return ProfileFamily(
      id: json['id'],
      fatherName: json['fatherName'],
      fatherOccupation: json['fatherOccupation'],
      motherName: json['motherName'],
      motherOccupation: json['motherOccupation'],
      numberOfSiblings: json['numberOfSiblings'] ?? 0,
      familyType: json['familyType'] ?? 0,
    );
  }

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
}

// Profile Astrology Model
class ProfileAstrology {
  final String? id;
  final int nakshathiram;
  final int raasi;
  final String timeOfBirth;

  ProfileAstrology({
    this.id,
    required this.nakshathiram,
    required this.raasi,
    required this.timeOfBirth,
  });

  factory ProfileAstrology.fromJson(Map<String, dynamic> json) {
    return ProfileAstrology(
      id: json['id'],
      nakshathiram: json['nakshathiram'] ?? 0,
      raasi: json['raasi'] ?? 0,
      timeOfBirth: json['timeOfBirth'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nakshathiram': nakshathiram,
      'raasi': raasi,
      'timeOfBirth': timeOfBirth,
    };
  }
}

// Profile Address Model
class ProfileAddress {
  final String? id;
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

  ProfileAddress({
    this.id,
    required this.addressType,
    this.residentStatus,
    this.isDefault = false,
    this.number,
    required this.street,
    required this.city,
    required this.state,
    this.zipcode,
    required this.country,
    this.latitude = 0,
    this.longitude = 0,
  });

  factory ProfileAddress.fromJson(Map<String, dynamic> json) {
    return ProfileAddress(
      id: json['id'],
      addressType: json['addressType'] ?? 0,
      residentStatus: json['residentStatus'],
      isDefault: json['isDefault'] ?? false,
      number: json['number'],
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zipcode: json['zipcode'],
      country: json['country'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
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

// Profile Education Model
class ProfileEducation {
  final String? id;
  final String qualification;
  final String? institute;
  final int sortNo;
  final String? educationQualificationId;

  ProfileEducation({
    this.id,
    required this.qualification,
    this.institute,
    required this.sortNo,
    this.educationQualificationId,
  });

  factory ProfileEducation.fromJson(Map<String, dynamic> json) {
    return ProfileEducation(
      id: json['id'],
      qualification: json['qualification'] ?? '',
      institute: json['institute'],
      sortNo: json['sortNo'] ?? 0,
      educationQualificationId: json['educationQualificationId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'qualification': qualification,
      'institute': institute,
      'sortNo': sortNo,
      'educationQualificationId': educationQualificationId,
    };
  }
}

// Profile Image Model
class ProfileImage {
  final String? id;
  final String url;
  final bool isProfile;
  final bool isVisible;

  ProfileImage({
    this.id,
    required this.url,
    this.isProfile = false,
    this.isVisible = true,
  });

  factory ProfileImage.fromJson(Map<String, dynamic> json) {
    return ProfileImage(
      id: json['id'],
      url: json['url'] ?? '',
      isProfile: json['isProfile'] ?? false,
      isVisible: json['isVisible'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'isProfile': isProfile,
      'isVisible': isVisible,
    };
  }
}

// User Profile Model
class MemberProfile {
  final String id;
  final int profileFor;
  final bool isActive;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
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
  final ProfileJob? profileJob;
  final ProfileLookingFor? profileLookingFor;
  final ProfileFamily? profileFamily;
  final ProfileAstrology? profileAstrology;
  final List<ProfileImage> profileImages;
  final List<ProfileAddress> profileAddresses;
  final List<ProfileEducation> profileEducations;
  final String phoneCode;
  final int age;

  // Additional properties for compatibility with screens
  String? get profileImage => profileImages.isNotEmpty ? profileImages.first.url : null;
  String? get city => profileAddresses.isNotEmpty ? profileAddresses.first.city : null;
  String? get state => profileAddresses.isNotEmpty ? profileAddresses.first.state : null;
  String? get country => profileAddresses.isNotEmpty ? profileAddresses.first.country : null;
  String? get address => profileAddresses.isNotEmpty ? '${profileAddresses.first.street}, ${profileAddresses.first.city}' : null;
  String? get pincode => profileAddresses.isNotEmpty ? profileAddresses.first.zipcode : null;
  String? get maritalStatus => _getMaritalStatusText(marriageStatus);
  String? get occupation => profileJob?.title;
  String? get education => profileEducations.isNotEmpty ? profileEducations.first.qualification : null;
  String? get income => profileJob?.profileSalary?.amount.toString();
  String? get religion => _getReligionText(religionId);
  String? get caste => communityId;
  String? get gotra => profileAstrology?.nakshathiram.toString();
  String? get manglik => null; // Not available in new API
  String? get familyType => profileFamily?.familyType.toString();
  String? get familyStatus => null; // Not available in new API
  String? get familyIncome => null; // Not available in new API
  String? get fatherName => profileFamily?.fatherName;
  String? get motherName => profileFamily?.motherName;
  int? get siblings => profileFamily?.numberOfSiblings ?? 0;
  String? get diet => _getDietText(foodHabit);
  String? get drinkHabit => _getDrinkText(drinksHabit);
  String? get smokeHabitText => _getSmokeText(smokeHabit);
  String? get complexion => _getComplexionText(skinComplexion);
  MatchPreferences? get matchPreferences => profileLookingFor != null
      ? MatchPreferences(
          ageFrom: profileLookingFor!.minAge,
          ageTo: profileLookingFor!.maxAge,
          heightFrom: null,
          heightTo: null,
          maritalStatus: null,
          religion: null,
          education: null,
          jobType: null,
          location: profileLookingFor!.country,
        )
      : null;

  // Helper methods for text conversion
  String? _getMaritalStatusText(int status) {
    switch (status) {
      case 1:
        return 'Single';
      case 2:
        return 'Married';
      case 3:
        return 'Divorced';
      case 4:
        return 'Widowed';
      case 5:
        return 'Separated';
      default:
        return 'Not specified';
    }
  }

  String? _getReligionText(String religionId) {
    switch (religionId) {
      case '1':
        return 'Hindu';
      case '2':
        return 'Muslim';
      case '3':
        return 'Christian';
      case '4':
        return 'Sikh';
      case '5':
        return 'Buddhist';
      case '6':
        return 'Jain';
      default:
        return 'Other';
    }
  }

  String? _getDietText(int diet) {
    switch (diet) {
      case 1:
        return 'Non-Vegetarian';
      case 2:
        return 'Vegetarian';
      case 3:
        return 'Vegan';
      case 4:
        return 'Eggetarian';
      default:
        return 'Not specified';
    }
  }

  String? _getDrinkText(int drink) {
    switch (drink) {
      case 1:
        return 'Non-Drinker';
      case 2:
        return 'Occasionally';
      case 3:
        return 'Regularly';
      case 4:
        return 'Trying to Quit';
      default:
        return 'Not specified';
    }
  }

  String? _getSmokeText(int smoke) {
    switch (smoke) {
      case 1:
        return 'Non-Smoker';
      case 2:
        return 'Occasionally';
      case 3:
        return 'Regularly';
      case 4:
        return 'Trying to Quit';
      default:
        return 'Not specified';
    }
  }

  String? _getComplexionText(int complexion) {
    switch (complexion) {
      case 1:
        return 'Very Fair';
      case 2:
        return 'Fair';
      case 3:
        return 'Wheatish';
      case 4:
        return 'Wheatish Brown';
      case 5:
        return 'Dark';
      default:
        return 'Not specified';
    }
  }

  MemberProfile({
    required this.id,
    required this.profileFor,
    required this.isActive,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
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
    required this.phoneCode,
    required this.age,
  });

  factory MemberProfile.fromJson(Map<String, dynamic> json) {
    return MemberProfile(
      id: json['id'] ?? '',
      profileFor: json['profileFor'] ?? 0,
      isActive: json['isActive'] ?? false,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      aboutMe: json['aboutMe'] ?? '',
      gender: json['gender'] ?? 0,
      dateOfBirth: json['dateOfBirth'] ?? '',
      foodHabit: json['foodHabit'] ?? 0,
      drinksHabit: json['drinksHabit'] ?? 0,
      smokeHabit: json['smokeHabit'] ?? 0,
      marriageStatus: json['marriageStatus'] ?? 0,
      bodyType: json['bodyType'] ?? 0,
      willingToRelocate: json['willingToRelocate'] ?? 0,
      height: (json['height'] ?? 0).toDouble(),
      weight: (json['weight'] ?? 0).toDouble(),
      disability: json['disability'] ?? '',
      originCountry: json['originCountry'] ?? '',
      motherTongue: json['motherTongue'],
      knownLanguages: json['knownLanguages'],
      bloodGroup: json['bloodGroup'] ?? 0,
      skinComplexion: json['skinComplexion'] ?? 0,
      isVisibleCommunity: json['isVisibleCommunity'] ?? false,
      userId: json['userId'] ?? '',
      religionId: json['religionId'] ?? '',
      communityId: json['communityId'],
      subCommunityId: json['subCommunityId'],
      profileJob: json['profileJob'] != null ? ProfileJob.fromJson(json['profileJob']) : null,
      profileLookingFor: json['profileLookingFor'] != null ? ProfileLookingFor.fromJson(json['profileLookingFor']) : null,
      profileFamily: json['profileFamily'] != null ? ProfileFamily.fromJson(json['profileFamily']) : null,
      profileAstrology: json['profileAstrology'] != null ? ProfileAstrology.fromJson(json['profileAstrology']) : null,
      profileImages: (json['profileImages'] as List<dynamic>?)?.isNotEmpty == true
          ? (json['profileImages'] as List<dynamic>).map((i) => ProfileImage.fromJson(i as Map<String, dynamic>)).toList()
          : [
              ProfileImage(
                  url:
                      'https://dev1mg.blob.core.windows.net/temp/mgate/indian-groom-wearing-traditional-wedding-sherwani-turban-vector-illustration-gold-red-feather-detail-depicting-381238297.webp-446f2768-f5af-417f-9d39-17fa69ce3636?sv=2025-05-05&se=2025-07-01T10%3A28%3A51Z&sr=b&sp=rd&sig=bm5avHwTVMc%2BHiFNjDG4Y3XdOqFmboMPeuQqhYOqAtw%3D')
            ],
      profileAddresses: (json['profileAddresses'] as List<dynamic>? ?? [])
          .map((a) => ProfileAddress.fromJson(a as Map<String, dynamic>))
          .toList(),
      profileEducations: (json['profileEducations'] as List<dynamic>? ?? [])
          .map((e) => ProfileEducation.fromJson(e as Map<String, dynamic>))
          .toList(),
      phoneCode: json['phoneCode'] ?? '',
      age: json['age'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profileFor': profileFor,
      'isActive': isActive,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
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
      'profileImages': profileImages.map((i) => i.toJson()).toList(),
      'profileAddresses': profileAddresses.map((a) => a.toJson()).toList(),
      'profileEducations': profileEducations.map((e) => e.toJson()).toList(),
      'phoneCode': phoneCode,
      'age': age,
    };
  }
}

// Registration Form Models
class UserBasicForm {
  final String firstName;
  final String lastName;
  final int gender;
  final String dateOfBirth;
  final int maritalStatus;
  final double height;
  final double weight;
  final List<String> profilesImg;
  final bool isVisible;

  UserBasicForm({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dateOfBirth,
    required this.maritalStatus,
    required this.height,
    required this.weight,
    this.profilesImg = const [],
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
      'profilesImg': profilesImg,
      'isVisible': isVisible,
    };
  }
}

class UserContactForm {
  final String email;
  final String phoneNumber;
  final String city;
  final String stateProvince;
  final String convenientTimeToCall;
  final String country;
  final String address;
  final int residencyStatus;

  UserContactForm({
    required this.email,
    required this.phoneNumber,
    required this.city,
    required this.stateProvince,
    required this.convenientTimeToCall,
    required this.country,
    required this.address,
    required this.residencyStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phoneNumber': phoneNumber,
      'city': city,
      'stateProvince': stateProvince,
      'convenientTimeToCall': convenientTimeToCall,
      'country': country,
      'address': address,
      'residencyStatus': residencyStatus,
    };
  }
}

class PersonalDetails {
  final String aboutMe;
  final String disability;
  final int motherTongue;
  final int diet;
  final int smoking;
  final int drinking;
  final List<int> languages;
  final int bodyType;
  final bool canReLocated;
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

class UserFamilyInfo {
  final String fatherName;
  final String motherName;
  final int familyType;
  final int familyStatus;
  final int familyIncome;
  final int familyValues;

  UserFamilyInfo({
    required this.fatherName,
    required this.motherName,
    required this.familyType,
    required this.familyStatus,
    required this.familyIncome,
    required this.familyValues,
  });

  Map<String, dynamic> toJson() {
    return {
      'fatherName': fatherName,
      'motherName': motherName,
      'familyType': familyType,
      'familyStatus': familyStatus,
      'familyIncome': familyIncome,
      'familyValues': familyValues,
    };
  }
}

class UserReligiousInfo {
  final String religion;
  final String communityCast;
  final String timeOfBirth;
  final bool isVisible;
  final int starNakshathra;
  final int raasi;
  final int chevvaiDosham;
  final int horoscopeMatching;
  final ProfileAddress address;

  UserReligiousInfo({
    required this.religion,
    required this.communityCast,
    required this.timeOfBirth,
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

class UserEducationDetails {
  final String highestEducation;
  final String institution;
  final String yearOfCompletion;
  final String educationQualificationId;

  UserEducationDetails({
    required this.highestEducation,
    required this.institution,
    required this.yearOfCompletion,
    required this.educationQualificationId,
  });

  Map<String, dynamic> toJson() {
    return {
      'highestEducation': highestEducation,
      'institution': institution,
      'yearOfCompletion': yearOfCompletion,
      'educationQualificationId': educationQualificationId,
    };
  }
}

class MatchPreferences {
  final int? ageFrom;
  final int? ageTo;
  final int? heightFrom;
  final int? heightTo;
  final String? maritalStatus;
  final String? religion;
  final String? community;
  final String? education;
  final String? jobType;
  final String? location;

  // Additional properties for compatibility with screens
  String? get gender => 'Male'; // Default value
  int? get minAge => ageFrom;
  int? get maxAge => ageTo;
  String? get caste => community;
  String? get occupation => jobType;
  String? get income => null; // Default value
  String? get city => location;
  String? get state => null; // Default value
  String? get country => null; // Default value

  MatchPreferences({
    this.ageFrom,
    this.ageTo,
    this.heightFrom,
    this.heightTo,
    this.maritalStatus,
    this.religion,
    this.community,
    this.education,
    this.jobType,
    this.location,
  });

  Map<String, dynamic> toJson() {
    return {
      'ageFrom': ageFrom,
      'ageTo': ageTo,
      'heightFrom': heightFrom,
      'heightTo': heightTo,
      'maritalStatus': maritalStatus,
      'religion': religion,
      'community': community,
      'education': education,
      'jobType': jobType,
      'location': location,
    };
  }
}

// Chat Models
class ChatParticipant {
  final String id;
  final String firstName;
  final String lastName;
  final String? imageUrl;
  final String lastMessage;
  final String lastMessageTime;
  final bool isOnline;
  final int unreadCount;

  // Additional properties for compatibility with screens
  String? get profileImage => imageUrl;
  String? get name => '$firstName $lastName';
  String? get lastSentAt => lastMessageTime;
  bool? get isRead => unreadCount == 0;
  bool? get isSentByMe => false; // Default value
  String? get receiverProfileId => id;
  String? get lastOnlineAt => isOnline ? 'Online' : lastMessageTime;

  ChatParticipant({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.imageUrl,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.isOnline,
    required this.unreadCount,
  });

  factory ChatParticipant.fromJson(Map<String, dynamic> json) {
    return ChatParticipant(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      imageUrl: json['imageUrl'],
      lastMessage: json['lastMessage'] ?? '',
      lastMessageTime: json['lastMessageTime'] ?? '',
      isOnline: json['isOnline'] ?? false,
      unreadCount: json['unreadCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'imageUrl': imageUrl,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'isOnline': isOnline,
      'unreadCount': unreadCount,
    };
  }
}

class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final String messageType;
  final String timestamp;
  final bool isRead;
  final String? readAt;

  // Additional properties for compatibility with screens
  String? get textContent => content;
  List<String>? get fileUrls => []; // Default empty list
  bool? get isMine => false; // Default value
  String? get sentAt => timestamp;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.messageType,
    required this.timestamp,
    required this.isRead,
    this.readAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? '',
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      content: json['content'] ?? '',
      messageType: json['messageType'] ?? 'text',
      timestamp: json['timestamp'] ?? '',
      isRead: json['isRead'] ?? false,
      readAt: json['readAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'messageType': messageType,
      'timestamp': timestamp,
      'isRead': isRead,
      'readAt': readAt,
    };
  }
}

class FriendRequest {
  final String id;
  final String senderId;
  final String receiverId;
  final String senderName;
  final String? senderImage;
  final String status;
  final String requestDate;

  FriendRequest({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.senderName,
    this.senderImage,
    required this.status,
    required this.requestDate,
  });

  factory FriendRequest.fromJson(Map<String, dynamic> json) {
    return FriendRequest(
      id: json['id'] ?? '',
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      senderName: json['senderName'] ?? '',
      senderImage: json['senderImage'],
      status: json['status'] ?? '',
      requestDate: json['requestDate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'senderName': senderName,
      'senderImage': senderImage,
      'status': status,
      'requestDate': requestDate,
    };
  }
}

// Data Models
class Country {
  final String id;
  final String name;
  final String code;
  final String phoneCode;

  Country({
    required this.id,
    required this.name,
    required this.code,
    required this.phoneCode,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      phoneCode: json['phoneCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'phoneCode': phoneCode,
    };
  }
}

class Religion {
  final String id;
  final String name;

  Religion({
    required this.id,
    required this.name,
  });

  factory Religion.fromJson(Map<String, dynamic> json) {
    return Religion(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Community {
  final String id;
  final String name;
  final String religionId;

  Community({
    required this.id,
    required this.name,
    required this.religionId,
  });

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      religionId: json['religionId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'religionId': religionId,
    };
  }
}

class Education {
  final String id;
  final String name;

  Education({
    required this.id,
    required this.name,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class JobType {
  final String id;
  final String name;

  JobType({
    required this.id,
    required this.name,
  });

  factory JobType.fromJson(Map<String, dynamic> json) {
    return JobType(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

// Profile Question Model
class ProfileQuestion {
  final String id;
  final String question;
  final String questionType;
  final List<String> options;
  final bool isRequired;

  ProfileQuestion({
    required this.id,
    required this.question,
    required this.questionType,
    this.options = const [],
    required this.isRequired,
  });

  factory ProfileQuestion.fromJson(Map<String, dynamic> json) {
    return ProfileQuestion(
      id: json['id'] ?? '',
      question: json['question'] ?? '',
      questionType: json['questionType'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      isRequired: json['isRequired'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'questionType': questionType,
      'options': options,
      'isRequired': isRequired,
    };
  }
}
