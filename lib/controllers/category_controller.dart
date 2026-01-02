import 'dart:developer';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category_model.dart';

class CategoryController extends GetxController {
  final supabase = Supabase.instance.client;
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<bool> fetchCategories() async {
    if (categories.isNotEmpty) return true;
    try {
      isLoading.value = true;
      error.value = '';
      
      final data = await supabase
          .from('categories')
          .select('''
            *,
            subcategories(*)
          ''');
      
      log(data.toString());
      categories.value = (data as List)
          .map((json) => CategoryModel.fromJson(json))
          .toList();
      
      isLoading.value = false;
      return true;
    } catch (e) {
      log(e.toString());
      isLoading.value = false;
      error.value = 'Failed to fetch categories: $e';
      return false;
    }
  }

  // Fetch all subcategories
  RxList<SubCategoryModel> subCategories = <SubCategoryModel>[].obs;
  
  Future<bool> fetchSubCategories() async {
    try {
      isLoading.value = true;
      error.value = '';
      
      // If we already have categories with subcategories, extract them
      if (categories.isNotEmpty) {
        subCategories.clear();
        for (var category in categories) {
          subCategories.addAll(category.subCategories);
        }
        isLoading.value = false;
        return true;
      }
      
      // Otherwise fetch them directly from the database
      final data = await supabase
          .from('subcategories')
          .select('''
            *,
            parent_category_id:categories(*)
          ''');
      
      subCategories.value = (data as List)
          .map((json) => SubCategoryModel.fromJson(json))
          .toList();
      
      isLoading.value = false;
      return true;
    } catch (e) {
      log(e.toString());
      isLoading.value = false;
      error.value = 'Failed to fetch subcategories: $e';
      return false;
    }
  }

  Future<bool> addCategory(String name, String? description) async {
    try {
      isLoading.value = true;
      error.value = '';

      final data = await supabase
          .from('categories')
          .insert({
            'name': name,
            'description': description,
            'created_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      final newCategory = CategoryModel(
        id: data['id'],
        name: name,
        description: description,
      );

      categories.add(newCategory);
      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      error.value = 'Failed to add category: $e';
      return false;
    }
  }

  Future<bool> updateCategory(CategoryModel category) async {
    try {
      isLoading.value = true;
      error.value = '';

      if (category.id == null) {
        throw 'Category ID is null';
      }

      await supabase
          .from('categories')
          .update({
            'name': category.name,
            'description': category.description,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', category.id!);

      final index = categories.indexWhere((element) => element.id == category.id);
      if (index != -1) {
        categories[index] = category;
      }

      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      error.value = 'Failed to update category: $e';
      return false;
    }
  }

  Future<bool> deleteCategory(String categoryId) async {
    try {
      isLoading.value = true;
      error.value = '';

      await supabase
          .from('categories')
          .delete()
          .eq('id', categoryId);
      
      categories.removeWhere((element) => element.id == categoryId);
      
      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      error.value = 'Failed to delete category: $e';
      return false;
    }
  }

  Future<bool> addSubCategory(String categoryId, SubCategoryModel subCategory) async {
    try {
      isLoading.value = true;
      error.value = '';

      await supabase
          .from('subcategories')
          .insert({
            'name': subCategory.name,
            'description': subCategory.description,
            'parent_category_id': categoryId,
            'created_at': DateTime.now().toIso8601String(),
          });

      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      error.value = 'Failed to add subcategory: $e';
      return false;
    }
  }

  Future<bool> deleteSubCategory(String categoryId, String subCategoryId) async {
    try {
      isLoading.value = true;
      error.value = '';

      await supabase
          .from('subcategories')
          .delete()
          .eq('id', subCategoryId);

      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      error.value = 'Failed to delete subcategory: $e';
      return false;
    }
  }
} 