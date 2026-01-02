import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'category_model.dart';
import 'enums.dart';

class BusinessModel {
  final String? id;
  final String name;
  final String description;
  final String? logoUrl;
  final String address;
  final String contactEmail;
  final List<dynamic> contactPhone;
  final String companyId;
  final String? categoryId;
  final String? subcategoryId;
  final CategoryModel? category;
  final CategoryModel? subcategory;
  final BusinessStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double rating;
  final List<String> businessHours;
  final double? latitude;
  final double? longitude;
  final String currency;

  BusinessModel({
    this.id,
    required this.name,
    required this.description,
    this.logoUrl,
    required this.address,
    required this.contactEmail,
    required this.contactPhone,
    required this.companyId,
    this.categoryId,
    this.subcategoryId,
    this.category,
    this.subcategory,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.rating = 0.0,
    this.businessHours = const [],
    this.latitude,
    this.longitude,
    this.currency = 'NGN',
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      logoUrl: json['logo_url'],
      address: json['address'] ?? '',
      contactEmail: json['contact_email'] ?? '',
      contactPhone: json['contact_phone'] ?? [],
      companyId: json['company_id'] ?? '',
      categoryId: json['category_id'],
      subcategoryId: json['subcategory_id'],
      category: json['category'] != null 
          ? CategoryModel.fromJson(json['category'] as Map<String, dynamic>) 
          : null,
      subcategory: json['subcategory'] != null 
          ? CategoryModel.fromJson(json['subcategory'] as Map<String, dynamic>) 
          : null,
      status: _parseBusinessStatus(json['status']),
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      businessHours: (json['business_hours'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      currency: json['currency'] ?? 'NGN',
    );
  }

  static BusinessStatus _parseBusinessStatus(String? status) {
    if (status == null) return BusinessStatus.pending;
    
    switch (status) {
      case 'active':
        return BusinessStatus.active;
      case 'rejected':
        return BusinessStatus.rejected;
      case 'suspended':
        return BusinessStatus.suspended;
      case 'removed':
        return BusinessStatus.removed;
      case 'deleted':
        return BusinessStatus.deleted;
      default:
        return BusinessStatus.pending;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'logo_url': logoUrl,
      'address': address,
      'contact_email': contactEmail,
      'contact_phone': contactPhone.map((e) => e.toString()).toList(),
      'company_id': companyId,
      'category_id': categoryId,
      'subcategory_id': subcategoryId,
      'status': status.toString().split('.').last,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'rating': rating,
      'business_hours': businessHours,
      'latitude': latitude,
      'longitude': longitude,
      'currency': currency,
    };
  }

  BusinessModel copyWith(BusinessModel businessModel, {
    String? id,
    String? name,
    String? description,
    String? logoUrl,
    String? address,
    String? contactEmail,
    List<String>? contactPhone,
    String? companyId,
    String? categoryId,
    String? subcategoryId,
    CategoryModel? category,
    CategoryModel? subcategory,
    BusinessStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? rating,
    List<String>? businessHours,
    double? latitude,
    double? longitude,
    String? currency,
  }) {
    return BusinessModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      logoUrl: logoUrl ?? this.logoUrl,
      address: address ?? this.address,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      companyId: companyId ?? this.companyId,
      categoryId: categoryId ?? this.categoryId,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rating: rating ?? this.rating,
      businessHours: businessHours ?? this.businessHours,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      currency: currency ?? this.currency,
    );
  }

  // Helper method to get color based on status
  static Color getStatusColor(BusinessStatus status) {
    switch (status) {
      case BusinessStatus.pending:
        return Colors.amber; // Yellow
      case BusinessStatus.active:
        return const Color(0xFF16C79A); // Green (firstColor)
      case BusinessStatus.rejected:
        return const Color(0xFFDC2743); // Red (redColor)
      case BusinessStatus.suspended:
        return const Color(0xFFe06929); // Orange (secondColor)
      case BusinessStatus.removed:
        return Colors.grey; // Gray
      case BusinessStatus.deleted:
        return Colors.grey.shade800; // Dark Gray
      default:
        return Colors.grey;
    }
  }
} 