import 'dart:developer';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import '../models/business_model.dart';
import '../utils/utility.dart';
import 'company_controller.dart';

class BusinessController extends GetxController {
  final supabase = Supabase.instance.client;
  final RxList<BusinessModel> businesses = <BusinessModel>[].obs;
  final Rx<BusinessModel?> selectedBusiness = Rx<BusinessModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString currentUploadFile = ''.obs;
  final RxDouble uploadProgress = 0.0.obs;
  final RxString selectedStatusFilter = 'all'.obs;

  // Map to store businesses filtered by status
  final RxMap<String, List<BusinessModel>> businessesByStatus =
      <String, List<BusinessModel>>{}.obs;

  // Map to store statistics
  final RxMap<String, int> businessStats = <String, int>{}.obs;

  // company controller
  final CompanyController companyController = Get.put(CompanyController());

  // Location related variables
  final RxBool isLoadingLocation = false.obs;
  final RxString locationError = ''.obs;

  // Getter for filtered businesses
  List<BusinessModel> get filteredBusinesses {
    if (selectedStatusFilter.value == 'all') {
      return businesses;
    }
    return businesses.where((business) => 
      business.status.toString().split('.').last == selectedStatusFilter.value
    ).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchBusinesses();
  }

  // Fetch all businesses for the current company
  Future<bool> fetchBusinesses() async {
    try {
      isLoading.value = true;
      error.value = '';

      // Get current user's company ID
      log('userId on business fetch start');

      // final companyResponse = await supabase
      //     .from('companies')
      //     .select('id')
      //     .eq('owner_id', userId)
      //     .single()
      //     .execute();

      // if (companyResponse.status != 200) {
      //   throw 'Error fetching company: ${companyResponse.status}';
      log('companyId: ${companyController.company.value}');
      // }
      final companyId = companyController.company.value!.id;
      if (companyId == null) {
        throw 'Company ID is null';
      }
      log('companyId: $companyId');
      // Get all businesses for this company
      final data = await supabase.from('businesses').select('''
            *,
            category:category_id(*),
            subcategory:subcategory_id(*)
          ''').eq('company_id', companyId);
      log('businesses from supabase: $data');

      final List<dynamic> dataList = data as List<dynamic>;
      log(dataList.toString(), name: 'businesses from supabase');
      businesses.value =
          dataList.map((json) => BusinessModel.fromJson(json)).toList();

      // Update statistics
      _updateBusinessStats();

      // Group businesses by status
      _groupBusinessesByStatus();

      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      error.value = 'Failed to fetch businesses: $e';
      log('Error fetching businesses in cache: $e');
      return false;
    }
  }

  // Fetch a specific business by ID
  Future<BusinessModel?> fetchBusinessById(String id) async {
    try {
      isLoading.value = true;
      error.value = '';

      final data = await supabase.from('businesses').select('''
            *,
            category:category_id(*),
            subcategory:subcategory_id(*)
          ''').eq('id', id).maybeSingle();

      if (data == null) {
        throw 'Business not found';
      }
      log('business from supabase: $data');

      var business = BusinessModel.fromJson(data);
      isLoading.value = false;
      return business;
    } catch (e) {
      // isLoading.value = false;
      error.value = 'Failed to fetch business: $e';
      log('Error fetching business: $e');
      return null;
    }
  }

  // Create a new business
  Future<bool> createBusiness(Map<String, dynamic> data, {XFile? logo}) async {
    try {
      isLoading.value = true;
      error.value = '';

      // Set default status to pending and add timestamps
      final businessData = {
        ...data,
        'status': 'pending',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      // First create the business without the logo
      final response = await supabase
          .from('businesses')
          .insert(businessData)
          .select()
          .single();

      log('business created: $response');

      // Get the created business ID
      final businessId = response['id'];

      // If logo is provided, try to upload it
      if (logo != null) {
        try {
          // Use updateBusiness to handle logo upload
          final success = await updateBusiness(
            businessId,
            {},  // No other fields to update
            logo: logo
          );

          if (!success) {
            // Logo update failed but business was created
            error.value = 'Business created but logo upload failed. You can retry uploading the logo later.';
            Utility().showSnack(
              'Warning',
              'Business created but logo upload failed. You can retry uploading the logo later.',
              5,
              true
            );
          }
        } catch (uploadError) {
          // Logo upload failed but business was created
          error.value = 'Business created but logo upload failed. You can retry uploading the logo later.';
          Utility().showSnack(
            'Warning',
            'Business created but logo upload failed. You can retry uploading the logo later.',
            5,
            true
          );
          log('Error uploading logo: $uploadError');
        }
      }

      // Refresh the businesses list
      bool isFetched = await fetchBusinesses();
      if (!isFetched) {
        return false;
      }

      Utility().showSnack('Success', 'Business created successfully', 5, false);
      return true;

    } catch (e) {
      isLoading.value = false;
      error.value = 'Failed to create business: $e';
      log('Error creating business: $e');
      
      // Check for unique constraint violation
      if (e.toString().contains('unique_violation') || e.toString().contains('A business with this name already exists')) {
        Utility().showSnack(
          'Error',
          'A business with this name already exists. Please choose a different name.',
          3,
          true
        );
      } else {
        Utility().showSnack('Error', 'Failed to create business: $e', 3, true);
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Update an existing business
  Future<bool> updateBusiness(String id, Map<String, dynamic> data,
      {XFile? logo}) async {
    try {
      isLoading.value = true;
      error.value = '';

      String? logoUrl;

      // Upload logo if provided
      if (logo != null) {
        currentUploadFile.value = 'business logo';
        uploadProgress.value = 0.5;
        logoUrl = await _uploadFile(logo, 'business_assets');
        data['logo_url'] = logoUrl;
        log('logoUrl: $logoUrl');
      }

      // Add updated timestamp
      data['updated_at'] = DateTime.now().toIso8601String();

      await supabase.from('businesses').update(data).eq('id', id);

      // Refresh the businesses list
      await fetchBusinesses();

      // If this was the selected business, update it
      if (selectedBusiness.value?.id == id) {
        var business = await fetchBusinessById(id);
        // update the local business  with copywith
        selectedBusiness.value = business;
      }

      isLoading.value = false;
      Utility().showSnack('Success', 'Business updated successfully', 3, false);
      return true;
    } catch (e) {
      isLoading.value = false;
      error.value = 'Failed to update business: $e';
      log('Error updating business: $e');
      Utility().showSnack('Error', 'Failed to update business: $e', 3, true);
      return false;
    }
  }

  // Delete a business (set status to deleted)
  Future<bool> deleteBusiness(String id) async {
    return await changeBusinessStatus(id, 'deleted');
  }

  // Change the status of a business
  Future<bool> changeBusinessStatus(String id, String status) async {
    try {
      isLoading.value = true;
      error.value = '';

      await supabase
          .from('businesses')
          .update({
            'status': status,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id);

      // Refresh the businesses list
      await fetchBusinesses();

      // If this was the selected business, update it
      if (selectedBusiness.value?.id == id) {
        var business = await fetchBusinessById(id);
        // update the local business status with copywith
        selectedBusiness.value = business;
      }

      isLoading.value = false;
      Utility().showSnack('Success', 'Business status updated successfully', 3, false);
      return true;
    } catch (e) {
      isLoading.value = false;
      error.value = 'Failed to update business status: $e';
      log('Error updating business status: $e');
      Utility().showSnack('Error', 'Failed to update business status: $e', 3, true);
      return false;
    }
  }

  // Fetch businesses with a specific status
  Future<void> fetchBusinessesByStatus(String status) async {
    try {
      isLoading.value = true;
      error.value = '';

      // Get current user's company ID
      final userId = supabase.auth.currentUser!.id;
      final companyData = await supabase
          .from('companies')
          .select('id')
          .eq('owner_id', userId)
          .maybeSingle();

      if (companyData == null) {
        throw 'Company not found';
      }

      final companyId = companyData['id'];

      // Get businesses with the specified status
      final data = await supabase.from('businesses').select('''
            *,
            category:category_id(*),
            subcategory:subcategory_id(*)
          ''').eq('company_id', companyId).eq('status', status);

      final List<dynamic> dataList = data as List<dynamic>;
      businessesByStatus[status] =
          dataList.map((json) => BusinessModel.fromJson(json)).toList();

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      error.value = 'Failed to fetch businesses by status: $e';
      log('Error fetching businesses by status: $e');
    }
  }

  // Fetch businesses in a specific category
  Future<List<BusinessModel>> fetchBusinessesByCategory(
    String categoryName, {
    int page = 0,
    int limit = 10,
    String orderBy = 'created_at',
    bool ascending = false,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';

      // Get businesses in the specified category
      final data = await supabase
          .from('businesses')
          .select('''
            *,
            category:category_id(*),
            subcategory:subcategory_id(*)
          ''')
          .eq('category.name', categoryName)
          .eq('status', 'active')
          .order(orderBy, ascending: ascending)
          .range(page * limit, (page + 1) * limit - 1);

      final List<dynamic> dataList = data as List<dynamic>;
      final categoryBusinesses =
          dataList.map((json) => BusinessModel.fromJson(json)).toList();

      isLoading.value = false;
      return categoryBusinesses;
    } catch (e) {
      isLoading.value = false;
      error.value = 'Failed to fetch businesses by category: $e';
      log('Error fetching businesses by category: $e');
      return [];
    }
  }

  // Update business hours for a specific business
  Future<bool> updateBusinessHours(String businessId, List<String> hours) async {
    try {
      isLoading.value = true;
      error.value = '';

      await supabase
          .from('businesses')
          .update({
            'business_hours': hours,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', businessId);

      // Refresh the businesses list
      await fetchBusinesses();

      // If this was the selected business, update it
      if (selectedBusiness.value?.id == businessId) {
        var business = await fetchBusinessById(businessId);
        selectedBusiness.value = business;
      }

      isLoading.value = false;
      Utility().showSnack('Success', 'Business hours updated successfully', 3, false);
      return true;
    } catch (e) {
      isLoading.value = false;
      error.value = 'Failed to update business hours: $e';
      log('Error updating business hours: $e');
      Utility().showSnack('Error', 'Failed to update business hours: $e', 3, true);
      return false;
    }
  }

  // Fetch businesses for a specific company
  Future<List<BusinessModel>> fetchBusinessesByCompany(String companyId) async {
    try {
      isLoading.value = true;
      error.value = '';

      // Get businesses for the specified company
      final data = await supabase.from('businesses').select('''
            *,
            category:category_id(*),
            subcategory:subcategory_id(*)
          ''').eq('company_id', companyId);

      final List<dynamic> dataList = data as List<dynamic>;
      final companyBusinesses =
          dataList.map((json) => BusinessModel.fromJson(json)).toList();

      isLoading.value = false;
      return companyBusinesses;
    } catch (e) {
      isLoading.value = false;
      error.value = 'Failed to fetch businesses by company: $e';
      log('Error fetching businesses by company: $e');
      return [];
    }
  }

  // Helper method to upload a file
  Future<String> _uploadFile(XFile file, String folder) async {
    try {
      final bytes = await file.readAsBytes();
      final fileExt = file.path.split('.').last;
      final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
      final filePath = '$folder/$fileName';

      // Upload to Supabase Storage
      await supabase.storage.from('business_assets').uploadBinary(
            filePath,
            bytes,
            fileOptions: FileOptions(
              contentType: 'image/$fileExt',
            ),
          );

      // Get public URL
      final imageUrl =
          supabase.storage.from('business_assets').getPublicUrl(filePath);

      return imageUrl;
    } catch (e) {
      error.value = 'Failed to upload file: $e';
      log('Error uploading file: $e');
      rethrow;
    }
  }

  // Helper method to group businesses by status
  void _groupBusinessesByStatus() {
    businessesByStatus.clear();

    for (final business in businesses) {
      final status = business.status.toString().split('.').last;
      if (!businessesByStatus.containsKey(status)) {
        businessesByStatus[status] = [];
      }
      businessesByStatus[status]!.add(business);
    }
  }

  // Helper method to update business statistics
  void _updateBusinessStats() {
    businessStats.clear();

    // Count businesses by status
    for (final business in businesses) {
      final status = business.status.toString().split('.').last;
      businessStats[status] = (businessStats[status] ?? 0) + 1;
    }

    // Total count
    businessStats['total'] = businesses.length;
  }

  // Get current location
  Future<Map<String, double>?> getLocation() async {
    try {
      isLoadingLocation.value = true;
      locationError.value = '';

      // Check if location services are enabled
      // bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      // if (!serviceEnabled) {
      //   locationError.value = 'Location services are disabled';
      //   return null;
      // }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          locationError.value = 'Location permissions are denied';
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        locationError.value = 'Location permissions are permanently denied';
        return null;
      }

      // Get current position
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
      };
    } catch (e) {
      locationError.value = 'Failed to get location: $e';
      log('Error getting location: $e');
      return null;
    } finally {
      isLoadingLocation.value = false;
    }
  }

  // Fetch nearby restaurants sorted by rating
  Future<List<BusinessModel>> fetchNearRestaurants() async {
    try {
      isLoading.value = true;
      error.value = '';

      final data = await supabase
          .from('businesses')
          .select('''
            *,
            category:category_id(*),
            subcategory:subcategory_id(*)
          ''')
          .eq('category.name', 'Restaurant')
          .eq('status', 'active')
          .order('rating', ascending: false)
          .limit(10);

      final List<dynamic> dataList = data as List<dynamic>;
      final nearbyRestaurants = dataList.map((json) => BusinessModel.fromJson(json)).toList();
      
      isLoading.value = false;
      return nearbyRestaurants;
    } catch (e) {
      isLoading.value = false;
      error.value = 'Failed to fetch near restaurants: $e';
      log('Error fetching near restaurants: $e');
      return [];
    }
  }
}
