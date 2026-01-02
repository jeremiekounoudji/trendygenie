import 'dart:developer';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../models/company_model.dart';

import 'user_controller.dart';

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
  final RxList<CompanyModel> ownerCompaniesMap = <CompanyModel>[].obs;

  // user controller
  final UserController userController = Get.put(UserController());

  @override
  void onInit() {
    super.onInit();
    fetchCompany();
  }

  Future<bool> fetchCompany() async {
    try {
      isLoading.value = true;
      error.value = '';
      
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        throw 'User not authenticated';
      }
      
      log('fetchCompany start');
      log('userId: $userId');
      
      final response = await supabase
          .from('companies')
          .select()
          .eq('owner_id', userId)
          .maybeSingle();

      if (response != null) {
        log('company from supabase: $response');
        company.value = CompanyModel.fromJson(response);
      }
      
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

      final companyId = company.value?.id;
      if (companyId == null) {
        throw 'Company not found';
      }

      await supabase
          .from('companies')
          .update({field: value})
          .eq('id', companyId);

      company.value = company.value?.copyWith(
        name: field == 'name' ? value : company.value?.name,
        description: field == 'description' ? value : company.value?.description,
        address: field == 'address' ? value : company.value?.address,
        category: field == 'category' ? value : company.value?.category,
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

      await supabase.storage.from('company-files').uploadBinary(filePath, bytes);
      final imageUrl = supabase.storage.from('company-files').getPublicUrl(filePath);

      return await updateField('company_logo', imageUrl);
    } catch (e) {
      error.value = 'Failed to upload logo: $e';
      return false;
    }
  }

  Future<bool> updateLocation(double lat, double lng) async {
    try {
      isLoading.value = true;
      error.value = '';

      final companyId = company.value?.id;
      if (companyId == null) {
        throw 'Company not found';
      }

      await supabase
          .from('companies')
          .update({
            'latitude': lat,
            'longitude': lng,
          })
          .eq('id', companyId);

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

      final companyId = company.value?.id;
      if (companyId == null) {
        throw 'Company not found';
      }

      await supabase
          .from('companies')
          .delete()
          .eq('id', companyId);

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

      currentUploadFile.value = 'company logo';
      uploadProgress.value = 0.33;
      final logoUrl = await _uploadFile(logo, 'logos');
      
      currentUploadFile.value = 'owner ID';
      uploadProgress.value = 0.66;
      final ownerIdUrl = await _uploadFile(ownerId, 'documents');
      
      currentUploadFile.value = 'selfie photo';
      uploadProgress.value = 0.99;
      final selfieUrl = await _uploadFile(selfie, 'documents');

      log('Files uploaded successfully');
      
      // Don't include 'id' field - let Supabase generate UUID automatically
      final companyData = {
        'name': company.name,
        'registration_number': company.registrationNumber,
        'address': company.address,
        'owner_id': company.ownerId,
        'status': 'pending',
        'company_logo': logoUrl,
        'owner_id_image': ownerIdUrl,
        'selfie_image': selfieUrl,
        'is_verified': false,
        'total_orders': 0,
        'rating': 0.0,
        'review_count': 0,
        // created_at will be auto-generated by Supabase
      };
      
      log('Creating company: $companyData');
      
      final response = await supabase
          .from('companies')
          .insert(companyData)
          .select()
          .single();

      log('Company created successfully: $response');
      
      // Update the local company object with the created company
      this.company.value = CompanyModel.fromJson(response);

      currentUploadFile.value = '';
      uploadProgress.value = 0.0;
      isLoading.value = false;
      return true;
    } catch (e) {
      log('Failed to create company: $e');
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

      log('Uploading file to company-files/$filePath');
      
      await supabase.storage.from('company-files').uploadBinary(filePath, bytes);
      final fileUrl = supabase.storage.from('company-files').getPublicUrl(filePath);
      
      log('File uploaded successfully: $fileUrl');
      return fileUrl;
    } catch (e) {
      log('Upload error: $e');
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
            category:categories (*)
          ''')
          .eq('status', 'approved')
          .order('rating', ascending: false)
          .limit(10);

      final nearbyRestaurants = (response as List)
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
            category:categories (*)
          ''')
          .eq('status', 'approved')
          .order(orderBy!, ascending: ascending)
          .range(page * limit, (page + 1) * limit - 1);

      return (response as List)
          .map((json) => CompanyModel.fromJson(json))
          .toList();
    } catch (e) {
      log('Error fetching companies by category: $e');
      return [];
    }
  }

  Future<List<CompanyModel>> getCompanyByOwner(String ownerId) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      final response = await supabase
          .from('companies')
          .select('''
            *,
            category:categories (*)
          ''')
          .eq('owner_id', ownerId)
          .order('created_at', ascending: false);

      ownerCompaniesMap.value = (response as List)
          .map((json) => CompanyModel.fromJson(json))
          .toList();

      isLoading.value = false;
      return ownerCompaniesMap;
    } catch (e) {
      log('Error fetching owner companies: $e');
      isLoading.value = false;
      error.value = 'Failed to fetch owner companies: $e';
      return [];
    }
  }

  void setCompany(CompanyModel newCompany) {
    company.value = newCompany;
  }

  void clearError() {
    error.value = '';
  }
}
