import 'package:get/get.dart';
import '../models/business_model.dart';
import 'business_controller.dart';

class SelectedCategoryController extends GetxController {
  final RxList<BusinessModel> businesses = <BusinessModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasMore = true.obs;
  final RxString searchQuery = ''.obs;
  
  int page = 0;
  final int limit = 10;
  final String categoryName;
  final BusinessController businessController = Get.find<BusinessController>();

  SelectedCategoryController({required this.categoryName});

  @override
  void onInit() {
    super.onInit();
    fetchBusinesses();
  }

  Future<bool> fetchBusinesses({bool loadMore = false}) async {
    try {
      if (!loadMore) {
        page = 0;
        isLoading.value = true;
      }
      
      if (!hasMore.value && loadMore) return false;

      final newBusinesses = await businessController.fetchBusinessesByCategory(
        categoryName,
        page: page,
        limit: limit,
        orderBy: 'created_at',
        ascending: false,
      );

      if (loadMore) {
        businesses.addAll(newBusinesses);
      } else {
        businesses.value = newBusinesses;
      }

      hasMore.value = newBusinesses.length >= limit;
      page++;
      return true;
    } catch (e) {
      print('Error fetching businesses: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void searchBusinesses(String query) {
    searchQuery.value = query;
    fetchBusinesses();
  }
} 