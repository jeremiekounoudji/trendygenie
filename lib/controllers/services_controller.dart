import 'dart:developer';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/service_item.dart';

class ServicesController extends GetxController {
  final supabase = Supabase.instance.client;
  final RxList<ServiceItem> services = <ServiceItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxList<ServiceItem> restaurantServices = <ServiceItem>[].obs;
  final RxBool hasMoreRestaurants = true.obs;
  final RxInt restaurantPage = 1.obs;
  final int limit = 10;

  // services map
  final RxMap<String, List<ServiceItem>> servicesMap =
      <String, List<ServiceItem>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // fetchServices();
  }

  // Future<bool> fetchServices() async {
  //   try {
  //     isLoading.value = true;
  //     error.value = '';

  //     final response = await supabase
  //         .from('services')
  //         .select()
  //         .execute();

  //     if (response.status != 200) {
  //       throw 'Error: Status ${response.status}';
  //     }

  //     services.value = (response.data as List)
  //         .map((json) => ServiceItem.fromJson(json))
  //         .toList();

  //     isLoading.value = false;
  //     return true;
  //   } catch (e) {
  //     isLoading.value = false;
  //     error.value = 'Failed to fetch services: $e';
  //     return false;
  //   }
  // }

  Future<bool> addService(ServiceItem service) async {
    try {
      isLoading.value = true;
      error.value = '';

      final response =
          await supabase.from('services').insert(service.toJson()).execute();

      if (response.status != 201) {
        throw 'Error: Status ${response.status}';
      }

      services.add(service);
      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      error.value = 'Failed to add service: $e';
      return false;
    }
  }

  Future<bool> updateService(ServiceItem service) async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await supabase
          .from('services')
          .update(service.toJson())
          .eq('id', service.id)
          .execute();

      if (response.status != 200) {
        throw 'Error: Status ${response.status}';
      }

      final index = services.indexWhere((element) => element.id == service.id);
      if (index != -1) {
        services[index] = service;
      }

      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      error.value = 'Failed to update service: $e';
      return false;
    }
  }

  Future<bool> deleteService(String serviceId) async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await supabase
          .from('services')
          .delete()
          .eq('id', serviceId)
          .execute();

      if (response.status != 200) {
        throw 'Error: Status ${response.status}';
      }

      services.removeWhere((element) => element.id == serviceId);

      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      error.value = 'Failed to delete service: $e';
      return false;
    }
  }

  Future<bool> fetchServices(String? categoryId, String? parentCategoryId,
      {bool loadMore = false}) async {
    await Future.delayed(const Duration(seconds: 5));
    try {
      if (!loadMore) {
        restaurantPage.value = 1;
        servicesMap[parentCategoryId ?? ''] = [];
      }

      if (!hasMoreRestaurants.value && loadMore) {
        return true;
      }

      isLoading.value = true;
      error.value = '';

      final from = (restaurantPage.value - 1) * limit;
      final to = from + limit - 1;

      final query = supabase.from('services').select('''
      *,
      category:subcategories (
        *,
        parent_category_id:categories (*)
      )
    ''');

      // Filter by subcategory ID if provided
      if (categoryId != null && categoryId.isNotEmpty) {
        query.eq('category_id', categoryId);
      }

      // Filter by parent category ID if provided
      if (parentCategoryId != null && parentCategoryId.isNotEmpty) {
        query.eq('category.parent_category_id', parentCategoryId);
      }

      query.range(from, to).order('created_at', ascending: false);

      final response = await query.execute();

      if (response.status != 200) {
        throw 'Error: Status ${response.status}';
      }

      log(response.data.toString());
      log(parentCategoryId.toString());
      final newServices = (response.data as List)
          .map((json) => ServiceItem.fromJson(json))
          .toList();
      servicesMap[parentCategoryId ?? '']?.addAll(newServices);

      hasMoreRestaurants.value = newServices.length >= limit;
      if (hasMoreRestaurants.value) {
        restaurantPage.value++;
      }

      isLoading.value = false;
      return true;
    } catch (e) {
      log('Error fetching services: $e');
      isLoading.value = false;
      error.value = 'Failed to fetch services: $e';
      return false;
    }
  }


  //
  

  List<ServiceItem> get categoryOneServices =>
      servicesMap['category_one'] ?? [];
  List<ServiceItem> get accomodationServices =>
      servicesMap['accommodation'] ?? [];
  List<ServiceItem> get topServices => servicesMap['top'] ?? [];
  List<ServiceItem> get nearServices => servicesMap['near'] ?? [];
  List<ServiceItem> get popularServices => servicesMap['popular'] ?? [];
  
  // Fetch services for a specific business with pagination
  Future<bool> fetchServicesForBusiness(String businessId, int page, int limit) async {
    try {
      isLoading.value = true;
      error.value = '';

      final from = page * limit;
      final to = from + limit - 1;

      final response = await supabase
          .from('services')
          .select('''
            *,
            category:subcategories (
              *,
              parent_category_id:categories (*)
            )
          ''')
          .eq('business_id', businessId)
          .range(from, to)
          .order('created_at', ascending: false)
          .execute();

      if (response.status != 200) {
        throw 'Error: Status ${response.status}';
      }

      if (page == 0) {
        services.value = (response.data as List)
            .map((json) => ServiceItem.fromJson(json))
            .toList();
      } else {
        final newServices = (response.data as List)
            .map((json) => ServiceItem.fromJson(json))
            .toList();
        services.addAll(newServices);
      }

      isLoading.value = false;
      return true;
    } catch (e) {
      log('Error fetching business services: $e');
      isLoading.value = false;
      error.value = 'Failed to fetch business services: $e';
      return false;
    }
  }
}
