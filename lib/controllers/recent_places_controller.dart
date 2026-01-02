import 'package:get/get.dart';
import '../models/business_model.dart';
import 'business_controller.dart';

class RecentPlacesController extends GetxController {
  final RxList<BusinessModel> businesses = <BusinessModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasMore = true.obs;
  
  int page = 0;
  final int limit = 10;

  final BusinessController businessController = Get.find<BusinessController>();

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

      final newBusinesses = await businessController.fetchBusinessesByCategory(
        'Hotel',
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
      print('Error fetching hotels: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
} 