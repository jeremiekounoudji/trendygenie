import 'package:get/get.dart';
import 'category_model.dart';

enum CompanyStatus {
  pending,
  approved,
  rejected,
  suspended
}

class CompanyModel {
  final String? id;
  final String name;
  final String registrationNumber;
  final String address;
  final CategoryModel? category;
  final String? categoryId;
  final String ownerId;
  final CompanyStatus status;
  final DateTime createdAt;
  final DateTime? approvedAt;
  
  // Documents and verification
  final String? companyLogo;
  final String? ownerIdImage;
  final String? selfieImage;
  final bool isVerified;
  
  // Business details
  final String? description;
  final String? website;
  final String? email;
  final String? phone;
  final List<String>? businessHours;
  
  // Location
  final double? latitude;
  final double? longitude;
  final String? city;
  final String? country;
  final String? postalCode;

  // Statistics
  final int totalOrders;
  final double rating;
  final int reviewCount;
  
  CompanyModel({
    this.id,
    required this.name,
    required this.registrationNumber,
    required this.address,
    this.category,
    this.categoryId,
    required this.ownerId,
    required this.status,
    required this.createdAt,
    this.approvedAt,
    this.companyLogo,
    this.ownerIdImage,
    this.selfieImage,
    this.isVerified = false,
    this.description,
    this.website,
    this.email,
    this.phone,
    this.businessHours,
    this.latitude,
    this.longitude,
    this.city,
    this.country,
    this.postalCode,
    this.totalOrders = 0,
    this.rating = 0.0,
    this.reviewCount = 0,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      registrationNumber: json['registration_number'] ?? '',
      address: json['address'] ?? '',
      category: json['category'] is Map 
          ? CategoryModel.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      ownerId: json['owner_id'] ?? '',
      status: CompanyStatus.values.firstWhere(
        (e) => e.toString() == 'CompanyStatus.${json['status'] ?? 'pending'}',
        orElse: () => CompanyStatus.pending,
      ),
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      approvedAt: json['approved_at'] != null 
          ? DateTime.parse(json['approved_at']) 
          : null,
      companyLogo: json['company_logo'],
      ownerIdImage: json['owner_id_image'],
      selfieImage: json['selfie_image'],
      isVerified: json['is_verified'] ?? false,
      description: json['description'],
      website: json['website'],
      email: json['email'],
      phone: json['phone'],
      businessHours: json['business_hours'] != null 
          ? List<String>.from(json['business_hours'])
          : null,
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      city: json['city'],
      country: json['country'],
      postalCode: json['postal_code'],
      totalOrders: json['total_orders'] ?? 0,
      rating: json['rating']?.toDouble() ?? 0.0,
      reviewCount: json['review_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'registration_number': registrationNumber,
      'address': address,
      'category': categoryId,
      'owner_id': ownerId,
      'status': status.toString().split('.').last,
      'created_at': createdAt.toIso8601String(),
      'approved_at': approvedAt?.toIso8601String(),
      'company_logo': companyLogo,
      'owner_id_image': ownerIdImage,
      'selfie_image': selfieImage,
      'is_verified': isVerified,
      'description': description,
      'website': website,
      'email': email,
      'phone': phone,
      'business_hours': businessHours,
      'latitude': latitude,
      'longitude': longitude,
      'city': city,
      'country': country,
      'postal_code': postalCode,
      'total_orders': totalOrders,
      'rating': rating,
      'review_count': reviewCount,
    };
  }

  CompanyModel copyWith({
    String? id,
    String? name,
    String? registrationNumber,
    String? address,
    CategoryModel? category,
    String? categoryId,
    String? ownerId,
    CompanyStatus? status,
    DateTime? createdAt,
    DateTime? approvedAt,
    String? companyLogo,
    String? ownerIdImage,
    String? selfieImage,
    bool? isVerified,
    String? description,
    String? website,
    String? email,
    String? phone,
    List<String>? businessHours,
    double? latitude,
    double? longitude,
    String? city,
    String? country,
    String? postalCode,
    int? totalOrders,
    double? rating,
    int? reviewCount,
  }) {
    return CompanyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      address: address ?? this.address,
      category: category ?? this.category,
      ownerId: ownerId ?? this.ownerId,
      categoryId: categoryId ?? this.categoryId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      approvedAt: approvedAt ?? this.approvedAt,
      companyLogo: companyLogo ?? this.companyLogo,
      ownerIdImage: ownerIdImage ?? this.ownerIdImage,
      selfieImage: selfieImage ?? this.selfieImage,
      isVerified: isVerified ?? this.isVerified,
      description: description ?? this.description,
      website: website ?? this.website,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      businessHours: businessHours ?? this.businessHours,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      city: city ?? this.city,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      totalOrders: totalOrders ?? this.totalOrders,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }
} 