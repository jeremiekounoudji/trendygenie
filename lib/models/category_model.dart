import 'package:get/get.dart';

class CategoryModel {
  final String id;
  final String name;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isActive;
  final List<SubCategoryModel> subCategories;

  CategoryModel({
    required this.id,
    required this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.isActive,
    this.subCategories = const [],
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
      isActive: json['is_active'],
      subCategories: json['sub_categories'] != null
          ? (json['sub_categories'] as List).map((subCat) => SubCategoryModel.fromJson(subCat)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'is_active': isActive,
      'sub_categories': subCategories.map((subCat) => subCat.toJson()).toList(),
    };
  }
}

class SubCategoryModel {
  final String id;
  final String name;
  final String? description;
  final String parentCategoryId;
  final CategoryModel? parentCategory;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isActive;

  SubCategoryModel({
    required this.id,
    required this.name,
    this.description,
    required this.parentCategoryId,
    this.parentCategory,
    this.createdAt,
    this.updatedAt,
    this.isActive,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      parentCategoryId: json['parent_category_id'] is Map 
          ? json['parent_category_id']['id'] 
          : json['parent_category_id'] ?? '',
      parentCategory: json['parent_category_id'] is Map 
          ? CategoryModel.fromJson(json['parent_category_id'])
          : null,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
      isActive: json['is_active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'parent_category_id': parentCategoryId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'is_active': isActive,
    };
  }
} 