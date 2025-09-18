# Member Registration Models Documentation

This document explains the new member registration models that match the Angular matrimony app implementation exactly.

## Overview

The new models provide a complete, Angular-compatible structure for member registration that includes:
- Proper data types and validation
- Nullable/non-nullable field handling
- Complete form structure matching Angular components
- Built-in validation helpers

## Models Structure

### 1. MemberRegistrationRequest
The main request model that matches the Angular `_prePareUserPostBody()` method exactly.

**Key Features:**
- All fields match Angular field names and types
- Proper nullable/non-nullable handling
- Nested objects for complex data structures
- Built-in JSON serialization

**Required Fields:**
- `profileFor`, `firstName`, `lastName`, `email`, `phoneNumber`, `phoneCode`
- `aboutMe`, `gender`, `dateOfBirth`, `foodHabit`, `drinksHabit`, `smokeHabit`
- `marriageStatus`, `bodyType`, `willingToRelocate`, `height`, `weight`
- `disability`, `originCountry`, `motherTongue`, `bloodGroup`, `skinComplexion`
- `isVisibleCommunity`, `userId`, `religionId`, `profileLookingFor`
- `profileFamily`, `profileAstrology`, `profileImages`, `profileAddresses`

**Optional Fields:**
- `knownLanguages`, `communityId`, `profileJob`, `profileEducations`

### 2. Nested Request Models

#### ProfileJobRequest
Handles job/career information with salary details.

#### ProfileLookingForRequest
Handles partner preferences (age range, gender, location).

#### ProfileFamilyRequest
Handles family information including parents and siblings.

#### ProfileAstrologyRequest
Handles astrological information (star, raasi, birth time).

#### ProfileImageRequest
Handles profile images with visibility settings.

#### ProfileAddressRequest
Handles address information for different address types.

#### ProfileEducationRequest
Handles education and qualification information.

### 3. Form Data Models

These models match the Angular form component structures:

#### MatchPreferences
Matches `looking-for-form.component.ts` data structure.

#### UserBasicForm
Matches `member-profile-form.component.ts` data structure.

#### UserContactForm
Matches `contact-info-form.component.ts` data structure.

#### PersonalDetails
Matches `personal-details-form.component.ts` data structure.

#### UserFamilyInfo
Matches `family-information-form.component.ts` data structure.

#### UserReligiousInfo
Matches `religious-background-form.component.ts` data structure.

#### UserEducationDetails
Matches `education-details-form.component.ts` data structure.

## Data Type Corrections

### Fixed Issues from Previous Implementation:

1. **willingToRelocate**: Now `int` type (1 for true, 0 for false)
2. **motherTongue**: Now `String` type (e.g., "4" instead of 4)
3. **userId, religionId, communityId**: Proper fallback values instead of empty/null
4. **Address Types**: Proper enum values (0: living, 1: temporary, 3: birth)
5. **Validation**: Comprehensive validation for all required fields

## Usage Examples

### 1. Basic Usage

```dart
// Create form objects
final matchPreferences = MatchPreferences(
  profileFor: 1,
  gender: 1,
  minAge: 25,
  maxAge: 35,
  country: 'Sri Lanka',
);

final userBasicForm = UserBasicForm(
  firstName: 'John',
  lastName: 'Doe',
  gender: 1,
  dateOfBirth: '1990-01-01',
  maritalStatus: 1,
  height: 170.0,
  weight: 70.0,
  profilesImg: [],
);

// Build registration request
final registrationRequest = MemberFormBuilder.buildRegistrationRequest(
  matchingInfo: matchPreferences,
  userBasicDetails: userBasicForm,
  userContactDetails: userContactForm,
  userPersonalDetails: personalDetails,
  userFamilyDetails: userFamilyDetails,
  userReligiousDetails: userReligiousInfo,
  userEducationDetails: userEducationDetails,
  userId: 'user123',
);

// Submit registration
final response = await memberService.createMemberProfile(registrationRequest);
```

### 2. Validation Usage

```dart
// Validate form data
final errors = FormValidationExample.validateRegistrationForm(formData);

if (errors.isNotEmpty) {
  // Handle validation errors
  for (final entry in errors.entries) {
    print('${entry.key}: ${entry.value}');
  }
}
```

### 3. Integration with Existing Registration Screen

```dart
// In your registration screen
Future<void> _submitRegistration() async {
  try {
    // Build form objects from existing form data
    final formObjects = _buildFormObjectsFromExistingData(_formData, userId);
    
    // Create registration request
    final registrationRequest = MemberFormBuilder.buildRegistrationRequest(
      matchingInfo: formObjects.matchPreferences,
      userBasicDetails: formObjects.userBasicForm,
      userContactDetails: formObjects.userContactForm,
      userPersonalDetails: formObjects.personalDetails,
      userFamilyDetails: formObjects.userFamilyDetails,
      userReligiousDetails: formObjects.userReligiousInfo,
      userEducationDetails: formObjects.userEducationDetails,
      userId: userId,
    );
    
    // Submit using new service method
    final response = await memberProvider.createMemberProfile(registrationRequest);
    
    // Handle response
    if (response.isError) {
      // Handle error
    } else {
      // Handle success
    }
  } catch (e) {
    // Handle exception
  }
}
```

## Service Integration

### New Service Method

The `MemberService` now includes a new method:

```dart
Future<ProfileResponse> createMemberProfile(MemberRegistrationRequest registrationRequest)
```

This method:
- Uses the exact same API endpoint
- Handles proper JSON serialization
- Provides detailed error handling
- Matches Angular request structure exactly

## Validation Features

### Built-in Validators

The `MemberRegistrationValidator` class provides validation for:

- **Personal Info**: firstName, lastName, email, phoneNumber
- **Profile Details**: aboutMe, dateOfBirth, height, weight
- **Family Info**: fatherName, motherName, fatherOccupation, motherOccupation
- **Address Info**: street, city, state, country, zipcode

### Validation Rules

- **firstName/lastName**: Required, minimum 2 characters
- **email**: Required, valid email format
- **phoneNumber**: Required, valid phone format (7-15 digits)
- **aboutMe**: Required, 50-500 characters
- **dateOfBirth**: Required, must be 18+ years old, valid date
- **height**: Required, 100-250 cm
- **weight**: Required, 30-200 kg
- **Family fields**: All required, non-empty strings
- **Address fields**: All required, non-empty strings

## Migration Guide

### From Old ProfileRequest Model

1. **Replace imports**:
   ```dart
   // Old
   import 'package:matrimony_flutter/models/profile_request.dart';
   
   // New
   import 'package:matrimony_flutter/models/member_registration_request.dart';
   import 'package:matrimony_flutter/models/member_form_data.dart';
   ```

2. **Update service calls**:
   ```dart
   // Old
   final response = await memberProvider.createProfile(profileRequest);
   
   // New
   final response = await memberProvider.createMemberProfile(registrationRequest);
   ```

3. **Update data building**:
   ```dart
   // Old - manual object creation
   final profileRequest = ProfileRequest(...);
   
   // New - use builder
   final registrationRequest = MemberFormBuilder.buildRegistrationRequest(...);
   ```

### Benefits of New Models

1. **Exact Angular Compatibility**: Matches Angular implementation 100%
2. **Better Validation**: Comprehensive validation with clear error messages
3. **Type Safety**: Proper nullable/non-nullable handling
4. **Maintainability**: Clear structure matching Angular components
5. **Extensibility**: Easy to add new fields or modify existing ones

## Error Handling

The new models provide detailed error handling:

```dart
try {
  final response = await memberProvider.createMemberProfile(registrationRequest);
  
  if (response.isError) {
    // Handle API errors
    print('API Error: ${response.error}');
  } else {
    // Handle success
    print('Profile created: ${response.result?.id}');
  }
} catch (e) {
  // Handle exceptions (network, parsing, etc.)
  print('Exception: $e');
}
```

## Testing

The models include comprehensive validation that can be easily tested:

```dart
// Test validation
final errors = MemberRegistrationValidator.validateFirstName(null);
expect(errors, 'First name is required');

final errors2 = MemberRegistrationValidator.validateEmail('invalid-email');
expect(errors2, 'Please enter a valid email address');
```

## Conclusion

The new member registration models provide a complete, Angular-compatible solution for member registration in the Flutter app. They ensure data consistency, proper validation, and maintainability while matching the Angular implementation exactly.
