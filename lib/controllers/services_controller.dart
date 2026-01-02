import 'dart:developer' as dev;
import 'dart:io';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/enums.dart';
import '../models/service_item.dart';
import '../models/category_model.dart';
import '../utils/utility.dart';
import 'package:flutter/material.dart';

class ServicesController extends GetxController {
  final supabase = Supabase.instance.client;
  final RxList<ServiceItem> services = <ServiceItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxList<ServiceItem> restaurantServices = <ServiceItem>[].obs;
  final RxBool hasMoreRestaurants = true.obs;
  final RxInt restaurantPage = 1.obs;
  final int limit = 10;
  
  // Upload state tracking
  final RxString currentUploadFile = ''.obs;
  final RxDouble uploadProgress = 0.0.obs;
  final RxBool hasUploadFailed = false.obs;
  
  // services map
  final RxMap<String, List<ServiceItem>> servicesMap =
      <String, List<ServiceItem>>{}.obs;

  // Form controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final normalPriceController = TextEditingController();
  final promotionalPriceController = TextEditingController();
  
  // Form variables
  final Rx<CategoryModel?> selectedCategory = Rx<CategoryModel?>(null);
  final RxList<String> characteristics = <String>[].obs;
  final RxList<String> selectedImages = <String>[].obs;
  final RxString propertyType = ''.obs;
  final RxString foodCategory = ''.obs;
  final RxString cuisine = ''.obs;
  final RxInt bedroomCount = 0.obs;
  final RxInt bathroomCount = 0.obs;
  final RxBool hasKitchen = false.obs;
  final RxBool isDeliveryAvailable = false.obs;
  final selectedStatus = Rx<String?>(null);

  ServiceItem? createdService;


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

  // Helper method to upload multiple files
  Future<bool> uploadFiles(List<File> files, String serviceId) async {
    try {
      dev.log('🚀 Starting uploadFiles process', name: 'ServicesController');
      dev.log('📁 Number of files to upload: ${files.length}', name: 'ServicesController');
      dev.log('🆔 Service ID: $serviceId', name: 'ServicesController');

      List<String> uploadedUrls = [];
      int totalFiles = files.length;
      
      for (int i = 0; i < files.length; i++) {
        File file = files[i];
        dev.log('📝 Processing file ${i + 1} of $totalFiles: ${file.path}', name: 'ServicesController');
        
        currentUploadFile.value = 'Image ${i + 1} of $totalFiles';
        uploadProgress.value = i / totalFiles;
        
        final bytes = await file.readAsBytes();
        final fileExt = file.path.split('.').last.toLowerCase();
        final fileName = '${DateTime.now().toIso8601String()}_$i.$fileExt';
        final filePath = 'service_images/$serviceId/$fileName';  // Add serviceId to path for better organization

        // Map file extensions to proper MIME types
        String getMimeType(String extension) {
          switch (extension.toLowerCase()) {
            case 'jpg':
            case 'jpeg':
              return 'image/jpeg';
            case 'png':
              return 'image/png';
            case 'gif':
              return 'image/gif';
            case 'webp':
              return 'image/webp';
            case 'bmp':
              return 'image/bmp';
            case 'svg':
              return 'image/svg+xml';
            default:
              return 'image/jpeg'; // Default fallback
          }
        }

        dev.log('📤 Uploading file to path: $filePath', name: 'ServicesController');

        final uploadResponse = await supabase.storage.from('business_assets').uploadBinary(
          filePath,
          bytes,
          fileOptions: FileOptions(
            contentType: getMimeType(fileExt),
          ),
        );

        if (uploadResponse.isEmpty) {
          throw 'Failed to upload file ${i + 1}';
        }

        final imageUrl = supabase.storage.from('business_assets').getPublicUrl(filePath);
        dev.log('✅ File uploaded successfully. URL: $imageUrl', name: 'ServicesController');
        uploadedUrls.add(imageUrl);
      }
      
      uploadProgress.value = 1.0;
      dev.log('📊 All files uploaded. Updating service with new URLs ${uploadedUrls.toString()}', name: 'ServicesController');

      // Update service with new images
      await supabase
          .from('services')
          .update({
            'images': uploadedUrls,
            'updated_at': DateTime.now().toIso8601String() // Force update timestamp
          })
          .eq('id', serviceId);

      // Get the updated service data to verify
      final getResponse = await supabase
          .from('services')
          .select()
          .eq('id', serviceId);
          
      dev.log('Get response data: $getResponse', name: 'ServicesController');

      if ((getResponse as List).isEmpty) {
        throw 'Failed to fetch updated service data';
      }
      
      // Check if images were actually updated
      if (getResponse[0]['images'] == null || 
          (getResponse[0]['images'] as List).isEmpty ||
          !(getResponse[0]['images'] as List).contains(uploadedUrls[0])) {
        throw 'Images were not updated correctly in the database';
      }

      dev.log('✅ Images successfully updated in the database', name: 'ServicesController');
      return true;
    } catch (e, stackTrace) {
      dev.log(
        '❌ Error in uploadFiles',
        error: e.toString(),
        stackTrace: stackTrace,
        name: 'ServicesController'
      );
      error.value = 'Failed to upload files: $e';
      return false;
    }
  }

  Future<bool> addService(ServiceItem service, {List<File>? images, bool isRetry = false}) async {
    try {
      dev.log('🚀 Starting addService process', name: 'ServicesController');
      dev.log('📝 Service business id: ${service.businessId}', name: 'ServicesController');
      dev.log('📝 Service details:', name: 'ServicesController');
      dev.log('   Title: ${service.title}', name: 'ServicesController');
      dev.log('   Category: ${service.categoryId}', name: 'ServicesController');
      dev.log('   Is Retry: $isRetry', name: 'ServicesController');
      dev.log('   Has Images: ${images != null && images.isNotEmpty}', name: 'ServicesController');

      isLoading.value = true;
      error.value = '';
      hasUploadFailed.value = false;

      // If this is not a retry, create the service first
      if (!isRetry) {
        dev.log('📝 Creating new service record', name: 'ServicesController');
        final initialServiceData = {
          ...service.toJson(),
          'images': [], // Start with empty images array
          'status': ServiceStatus.pending.name,
        };

        final response = await supabase
            .from('services')
            .insert(initialServiceData)
            .select()
            .single();

        createdService = ServiceItem.fromJson(response);
        dev.log('✅ Service created successfully with ID: ${createdService?.id}', name: 'ServicesController');
      }

      // Handle image upload (for both new service and retry)
      if (images != null && images.isNotEmpty) {
        dev.log('📸 Starting image upload process', name: 'ServicesController');
        try {
          var isUploadDone = await uploadFiles(images, createdService?.id ?? service.id ?? '');
          if (!isUploadDone) {
            throw 'Failed to upload images';
          }
          dev.log('✅ Images uploaded successfully', name: 'ServicesController');
        } catch (uploadError, stackTrace) {
          dev.log(
            '❌ Image upload failed',
            error: uploadError.toString(),
            stackTrace: stackTrace,
            name: 'ServicesController'
          );
          hasUploadFailed.value = true;
          error.value = 'Image upload failed. You can retry uploading the images later.';
          Utility().showSnack(
            'Warning',
            'Image upload failed. You can retry uploading the images later.',
            5,
            true
          );
        }
      }
      
      isLoading.value = false;
      if (!hasUploadFailed.value) {
        final message = isRetry ? 'Images uploaded successfully' : 'Service created successfully';
        dev.log('✅ Process completed successfully: $message', name: 'ServicesController');
        Utility().showSnack('Success', message, 3, false);
      }
      return true;
    } catch (e, stackTrace) {
      dev.log(
        '❌ Error in addService',
        error: e.toString(),
        stackTrace: stackTrace,
        name: 'ServicesController'
      );
      isLoading.value = false;
      error.value = 'Failed to ${isRetry ? 'upload images' : 'create service'}: $e';
      Utility().showSnack('Error', error.value, 3, true);
      return false;
    }
  }

  Future<bool> updateService(String serviceId, Map<String, dynamic> updates, {List<File>? newImages}) async {
    try {
      dev.log('🚀 Starting updateService process', name: 'ServicesController');
      dev.log('📝 Service ID: $serviceId', name: 'ServicesController');
      dev.log('📝 Updates: $updates', name: 'ServicesController');
      dev.log('📝 Has New Images: ${newImages != null && newImages.isNotEmpty}', name: 'ServicesController');

      isLoading.value = true;
      error.value = '';
      hasUploadFailed.value = false;

      // First check if service exists
      final checkResponse = await supabase
          .from('services')
          .select()
          .eq('id', serviceId);

      if ((checkResponse as List).isEmpty) {
        dev.log('❌ Service not found', name: 'ServicesController');
        throw 'Service not found';
      }

      // Update service data
      dev.log('📝 Updating service record', name: 'ServicesController');
      await supabase
          .from('services')
          .update(updates)
          .eq('id', serviceId);

      // Handle image upload if new images are provided
      if (newImages != null && newImages.isNotEmpty) {
        dev.log('📸 Starting image upload process', name: 'ServicesController');
        try {
          await uploadFiles(newImages, serviceId);
          dev.log('✅ Images uploaded successfully', name: 'ServicesController');
        } catch (uploadError, stackTrace) {
          dev.log(
            '❌ Image upload failed',
            error: uploadError.toString(),
            stackTrace: stackTrace,
            name: 'ServicesController'
          );
          hasUploadFailed.value = true;
          error.value = 'Image upload failed. You can retry uploading the images later.';
          Utility().showSnack(
            'Warning',
            'Image upload failed. You can retry uploading the images later.',
            5,
            true
          );
        }
      }
      
      isLoading.value = false;
      if (!hasUploadFailed.value) {
        final message = newImages != null && newImages.isNotEmpty 
          ? 'Service updated and images uploaded successfully'
          : 'Service updated successfully';
        dev.log('✅ Process completed successfully: $message', name: 'ServicesController');
        Utility().showSnack('Success', message, 3, false);
      }
      return true;
    } catch (e, stackTrace) {
      dev.log(
        '❌ Error in updateService',
        error: e.toString(),
        stackTrace: stackTrace,
        name: 'ServicesController'
      );
      isLoading.value = false;
      error.value = 'Failed to update service: $e';
      Utility().showSnack('Error', error.value, 3, true);
      return false;
    }
  }

  Future<bool> deleteService(String serviceId) async {
    dev.log('🚀 Starting deleteService process', name: 'ServicesController');
    dev.log('📝 Service ID: $serviceId', name: 'ServicesController');
    try {
      isLoading.value = true;
      error.value = '';

      await supabase
          .from('services')
          .update({'status': ServiceStatus.deleted.name})
          .eq('id', serviceId);

      dev.log('✅ Service deleted successfully', name: 'ServicesController');
      
      isLoading.value = false;
      return true;
    } catch (e) {
      dev.log('❌ Error in deleteService: $e', name: 'ServicesController');
      isLoading.value = false;
      error.value = 'Failed to delete service: $e';
      return false;
    }
  }

  Future<bool> fetchServices(String? categoryId, {bool loadMore = false}) async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      if (!loadMore) {
        restaurantPage.value = 1;
        servicesMap[categoryId ?? ''] = [];
      }

      if (!hasMoreRestaurants.value && loadMore) {
        return true;
      }

      isLoading.value = true;
      error.value = '';

      final from = (restaurantPage.value - 1) * limit;
      final to = from + limit - 1;

      // Build the query with proper joins including business information
      var query = supabase.from('services').select('''
        *,
        category:category_id(*),
        business:business_id(
          id,
          name,
          description,
          logo_url,
          address,
          contact_email,
          contact_phone,
          rating,
          
          status
        )
      ''');

      // Filter by category ID if provided
      if (categoryId != null && categoryId.isNotEmpty) {
        query = query.eq('category_id', categoryId);
      }

      // Only get active services
      query = query.eq('status', 'active');
      
      final data = await query.range(from, to).order('created_at', ascending: false);

      dev.log('Services response: $data', name: 'ServicesController');
      
      try {
        final newServices = (data as List)
            .map((json) => ServiceItem.fromJson(json))
            .toList();
        servicesMap[categoryId ?? '']?.addAll(newServices);

        hasMoreRestaurants.value = newServices.length >= limit;
        if (hasMoreRestaurants.value) {
          restaurantPage.value++;
        }
      } catch (e) {
        dev.log('Error parsing services: $e', name: 'ServicesController');
        error.value = 'Failed to parse services: $e';
      }

      isLoading.value = false;
      return true;
    } catch (e) {
      dev.log('Error fetching services: $e', name: 'ServicesController');
      isLoading.value = false;
      error.value = 'Failed to fetch services: $e';
      return false;
    }
  }

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

      var query = supabase
          .from('services')
          .select('*, category:category_id(*)')
          .eq('business_id', businessId);
      
      // Add status filter if selected
      if (selectedStatus.value != null) {
        query = query.eq('status', selectedStatus.value!);
      }

      final data = await query
          .range(from, to)
          .order('created_at', ascending: false);

      // Directly convert response data to ServiceItem objects
      if (page == 0) {
        services.value = (data as List)
            .map((json) => ServiceItem.fromJson(json))
            .toList();
      } else {
        final newServices = (data as List)
            .map((json) => ServiceItem.fromJson(json))
            .toList();
        services.addAll(newServices);
      }

      isLoading.value = false;
      return true;
    } catch (e) {
      dev.log('Error fetching business services: $e', name: 'ServicesController');
      isLoading.value = false;
      error.value = 'Failed to fetch business services: $e';
      return false;
    }
  }
 void initializeForEdit(ServiceItem service) {
    titleController.text = service.title;
    descriptionController.text = service.description;
    normalPriceController.text = service.normalPrice.toString();
    promotionalPriceController.text = service.promotionalPrice.toString();
    selectedCategory.value = service.category;
    
    if (service.caracteristics != null) {
      characteristics.value = service.caracteristics!;
    }
    
    if (service.images.isNotEmpty) {
      selectedImages.value = service.images;
    }
    
    if (service.propertyType != null) {
      propertyType.value = service.propertyType!;
    }
    
    if (service.foodCategory != null) {
      foodCategory.value = service.foodCategory!;
    }
    
    if (service.cuisine != null) {
      cuisine.value = service.cuisine!;
    }
    
    if (service.bedroomCount != null) {
      bedroomCount.value = service.bedroomCount!;
    }
    
    if (service.bathroomCount != null) {
      bathroomCount.value = service.bathroomCount!;
    }
    
    if (service.hasKitchen != null) {
      hasKitchen.value = service.hasKitchen!;
    }
    
    if (service.isDeliveryAvailable != null) {
      isDeliveryAvailable.value = service.isDeliveryAvailable!;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    normalPriceController.dispose();
    promotionalPriceController.dispose();
    super.onClose();
  }

  // Method to increment view count when a service is viewed
  Future<void> incrementViewCount(String serviceId) async {
    try {
      await supabase.rpc('increment_service_view_count', params: {
        'service_id': serviceId,
      });
      dev.log('✅ View count incremented for service: $serviceId', name: 'ServicesController');
    } catch (e) {
      dev.log('❌ Failed to increment view count: $e', name: 'ServicesController');
      // Don't throw error as this is not critical functionality
    }
  }

  // Method to request service deletion (marks for admin review)
  Future<ServiceItem?> requestServiceDeletion(String serviceId) async {
    try {
      isLoading.value = true;
      error.value = '';

      // Update service status to 'requestDeletion'
      final response = await supabase
          .from('services')
          .update({'status': ServiceStatus.requestDeletion.name})
          .eq('id', serviceId)
          .select('*, category:category_id(*)')
          .single();

      dev.log('✅ Service marked for deletion: $serviceId', name: 'ServicesController');
      isLoading.value = false;
      Utility().showSnack('Success', 'Delete request submitted successfully', 3, false);
      
      return ServiceItem.fromJson(response);
    } catch (e) {
      dev.log('❌ Failed to request service deletion: $e', name: 'ServicesController');
      error.value = 'Failed to submit delete request: $e';
      isLoading.value = false;
      Utility().showSnack('Error', 'Failed to submit delete request', 3, true);
      return null;
    }
  }

  // Method to cancel service deletion request
  Future<ServiceItem?> cancelServiceDeletion(String serviceId) async {
    try {
      isLoading.value = true;
      error.value = '';

      // Update service status back to 'active'
      final response = await supabase
          .from('services')
          .update({'status': ServiceStatus.active.name})
          .eq('id', serviceId)
          .select('*, category:category_id(*)')
          .single();

      dev.log('✅ Service deletion request cancelled: $serviceId', name: 'ServicesController');
      isLoading.value = false;
      Utility().showSnack('Success', 'Delete request cancelled successfully', 3, false);
      
      return ServiceItem.fromJson(response);
    } catch (e) {
      dev.log('❌ Failed to cancel service deletion: $e', name: 'ServicesController');
      error.value = 'Failed to cancel deletion request: $e';
      isLoading.value = false;
      Utility().showSnack('Error', 'Failed to cancel delete request', 3, true);
      return null;
    }
  }
}
