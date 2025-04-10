import 'package:get/get.dart';
import '../models/company_model.dart';
import 'company_controller.dart';

class RecentPlacesController extends GetxController {
  final RxList<CompanyModel> companies = <CompanyModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasMore = true.obs;
  
  int page = 0;
  final int limit = 10;

  final CompanyController companyController = Get.find<CompanyController>();

  @override
  void onInit() {
    super.onInit();
    fetchRecentHotels();
  }

  Future<bool> fetchRecentHotels({bool loadMore = false}) async {
    try {
      if (!loadMore) {
        page = 0;
        isLoading.value = true;
      }
      
      if (!hasMore.value && loadMore) return false;

      final newCompanies = await companyController.fetchCompaniesByCategory(
        categoryName: 'Hotel',
        page: page,
        limit: limit,
        orderBy: 'created_at',
        ascending: false,
      );

      if (loadMore) {
        companies.addAll(newCompanies);
      } else {
        companies.value = newCompanies;
      }

      hasMore.value = newCompanies.length >= limit;
      page++;
      return true;
    } catch (e) {
      print('Error fetching hotels: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
} 