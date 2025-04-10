import 'package:get/get.dart';
import '../models/company_model.dart';
import 'company_controller.dart';

class SelectedCategoryController extends GetxController {
  final RxList<CompanyModel> companies = <CompanyModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasMore = true.obs;
  final RxString searchQuery = ''.obs;
  
  int page = 0;
  final int limit = 10;
  final String categoryName;
  final CompanyController companyController = Get.find<CompanyController>();

  SelectedCategoryController({required this.categoryName});

  @override
  void onInit() {
    super.onInit();
    fetchCompanies();
  }

  Future<bool> fetchCompanies({bool loadMore = false}) async {
    try {
      if (!loadMore) {
        page = 0;
        isLoading.value = true;
      }
      
      if (!hasMore.value && loadMore) return false;

      final newCompanies = await companyController.fetchCompaniesByCategory(
        categoryName: categoryName,
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
      print('Error fetching companies: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void searchCompanies(String query) {
    searchQuery.value = query;
    fetchCompanies();
  }
} 