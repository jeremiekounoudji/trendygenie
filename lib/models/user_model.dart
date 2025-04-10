class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? profileImage;
  final String userType; // 'customer' or 'provider'
  final DateTime createdAt;
  final bool isActive;
  
  // Provider specific fields
  // final ProviderDetails? providerDetails;
  
  // User preferences and settings
  final UserPreferences preferences;
  
  // Authentication related
  final bool isEmailVerified;
  final bool isPhoneVerified;
  
  // Location data
  final UserLocation? location;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.profileImage,
    required this.userType,
    required this.createdAt,
    required this.isActive,
    // this.providerDetails,
    required this.preferences,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    this.location,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      profileImage: json['profile_image'],
      userType: json['user_type'] ?? 'customer',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      isActive: json['is_active'] ?? true,
      // providerDetails: json['provider_details'] != null 
      //     ? ProviderDetails.fromJson(json['provider_details'])
      //     : null,
      preferences: json['preferences'] != null 
          ? UserPreferences.fromJson(json['preferences'])
          : UserPreferences(),
      isEmailVerified: json['is_email_verified'] ?? false,
      isPhoneVerified: json['is_phone_verified'] ?? false,
      location: json['location'] != null 
          ? UserLocation.fromJson(json['location'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'profile_image': profileImage,
      'user_type': userType,
      'created_at': createdAt.toIso8601String(),
      'is_active': isActive,
      // 'provider_details': providerDetails?.toJson(),
      'preferences': preferences.toJson(),
      'is_email_verified': isEmailVerified,
      'is_phone_verified': isPhoneVerified,
      'location': location?.toJson(),
    };
  }
}

class ProviderDetails {
  final String businessName;
  final String businessDescription;
  final List<String> serviceCategories;
  final List<String> serviceAreas;
  final String? businessLicense;
  final List<String>? certificates;
  final double? rating;
  final int? completedServices;

  ProviderDetails({
    required this.businessName,
    required this.businessDescription,
    required this.serviceCategories,
    required this.serviceAreas,
    this.businessLicense,
    this.certificates,
    this.rating,
    this.completedServices,
  });

  factory ProviderDetails.fromJson(Map<String, dynamic> json) {
    return ProviderDetails(
      businessName: json['business_name'] ?? '',
      businessDescription: json['business_description'] ?? '',
      serviceCategories: List<String>.from(json['service_categories'] ?? []),
      serviceAreas: List<String>.from(json['service_areas'] ?? []),
      businessLicense: json['business_license'],
      certificates: json['certificates'] != null 
          ? List<String>.from(json['certificates'])
          : null,
      rating: json['rating']?.toDouble(),
      completedServices: json['completed_services'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'businessName': businessName,
      'business_description': businessDescription,
      'service_categories': serviceCategories,
      'service_areas': serviceAreas,
      'business_license': businessLicense,
      'certificates': certificates,
      'rating': rating,
      'completed_services': completedServices,
    };
  }
}

class UserPreferences {
  final String? language;
  final String? currency;
  final bool pushNotifications;
  final bool emailNotifications;
  final bool smsNotifications;

  UserPreferences({
    this.language = 'en',
    this.currency = 'USD',
    this.pushNotifications = true,
    this.emailNotifications = true,
    this.smsNotifications = true,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      language: json['language'] ?? 'en',
      currency: json['currency'] ?? 'USD',
      pushNotifications: json['push_notifications'] ?? true,
      emailNotifications: json['email_notifications'] ?? true,
      smsNotifications: json['sms_notifications'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'currency': currency,
      'push_notifications': pushNotifications,
      'email_notifications': emailNotifications,
      'sms_notifications': smsNotifications,
    };
  }
}

class UserLocation {
  final double latitude;
  final double longitude;
  final String address;
  final String? city;
  final String? country;
  final String? postalCode;

  UserLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
    this.city,
    this.country,
    this.postalCode,
  });

  factory UserLocation.fromJson(Map<String, dynamic> json) {
    return UserLocation(
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      address: json['address'] ?? '',
      city: json['city'],
      country: json['country'],
      postalCode: json['postal_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'city': city,
      'country': country,
      'postal_code': postalCode,
    };
  }
} 