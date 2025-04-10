import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/service_item.dart';
import '../services/supabase_service.dart';

class CompanyServicesController extends GetxController {
  final String companyId;
  final RxList<ServiceItem> services = <ServiceItem>[].obs;
  final RxBool hasMore = true.obs;
  final RxBool hasData = false.obs;
  late Future<List<ServiceItem>> initialFetch;
  
  int page = 0;
  final int limit = 10;
  bool isLoading = false;

  CompanyServicesController({required this.companyId}) {
    initialFetch = fetchCompanyServices();
  }

  Future<List<ServiceItem>> fetchCompanyServices() async {
    try {
      final response = await Supabase.instance.client
          .from('services')
          .select('''
            id,
            title,
            description,
            price,
            rating,
            provider_id,
            subcategory:subcategories!inner(
              id,
              name,
              category:categories!parent_category_id(
                id,
                name
              )
            )
          ''')
          .eq('provider_id', companyId)
          .order('rating', ascending: false)
          .range(page * limit, (page + 1) * limit - 1)
          .execute();

      final List<ServiceItem> newServices = (response.data as List)
          .map((json) => ServiceItem.fromJson(json))
          .toList();

      if (page == 0) {
        services.value = newServices;
      } else {
        services.addAll(newServices);
      }
      print('newServices: ${newServices.length}');
      print('companyId: ${newServices.length}');


      hasMore.value = newServices.length >= limit;
      hasData.value = true;
      return newServices;
    } catch (e) {
      print('Error fetching services: $e');
      return [];
    }
  }

  Future<void> loadMore() async {
    if (!hasMore.value || isLoading) return;
    
    isLoading = true;
    page++;
    await fetchCompanyServices();
    isLoading = false;
  }
} 