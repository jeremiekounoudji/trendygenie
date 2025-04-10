import 'category_model.dart';

class ServiceItem {
  final String id;
  final String title;
  final String description;
  final SubCategoryModel category;
  final String image;
  final double price;
  final double rating;
  final double distance;
  
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
  final DateTime? createdAt;
  final String? createdBy;
  final bool? isActive;
  final int? viewCount;
  final Map<String, dynamic>? metadata;

  ServiceItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.image,
    required this.price,
    required this.rating,
    required this.distance,
    // Accommodation fields
    this.bedroomCount,
    this.bathroomCount,
    this.hasKitchen,
    this.propertyType,
    // Food fields
    this.cuisine,
    this.isDeliveryAvailable,
    this.foodCategory,
    this.caracteristics,
    required this.providerId,
    this.createdAt,
    this.createdBy,
    this.isActive,
    this.viewCount,
    this.metadata,
  });

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: SubCategoryModel.fromJson(json['category'] ?? {}),
      image: json['image'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      rating: (json['rating'] ?? 0.0).toDouble(),
      distance: (json['distance'] ?? 0.0).toDouble(),
      // Accommodation fields
      bedroomCount: json['bedroom_count'],
      bathroomCount: json['bathroom_count'],
      hasKitchen: json['has_kitchen'],
      propertyType: json['property_type'],
      // Food fields
      cuisine: json['cuisine'],
      isDeliveryAvailable: json['is_delivery_available'],
      foodCategory: json['food_category'],
      caracteristics: json['dietary_options'] != null 
          ? List<String>.from(json['dietary_options'])
          : null,
      providerId: json['provider_id'] ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'])
          : null,
      createdBy: json['created_by'],
      isActive: json['is_active'],
      viewCount: json['view_count'],
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category.toJson(),
      'image': image,
      'price': price,
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
      'dietary_options': caracteristics,
      'provider_id': providerId,
      'created_at': createdAt?.toIso8601String(),
      'created_by': createdBy,
      'is_active': isActive,
      'view_count': viewCount,
      'metadata': metadata,
    };
  }

  ServiceItem copyWith({
    String? id,
    String? title,
    String? description,
    SubCategoryModel? category,
    String? image,
    double? price,
    double? rating,
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
    DateTime? createdAt,
    String? createdBy,
    bool? isActive,
    int? viewCount,
    Map<String, dynamic>? metadata,
  }) {
    return ServiceItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      image: image ?? this.image,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      distance: distance ?? this.distance,
      bedroomCount: bedroomCount ?? this.bedroomCount,
      bathroomCount: bathroomCount ?? this.bathroomCount,
      hasKitchen: hasKitchen ?? this.hasKitchen,
      propertyType: propertyType ?? this.propertyType,
      cuisine: cuisine ?? this.cuisine,
      isDeliveryAvailable: isDeliveryAvailable ?? this.isDeliveryAvailable,
      foodCategory: foodCategory ?? this.foodCategory,
      caracteristics: dietaryOptions ?? this.caracteristics,
      providerId: providerId ?? this.providerId,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      isActive: isActive ?? this.isActive,
      viewCount: viewCount ?? this.viewCount,
      metadata: metadata ?? this.metadata,
    );
  }
}
     