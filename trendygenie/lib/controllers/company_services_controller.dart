import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer' as dev;
import '../models/service_item.dart';

class CompanyServicesController extends GetxController {
  final String companyId;
  final RxList<ServiceItem> services = <ServiceItem>[].obs;
  final RxBool hasMore = true.obs;
  final RxBool hasData = false.obs;
  final RxString error = ''.obs;
  late Future<List<ServiceItem>> initialFetch;
  
  int page = 0;
  final int limit = 10;
  bool isLoading = false;

  CompanyServicesController({required this.companyId}) {
    initialFetch = fetchCompanyServices();
  }

  Future<List<ServiceItem>> fetchCompanyServices() async {
    try {
      final data = await Supabase.instance.client
          .from('services')
          .select('''
            id,
            title,
            description,
            normal_price,
            promotional_price,
            rating,
            status,
            provider_id,
            business_id,
            company_id,
            images,
            distance,
            view_count,
            bedroom_count,
            bathroom_count,
            has_kitchen,
            property_type,
            cuisine,
            is_delivery_available,
            food_category,
            caracteristics,
            category:category_id(
              id,
              name
            ),
            business:business_id(
              id,
              name,
              description,
              logo_url,
              address,
              contact_email,
              contact_phone,
              status,
              rating,
              category:category_id(
                id,
                name
              )
            )
          ''')
          .eq('company_id', companyId)
          .order('rating', ascending: false)
          .range(page * limit, (page + 1) * limit - 1);

      try {
        final List<ServiceItem> newServices = (data as List)
            .map((json) => ServiceItem.fromJson(json))
            .toList();

        if (page == 0) {
          services.value = newServices;
        } else {
          services.addAll(newServices);
        }
        
        dev.log('newServices: ${newServices.length}', name: 'CompanyServicesController');
        dev.log('companyId: $companyId', name: 'CompanyServicesController');

        hasMore.value = newServices.length >= limit;
        hasData.value = true;
        return newServices;
      } catch (e) {
        dev.log('Error parsing services: $e', name: 'CompanyServicesController');
        error.value = 'Failed to parse services: $e';
        return [];
      }
    } catch (e) {
      dev.log('Error fetching services: $e', name: 'CompanyServicesController');
      error.value = 'Failed to fetch services: $e';
      return [];
    }
  }

  void loadMore() {
    if (hasMore.value && !isLoading) {
      isLoading = true;
      page++;
      fetchCompanyServices().then((_) {
        isLoading = false;
      });
    }
  }
} 