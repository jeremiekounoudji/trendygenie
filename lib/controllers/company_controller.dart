import 'dart:developer';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../models/company_model.dart';

class CompanyController extends GetxController {
  final supabase = Supabase.instance.client;
  final Rx<CompanyModel?> company = Rx<CompanyModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final ImagePicker _imagePicker = ImagePicker();
  final RxString currentUploadFile = ''.obs;
  final RxDouble uploadProgress = 0.0.obs;
  final RxString errorMessage = ''.obs;

  // companies map to store different lists of companies
  final RxMap<String, List<CompanyModel>> companiesMap = <String, List<CompanyModel>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCompany();
  }

  Future<bool> fetchCompany() async {
    try {
      isLoading.value = true;
      error.value = '';
      
      final response = await supabase
          .from('companies')
          .select()
          .eq('owner_id', supabase.auth.currentUser?.id)
          .single()
          .execute();

      if (response.status != 200) {
        throw 'Error: Status ${response.status}';
      }

      company.value = CompanyModel.fromJson(response.data);
      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      error.value = 'Failed to fetch company: $e';
      return false;
    }
  }

  Future<bool> updateField(String field, dynamic value) async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await supabase
          .from('companies')
          .update({field: value})
          .eq('id', company.value?.id)
          ;

      if (response.status != 200) {
        throw 'Error: Status ${response.status}';
      }

      company.value = company.value?.copyWith(
        name: field == 'name' ? value : company.value?.name,
        description: field == 'description' ? value : company.value?.description,
        address: field == 'address' ? value : company.value?.address,
        category: field == 'category' ? value : company.value?.category,
        businessHours: field == 'business_hours' ? value : company.value?.businessHours,
        latitude: field == 'latitude' ? value : company.value?.latitude,
        longitude: field == 'longitude' ? value : company.value?.longitude,
      );

      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      error.value = 'Failed to update $field: $e';
      return false;
    }
  }

  Future<bool> pickLogo() async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image == null) return false;

      final bytes = await image.readAsBytes();
      final fileExt = image.path.split('.').last;
      final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
      final filePath = 'company_logos/$fileName';

      // Upload to Supabase Storage
      final response = await supabase
          .storage
          .from('public')
          .uploadBinary(filePath, bytes);

      // if (response.statusCode != 200) {
      //   throw response.statusCode.toString();
      // }

      // Get public URL
      final imageUrl = supabase
          .storage
          .from('public')
          .getPublicUrl(filePath);

      // Update company logo in database
      return await updateField('company_logo', imageUrl);
    } catch (e) {
      error.value = 'Failed to upload logo: $e';
      return false;
    }
  }

  Future<bool> updateBusinessHours(List<String> hours) async {
    return await updateField('business_hours', hours);
  }

  Future<bool> updateLocation(double lat, double lng) async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await supabase
          .from('companies')
          .update({
            'latitude': lat,
            'longitude': lng,
          })
          .eq('id', company.value?.id)
          .execute();

      if (response.status != 200) {
        throw 'Error: Status ${response.status}';
      }

      company.value = company.value?.copyWith(
        latitude: lat,
        longitude: lng,
      );

      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      error.value = 'Failed to update location: $e';
      return false;
    }
  }

  Future<bool> deleteCompany() async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await supabase
          .from('companies')
          .delete()
          .eq('id', company.value?.id)
          .execute();

      if (response.status != 200) {
        throw 'Error: Status ${response.status}';
      }

      company.value = null;
      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      error.value = 'Failed to delete company: $e';
      return false;
    }
  }

  Future<bool> createCompany(CompanyModel company, {
    required XFile logo,
    required XFile ownerId,
    required XFile selfie,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Upload logo
      currentUploadFile.value = 'company logo';
      final logoUrl = await _uploadFile(logo, 'logos');
      
      // Upload owner ID
      currentUploadFile.value = 'owner ID';
      final ownerIdUrl = await _uploadFile(ownerId, 'documents');
      
      // Upload selfie
      currentUploadFile.value = 'selfie photo';
      final selfieUrl = await _uploadFile(selfie, 'documents');

      final response = await supabase
          .from('companies')
          .insert({
            ...company.toJson(),
            'company_logo': logoUrl,
            'owner_id_image': ownerIdUrl,
            'selfie_image': selfieUrl,
          })
          .execute();

      if (response.status != 201) {
        throw 'Error: Status ${response.status}';
      }

      currentUploadFile.value = '';
      isLoading.value = false;
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      isLoading.value = false;
      return false;
    }
  }

  Future<String> _uploadFile(XFile file, String folder) async {
    try {
      final bytes = await file.readAsBytes();
      final fileExt = file.path.split('.').last;
      final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
      final filePath = '$folder/$fileName';

      await supabase.storage.from('public').uploadBinary(filePath, bytes);
      return supabase.storage.from('public').getPublicUrl(filePath);
    } catch (e) {
      throw 'Failed to upload ${file.path}: $e';
    }
  }

  Future<bool> fetchNearRestaurants() async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await supabase
    .from('companies')
    .select('''
      *,
      category:categories (
        *
      )
    ''')
    .eq('category.name', 'Restaurant')
    .order('rating', ascending: false) // Changed to order by rating descending
    .limit(10)
    .execute();

      if (response.status != 200) {
        throw 'Error: Status ${response.status}';
      }

      final nearbyRestaurants = (response.data as List)
          .map((json) => CompanyModel.fromJson(json))
          .toList();
      companiesMap['near-restaurants'] = nearbyRestaurants;

      isLoading.value = false;
      return true;
    } catch (e) {
      log('Error fetching near restaurants: $e');
      isLoading.value = false;
      error.value = 'Failed to fetch near restaurants: $e';
      return false;
    }
  }


  Future<List<CompanyModel>> fetchCompaniesByCategory({
    required String categoryName,
    required int page,
    required int limit,
    String? orderBy = 'created_at',
    bool ascending = false,
  }) async {
    try {
      final response = await supabase
          .from('companies')
          .select('''
            *,
            category:categories (
              *
            )
          ''')
          .eq('category.name', categoryName)
          .order(orderBy!, ascending: ascending)
          .range(page * limit, (page + 1) * limit - 1)
          .execute();

      return (response.data as List)
          .map((json) => CompanyModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching companies by category: $e');
      return [];
    }
  }
} 