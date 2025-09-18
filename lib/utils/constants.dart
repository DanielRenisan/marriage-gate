enum UserType {
  admin('Admin'),
  agent('Agent'),
  member('Member');

  const UserType(this.value);
  final String value;
}

class ClientData {
  static const Map<String, dynamic> admin = {
    'name': 'admin',
    'secretKey': 'admin123',
  };

  static const Map<String, dynamic> agent = {
    'name': 'Agent',
    'secretKey': 'Agent123',
  };

  static const Map<String, dynamic> member = {
    'name': 'member',
    'secretKey': 'member123',
  };
}

class MatrimonyConfig {
  static const Map<String, dynamic> admin = {
    'userType': 'Admin',
    'clientData': ClientData.admin,
  };

  static const Map<String, dynamic> agent = {
    'userType': 'Agent',
    'clientData': ClientData.agent,
  };

  static const Map<String, dynamic> member = {
    'userType': 'Member',
    'clientData': ClientData.member,
  };
}

enum ResetPasswordStep {
  enterEmail(1),
  verification(2),
  resetPassword(3);

  const ResetPasswordStep(this.value);
  final int value;
}

class ApiEndpoints {
  static const String baseUrl = 'https://mgate.runasp.net/api/';
  static const String clientToken = 'Client/client-token';
  static const String register = 'Auth/register';
  static const String login = 'Auth/login';
  static const String forgotPassword = 'Password/forgot-password';
  static const String otpVerification = 'Password/otp-verification';
  static const String emailVerification = 'Auth/email/verification';
  static const String resetPassword = 'Password/reset-password';
  static const String socialLogin = 'Auth/social-login';
  static const String googleLogin = 'google-login';
  static const String getUserDetails = 'User';
  static const String getUserProfiles = 'Profile/user';

  // Member endpoints
  static const String memberProfile = 'Member/profile';
  static const String createMember = 'Member/create';
  static const String createProfile = 'profile';
  static const String updateMember = 'Member/update';
  static const String deleteMember = 'Member/delete';
  static const String getMemberById = 'Member/profile/';
  static const String getMatchingProfiles = 'ProfileMatching/matching';
  static const String getProfileMatchingData = 'ProfileMatching/matching';
  static const String sendFriendRequest = 'Member/friend-request';
  static const String getFriendRequests = 'Member/friend-requests';
  static const String acceptFriendRequest = 'Member/accept-friend-request';
  static const String rejectFriendRequest = 'Member/reject-friend-request';
  static const String getFriends = 'Member/friends';

  // Chat endpoints
  static const String getChatParticipants = 'Chat/participants';
  static const String getChatMessages = 'Chat/messages';
  static const String sendMessage = 'Chat/send-message';
  static const String markMessageAsRead = 'Chat/mark-read';

  // Notification endpoints
  static const String getNotifications = 'Notification';
  static const String markNotificationAsRead = 'Notification/mark-read';
  static const String markAllNotificationsAsRead = 'Notification/mark-all-read';

  // Data endpoints
  static const String getCountryCodes = 'Data/country-codes';
  static const String getProfileQuestions = 'Data/profile-questions';
  static const String uploadFile = 'Data/upload-file';
  static const String getReligions = 'Religion';
  static const String getCommunities = 'Community';
  static const String getEducationQualifications = 'EducationQualification';
  static const String getJobTypes = 'JobType';
}

enum UserRole {
  admin(1),
  agent(2),
  user(3);

  const UserRole(this.value);
  final int value;
}

// Login and Token Types (matching Angular implementation)
enum LoginType {
  email(1),
  phoneNumber(2),
  google(3),
  facebook(4);

  const LoginType(this.value);
  final int value;
}

enum TokenType {
  clientToken(1),
  loginToken(2),
  forgotPasswordToken(3),
  resetPasswordToken(4),
  userVerificationToken(5);

  const TokenType(this.value);
  final int value;
}

// Registration Steps Enum
enum RegistrationStep {
  lookingFor(0, 'Matching Information'),
  basic(1, 'Personal Information'),
  contact(2, 'Contact Details'),
  personal(3, 'Personal Details'),
  family(4, 'Family Information'),
  religionBackground(5, 'Religious Background'),
  education(6, 'Education & Career'),
  complete(7, 'Complete');

  const RegistrationStep(this.value, this.title);
  final int value;
  final String title;

  static RegistrationStep fromValue(int value) {
    return RegistrationStep.values.firstWhere(
      (step) => step.value == value,
      orElse: () => RegistrationStep.lookingFor,
    );
  }
}

// Registration Constants
class RegistrationConstants {
  // Gender options
  static const List<Map<String, dynamic>> genderOptions = [
    {'id': 1, 'name': 'Male'},
    {'id': 2, 'name': 'Female'},
  ];

  // Marital status options
  static const List<Map<String, dynamic>> maritalStatusOptions = [
    {'id': 1, 'name': 'Single'},
    {'id': 2, 'name': 'Married'},
    {'id': 3, 'name': 'Divorced'},
    {'id': 4, 'name': 'Widowed'},
    {'id': 5, 'name': 'Separated'},
  ];

  // Diet options
  static const List<Map<String, dynamic>> dietOptions = [
    {'id': 1, 'name': 'Non-Vegetarian'},
    {'id': 2, 'name': 'Vegetarian'},
    {'id': 3, 'name': 'Vegan'},
    {'id': 4, 'name': 'Eggetarian'},
  ];

  // Smoking habit options
  static const List<Map<String, dynamic>> smokingOptions = [
    {'id': 1, 'name': 'Non-Smoker'},
    {'id': 2, 'name': 'Occasionally'},
    {'id': 3, 'name': 'Regularly'},
    {'id': 4, 'name': 'Trying to Quit'},
  ];

  // Drinking habit options
  static const List<Map<String, dynamic>> drinkingOptions = [
    {'id': 1, 'name': 'Non-Drinker'},
    {'id': 2, 'name': 'Occasionally'},
    {'id': 3, 'name': 'Regularly'},
    {'id': 4, 'name': 'Trying to Quit'},
  ];

  // Body type options
  static const List<Map<String, dynamic>> bodyTypeOptions = [
    {'id': 1, 'name': 'Average'},
    {'id': 2, 'name': 'Slim'},
    {'id': 3, 'name': 'Athletic'},
    {'id': 4, 'name': 'Heavy'},
  ];

  // Blood group options
  static const List<Map<String, dynamic>> bloodGroupOptions = [
    {'id': 1, 'name': 'A+'},
    {'id': 2, 'name': 'A-'},
    {'id': 3, 'name': 'B+'},
    {'id': 4, 'name': 'B-'},
    {'id': 5, 'name': 'AB+'},
    {'id': 6, 'name': 'AB-'},
    {'id': 7, 'name': 'O+'},
    {'id': 8, 'name': 'O-'},
  ];

  // Complexion options
  static const List<Map<String, dynamic>> complexionOptions = [
    {'id': 1, 'name': 'Fair'},
    {'id': 2, 'name': 'Wheatish'},
    {'id': 3, 'name': 'Dark'},
    {'id': 4, 'name': 'Very Fair'},
  ];

  // Religion options
  static const List<Map<String, dynamic>> religionOptions = [
    {'id': 1, 'name': 'Hindu'},
    {'id': 2, 'name': 'Muslim'},
    {'id': 3, 'name': 'Christian'},
    {'id': 4, 'name': 'Sikh'},
    {'id': 5, 'name': 'Buddhist'},
    {'id': 6, 'name': 'Jain'},
    {'id': 7, 'name': 'Other'},
  ];

  // Education options
  static const List<Map<String, dynamic>> educationOptions = [
    {'id': 1, 'name': 'High School'},
    {'id': 2, 'name': 'Bachelor\'s'},
    {'id': 3, 'name': 'Master\'s'},
    {'id': 4, 'name': 'PhD'},
    {'id': 5, 'name': 'Other'},
  ];

  // Family type options
  static const List<Map<String, dynamic>> familyTypeOptions = [
    {'id': 1, 'name': 'Nuclear'},
    {'id': 2, 'name': 'Joint'},
    {'id': 3, 'name': 'Extended'},
  ];

  // Language options
  static const List<Map<String, dynamic>> languageOptions = [
    {'id': 1, 'name': 'English'},
    {'id': 2, 'name': 'Hindi'},
    {'id': 3, 'name': 'Tamil'},
    {'id': 4, 'name': 'Telugu'},
    {'id': 5, 'name': 'Kannada'},
    {'id': 6, 'name': 'Malayalam'},
    {'id': 7, 'name': 'Bengali'},
    {'id': 8, 'name': 'Gujarati'},
    {'id': 9, 'name': 'Marathi'},
    {'id': 10, 'name': 'Punjabi'},
    {'id': 11, 'name': 'Urdu'},
    {'id': 12, 'name': 'Sanskrit'},
  ];

  // Common languages for Known Languages dropdown
  static const List<String> commonLanguages = [
    'English',
    'Hindi',
    'Tamil',
    'Telugu',
    'Kannada',
    'Malayalam',
    'Bengali',
    'Gujarati',
    'Marathi',
    'Punjabi',
    'Urdu',
    'Sanskrit',
    'French',
    'Spanish',
    'German',
    'Italian',
    'Portuguese',
    'Russian',
    'Chinese',
    'Japanese',
    'Korean',
    'Arabic',
    'Turkish',
    'Dutch',
    'Swedish',
    'Norwegian',
    'Danish',
    'Finnish',
    'Polish',
    'Czech',
    'Hungarian',
    'Romanian',
    'Bulgarian',
    'Croatian',
    'Serbian',
    'Slovak',
    'Slovenian',
    'Estonian',
    'Latvian',
    'Lithuanian',
    'Greek',
    'Hebrew',
    'Persian',
    'Thai',
    'Vietnamese',
    'Indonesian',
    'Malay',
    'Filipino',
    'Swahili',
    'Amharic',
    'Yoruba',
    'Igbo',
    'Hausa',
    'Zulu',
    'Afrikaans',
    'Other'
  ];

  // Sector options
  static const List<Map<String, dynamic>> sectorOptions = [
    {'id': 1, 'name': 'IT/Software'},
    {'id': 2, 'name': 'Healthcare'},
    {'id': 3, 'name': 'Finance'},
    {'id': 4, 'name': 'Education'},
    {'id': 5, 'name': 'Government'},
    {'id': 6, 'name': 'Manufacturing'},
    {'id': 7, 'name': 'Retail'},
    {'id': 8, 'name': 'Real Estate'},
    {'id': 9, 'name': 'Media'},
    {'id': 10, 'name': 'Other'},
  ];

  // Currency options
  static final List<Map<String, dynamic>> currencyOptions = [
    {'id': '1', 'code': 'INR', 'name': 'INR (₹)'},
    {'id': '2', 'code': 'USD', 'name': 'USD (\$)'},
    {'id': '3', 'code': 'EUR', 'name': 'EUR (€)'},
    {'id': '4', 'code': 'GBP', 'name': 'GBP (£)'},
    {'id': '5', 'code': 'CAD', 'name': 'CAD (C\$)'},
    {'id': '6', 'code': 'AUD', 'name': 'AUD (A\$)'},
  ];

  // Star/Nakshathra options
  static const List<Map<String, dynamic>> starOptions = [
    {'id': 1, 'name': 'Ashwini'},
    {'id': 2, 'name': 'Bharani'},
    {'id': 3, 'name': 'Krittika'},
    {'id': 4, 'name': 'Rohini'},
    {'id': 5, 'name': 'Mrigashira'},
    {'id': 6, 'name': 'Ardra'},
    {'id': 7, 'name': 'Punarvasu'},
    {'id': 8, 'name': 'Pushya'},
    {'id': 9, 'name': 'Ashlesha'},
    {'id': 10, 'name': 'Magha'},
    {'id': 11, 'name': 'Purva Phalguni'},
    {'id': 12, 'name': 'Uttara Phalguni'},
    {'id': 13, 'name': 'Hasta'},
    {'id': 14, 'name': 'Chitra'},
    {'id': 15, 'name': 'Swati'},
    {'id': 16, 'name': 'Vishakha'},
    {'id': 17, 'name': 'Anuradha'},
    {'id': 18, 'name': 'Jyeshtha'},
    {'id': 19, 'name': 'Mula'},
    {'id': 20, 'name': 'Purva Ashadha'},
    {'id': 21, 'name': 'Uttara Ashadha'},
    {'id': 22, 'name': 'Shravana'},
    {'id': 23, 'name': 'Dhanishta'},
    {'id': 24, 'name': 'Shatabhisha'},
    {'id': 25, 'name': 'Purva Bhadrapada'},
    {'id': 26, 'name': 'Uttara Bhadrapada'},
    {'id': 27, 'name': 'Revati'},
  ];

  // Raasi options
  static const List<Map<String, dynamic>> raasiOptions = [
    {'id': 1, 'name': 'Aries (Mesha)'},
    {'id': 2, 'name': 'Taurus (Vrishabha)'},
    {'id': 3, 'name': 'Gemini (Mithuna)'},
    {'id': 4, 'name': 'Cancer (Karka)'},
    {'id': 5, 'name': 'Leo (Simha)'},
    {'id': 6, 'name': 'Virgo (Kanya)'},
    {'id': 7, 'name': 'Libra (Tula)'},
    {'id': 8, 'name': 'Scorpio (Vrishchika)'},
    {'id': 9, 'name': 'Sagittarius (Dhanu)'},
    {'id': 10, 'name': 'Capricorn (Makara)'},
    {'id': 11, 'name': 'Aquarius (Kumbha)'},
    {'id': 12, 'name': 'Pisces (Meena)'},
  ];

  // Can relocate options
  static const List<Map<String, dynamic>> canRelocateOptions = [
    {'id': 1, 'name': 'Yes'},
    {'id': 2, 'name': 'No'},
    {'id': 3, 'name': 'Maybe'},
  ];

  // Family status options
  static const List<Map<String, dynamic>> familyStatusOptions = [
    {'id': 1, 'name': 'Nuclear'},
    {'id': 2, 'name': 'Joint'},
    {'id': 3, 'name': 'Extended'},
  ];

  // Income options
  static const List<Map<String, dynamic>> incomeOptions = [
    {'id': 1, 'name': 'Below 2 Lakhs'},
    {'id': 2, 'name': '2-5 Lakhs'},
    {'id': 3, 'name': '5-10 Lakhs'},
    {'id': 4, 'name': '10-20 Lakhs'},
    {'id': 5, 'name': '20-50 Lakhs'},
    {'id': 6, 'name': 'Above 50 Lakhs'},
  ];

  // Profile for options
  static const List<Map<String, dynamic>> profileForOptions = [
    {'id': 1, 'name': 'Self'},
    {'id': 2, 'name': 'Son'},
    {'id': 3, 'name': 'Daughter'},
    {'id': 4, 'name': 'Brother'},
    {'id': 5, 'name': 'Sister'},
    {'id': 6, 'name': 'Relative'},
    {'id': 7, 'name': 'Friend'},
  ];

  // Registration steps (legacy)
  static final List<String> legacyRegistrationSteps = [
    'Basic Info',
    'Contact Info',
    'Personal Details',
    'Family Info',
    'Religious Background',
    'Education & Career',
    'Preferences',
  ];

  // Validation messages
  static final Map<String, String> validationMessages = {
    'firstName': 'First name is required',
    'lastName': 'Last name is required',
    'email': 'Please enter a valid email address',
    'phoneNumber': 'Please enter a valid phone number',
    'dateOfBirth': 'Date of birth is required',
    'height': 'Height is required',
    'weight': 'Weight is required',
    'aboutMe': 'About me is required (minimum 50 characters)',
    'fatherName': 'Father\'s name is required',
    'motherName': 'Mother\'s name is required',
    'fatherOccupation': 'Father\'s occupation is required',
    'motherOccupation': 'Mother\'s occupation is required',
    'siblings': 'Number of siblings is required',
    'familyType': 'Family type is required',
    'originCountry': 'Origin country is required',
    'religion': 'Religion is required',
    'street': 'Street is required',
    'city': 'City is required',
    'stateProvince': 'State/Province is required',
    'country': 'Country is required',
    'qualification': 'Qualification is required',
    'institute': 'Institute is required',
    'jobTitle': 'Job title is required',
    'companyName': 'Company name is required',
    'profileFor': 'Profile for is required',
    'gender': 'Gender is required',
  };

  // Error messages
  static final Map<String, String> errorMessages = {
    'network_error': 'Network error. Please check your internet connection.',
    'server_error': 'Server error. Please try again later.',
    'validation_error': 'Please check your input and try again.',
    'unknown_error': 'An unknown error occurred. Please try again.',
    'profile_creation_failed': 'Failed to create profile. Please try again.',
    'profile_creation_success': 'Profile created successfully!',
    'image_upload_failed': 'Failed to upload image. Please try again.',
    'invalid_image': 'Please select a valid image file.',
    'image_size_limit': 'Image size should be between 250KB and 5MB.',
    'max_images_limit': 'You can upload maximum 5 images.',
  };

  static const List<RegistrationStep> registrationSteps = [
    RegistrationStep.lookingFor,
    RegistrationStep.basic,
    RegistrationStep.contact,
    RegistrationStep.personal,
    RegistrationStep.family,
    RegistrationStep.religionBackground,
    RegistrationStep.education,
  ];

  static String getStepDescription(RegistrationStep step) {
    switch (step) {
      case RegistrationStep.lookingFor:
        return 'The following information is used to match user profiles based on preferences.';
      case RegistrationStep.basic:
        return 'Please provide your basic personal details to get started.';
      case RegistrationStep.contact:
        return 'These details help your matched connections reach out to you.';
      case RegistrationStep.personal:
        return 'These details describe your lifestyle and can help you connect with like-minded individuals.';
      case RegistrationStep.family:
        return 'These details describe your lifestyle and can help you connect with like-minded individuals.';
      case RegistrationStep.religionBackground:
        return 'This information, helps find matches that align with your religious and cultural beliefs.';
      case RegistrationStep.education:
        return 'Your education and career details help match profiles with similar professional and academic backgrounds.';
      default:
        return '';
    }
  }

  static String getProgressWidth(RegistrationStep step) {
    switch (step) {
      case RegistrationStep.lookingFor:
        return '0%';
      case RegistrationStep.basic:
        return '15%';
      case RegistrationStep.contact:
        return '30%';
      case RegistrationStep.personal:
        return '45%';
      case RegistrationStep.family:
        return '65%';
      case RegistrationStep.religionBackground:
        return '70%';
      case RegistrationStep.education:
        return '100%';
      default:
        return '0%';
    }
  }
}

enum FriendRequestStatus {
  pending(1),
  accepted(2),
  rejected(3);

  const FriendRequestStatus(this.value);
  final int value;
}

class SocialLoginConstants {
  static const String facebookAppId = '2480872695583098';
}
