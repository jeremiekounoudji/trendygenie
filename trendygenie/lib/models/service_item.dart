import 'category_model.dart';
import 'business_model.dart';

class ServiceItem {
   String? id;
  final String title;
  final String description;
  final CategoryModel category;
  final String? categoryId;
  final List<String> images;
  final double normalPrice;
  final double promotionalPrice;
  final double rating;
  final double distance;
   String? status;
  
  // New fields for accommodation
  final int? bedroomCount;
  final int? bathroomCount;
  final bool? hasKitchen;
  final String? propertyType;
  
  // New fields for food
  final String? cuisine;
  final bool? isDeliveryAvailable;
  final String? foodCategory;
  final List<String>? caracteristics;

  final String providerId;
  final String? businessId;
  final BusinessModel? business;
  final String? companyId;
  final DateTime? createdAt;
  final String? createdBy;
  final bool? isActive;
  final int viewCount;
  final Map<String, dynamic>? metadata;
  final String currency;

  ServiceItem({
     this.id,
    required this.title,
    required this.description,
    required this.category,
    this.categoryId,
    required this.images,
    required this.normalPrice,
    required this.promotionalPrice,
    required this.rating,
    required this.distance,
    // Accommodation fields
    this.bedroomCount,
    this.bathroomCount,
    this.hasKitchen,
    this.propertyType,
    this.status,
    // Food fields
    this.cuisine,
    this.isDeliveryAvailable,
    this.foodCategory,
    this.caracteristics,
    required this.providerId,
    this.businessId,
    this.business,
    this.companyId,
    this.createdAt,
    this.createdBy,
    this.isActive,
    this.viewCount = 0,
    this.metadata,
    this.currency = 'NGN',
  });

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: CategoryModel.fromJson(json['category'] ?? {}),
      categoryId: json['category_id'],
      images: json['images'] != null 
          ? List<String>.from(json['images'].where((img) => img != null))
          : [],
      normalPrice: (json['normal_price'] ?? 0.0).toDouble(),
      promotionalPrice: (json['promotional_price'] ?? 0.0).toDouble(),
      rating: (json['rating'] ?? 0.0).toDouble(),
      distance: (json['distance'] ?? 0.0).toDouble(),
      // Accommodation fields
      bedroomCount: json['bedroom_count'],
      bathroomCount: json['bathroom_count'],
      hasKitchen: json['has_kitchen'],
      propertyType: json['property_type'],
      status: json['status'],
      // Food fields
      cuisine: json['cuisine'],
      isDeliveryAvailable: json['is_delivery_available'],
      foodCategory: json['food_category'],
      caracteristics: json['caracteristics'] != null 
          ? List<String>.from(json['caracteristics'].where((c) => c != null))
          : null,
      providerId: json['provider_id'] ?? '',
      businessId: json['business_id'],
      business: json['business'] != null 
          ? BusinessModel.fromJson(json['business'])
          : null,
      companyId: json['company_id'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'])
          : null,
      createdBy: json['created_by'],
      isActive: json['is_active'],
      viewCount: json['view_count'] ?? 0,
      metadata: json['metadata'],
      currency: json['currency'] ?? 'NGN',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category_id': categoryId ?? category.id,
      'images': images,
      'normal_price': normalPrice,
      'promotional_price': promotionalPrice,
      'rating': rating,
      'distance': distance,
      // Accommodation fields
      'bedroom_count': bedroomCount,
      'bathroom_count': bathroomCount,
      'has_kitchen': hasKitchen,
      'property_type': propertyType,
      // Food fields
      'cuisine': cuisine,
      'is_delivery_available': isDeliveryAvailable,
      'food_category': foodCategory,
      'caracteristics': caracteristics,
      'provider_id': providerId,
      'business_id': businessId,
      'company_id': companyId,
      'created_at': createdAt?.toIso8601String(),
      'created_by': createdBy,
      'is_active': isActive,
      'view_count': viewCount,
      'metadata': metadata,
      'status': status,
      'currency': currency,
    };
  }

  ServiceItem copyWith({
    String? id,
    String? title,
    String? description,
    CategoryModel? category,
    String? categoryId,
    List<String>? images,
    double? normalPrice,
    double? promotionalPrice,
    double? rating,
    String? status,
    double? distance,
    int? bedroomCount,
    int? bathroomCount,
    bool? hasKitchen,
    String? propertyType,
    String? cuisine,
    bool? isDeliveryAvailable,
    String? foodCategory,
    List<String>? dietaryOptions,
    String? providerId,
    String? businessId,
    BusinessModel? business,
    String? companyId,
    DateTime? createdAt,
    String? createdBy,
    bool? isActive,
    int? viewCount,
    Map<String, dynamic>? metadata,
    String? currency,
  }) {
    return ServiceItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      categoryId: categoryId ?? this.categoryId,
      images: images ?? this.images,
      normalPrice: normalPrice ?? this.normalPrice,
      promotionalPrice: promotionalPrice ?? this.promotionalPrice,
      rating: rating ?? this.rating,
      distance: distance ?? this.distance,
      status: status ?? this.status,
      bedroomCount: bedroomCount ?? this.bedroomCount,
      bathroomCount: bathroomCount ?? this.bathroomCount,
      hasKitchen: hasKitchen ?? this.hasKitchen,
      propertyType: propertyType ?? this.propertyType,
      cuisine: cuisine ?? this.cuisine,
      isDeliveryAvailable: isDeliveryAvailable ?? this.isDeliveryAvailable,
      foodCategory: foodCategory ?? this.foodCategory,
      caracteristics: dietaryOptions ?? caracteristics,
      providerId: providerId ?? this.providerId,
      businessId: businessId ?? this.businessId,
      business: business ?? this.business,
      companyId: companyId ?? this.companyId,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      isActive: isActive ?? this.isActive,
      viewCount: viewCount ?? this.viewCount,
      metadata: metadata ?? this.metadata,
      currency: currency ?? this.currency,
    );
  }
}
     