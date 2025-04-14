import 'enums.dart';

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? profileImage;
  final String userType; // This stays as string for database compatibility
  final DateTime createdAt;
  final bool isActive;
  
  // User preferences and settings (now as a related entity)
  final UserPreferences? preferences;
  
  // Authentication related
  final bool isEmailVerified;
  final bool isPhoneVerified;
  
  // Location data (now as a related entity)
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
    this.preferences,
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
      preferences: null, // Will be loaded separately from user_preferences table
      isEmailVerified: json['is_email_verified'] ?? false,
      isPhoneVerified: json['is_phone_verified'] ?? false,
      location: null, // Will be loaded separately from user_locations table
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'profile_image': profileImage,
      'user_type': userType,
      'created_at': createdAt.toIso8601String(),
      'is_active': isActive,
      'is_email_verified': isEmailVerified,
      'is_phone_verified': isPhoneVerified,
    };

    return data;
  }
}

class UserPreferences {
  final String? id;
  String? userId;
  final String language;
  final String currency;
  final bool pushNotifications;
  final bool emailNotifications;
  final bool smsNotifications;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserPreferences({
    this.id,
    this.userId,
    this.language = 'en',
    this.currency = 'USD',
    this.pushNotifications = true,
    this.emailNotifications = true,
    this.smsNotifications = true,
    this.createdAt,
    this.updatedAt,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      id: json['id'],
      userId: json['user_id'],
      language: json['language'] ?? 'en',
      currency: json['currency'] ?? 'USD',
      pushNotifications: json['push_notifications'] ?? true,
      emailNotifications: json['email_notifications'] ?? true,
      smsNotifications: json['sms_notifications'] ?? true,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'language': language,
      'currency': currency,
      'push_notifications': pushNotifications,
      'email_notifications': emailNotifications,
      'sms_notifications': smsNotifications,
    };
    
    // Only include id if it exists
    if (id != null) {
      data['id'] = id;
    }
    
    // userId will be added in controller
    return data;
  }
}

class UserLocation {
  final String? id;
  String? userId;
  final double? latitude;
  final double? longitude;
  final String? address;
  final String? city;
  final String? country;
  final String? postalCode;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserLocation({
    this.id,
    this.userId,
    this.latitude,
    this.longitude,
    this.address,
    this.city,
    this.country,
    this.postalCode,
    this.createdAt,
    this.updatedAt,
  });

  factory UserLocation.fromJson(Map<String, dynamic> json) {
    return UserLocation(
      id: json['id'],
      userId: json['user_id'],
      latitude: json['latitude'] != null ? double.parse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.parse(json['longitude'].toString()) : null,
      address: json['address'],
      city: json['city'],
      country: json['country'],
      postalCode: json['postal_code'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    
    // Only include fields that are not null
    if (id != null) data['id'] = id;
    if (latitude != null) data['latitude'] = latitude;
    if (longitude != null) data['longitude'] = longitude;
    if (address != null) data['address'] = address;
    if (city != null) data['city'] = city;
    if (country != null) data['country'] = country;
    if (postalCode != null) data['postal_code'] = postalCode;
    
    // userId will be added in controller
    return data;
  }
} 