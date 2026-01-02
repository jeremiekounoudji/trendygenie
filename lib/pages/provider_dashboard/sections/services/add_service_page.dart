import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../../controllers/company_controller.dart';
import '../../../../controllers/services_controller.dart';
import '../../../../controllers/category_controller.dart';
import '../../../../controllers/user_controller.dart';
import '../../../../models/business_model.dart';
import '../../../../models/service_item.dart';
import '../../../../models/category_model.dart';
import '../../../../utils/globalVariable.dart';
import '../../../../utils/utility.dart';
import '../../../../widgets/general_widgets/textfield.dart';
import '../../../../widgets/general_widgets/common_button.dart';
import 'widgets/service_type_selector.dart';
import 'widgets/service_category_selector.dart';
import 'widgets/service_accommodation_fields.dart';
import 'widgets/service_food_fields.dart';
import 'widgets/service_price_fields.dart';
import 'widgets/editable_image_carousel.dart';
import 'widgets/retry_upload_dialog.dart';

class AddServicePage extends StatefulWidget {
  final BusinessModel business;

  const AddServicePage({
    super.key,
    required this.business,
  });

  @override
  State<AddServicePage> createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  final ServicesController _servicesController = Get.put(ServicesController(  ));
  final CategoryController _categoryController = Get.put(CategoryController());
  // company controller
  final CompanyController _companyController = Get.put(CompanyController());
  // user controller
  final UserController _userController = Get.put(UserController());
  final Utility _utility = Get.put(Utility());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _normalPriceController = TextEditingController();
  final TextEditingController _promotionalPriceController = TextEditingController();

  // Additional controllers for accommodation fields
  final TextEditingController _bedroomCountController = TextEditingController();
  final TextEditingController _bathroomCountController =
      TextEditingController();
  final TextEditingController _propertyTypeController = TextEditingController();

  // Additional controllers for food fields
  final TextEditingController _cuisineController = TextEditingController();
  final TextEditingController _foodCategoryController = TextEditingController();

  // Add a new controller for characteristics input
  final TextEditingController _characteristicController =
      TextEditingController();

  // Add a new controller for accommodation characteristics input
  final TextEditingController _accommodationCharacteristicController =
      TextEditingController();
  final List<String> _selectedAccommodationCharacteristics = [];

  final RxList<File> _selectedImages = <File>[].obs;
  final RxInt _currentImageIndex = 0.obs;

  CategoryModel? _selectedCategory;
  final RxBool _isLoading = false.obs;
  final RxList<CategoryModel> _categories = <CategoryModel>[].obs;

  // Dropdown options
  final List<String> _propertyTypes = [
    'Apartment',
    'House',
    'Villa',
    'Hotel Room',
    'Cottage',
    'Other'
  ];
  final List<String> _foodCategories = [
    'Fast Food',
    'Fine Dining',
    'Cafe',
    'Bakery',
    'Street Food',
    'Other'
  ];

  // Features
  bool _hasKitchen = false;
  bool _isDeliveryAvailable = false;

  // Dietary options/characteristics
  final List<String> _selectedCharacteristics = [];

  // Service type
  String _serviceType = 'General';

  // Add new fields for retry functionality
  String? _createdServiceId;
  List<File> _pendingImages = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
    // Set the default category from business
    _selectedCategory = widget.business.category;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _normalPriceController.dispose();
    _promotionalPriceController.dispose();
    _bedroomCountController.dispose();
    _bathroomCountController.dispose();
    _propertyTypeController.dispose();
    _cuisineController.dispose();
    _foodCategoryController.dispose();
    _characteristicController.dispose();
    _accommodationCharacteristicController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    await _categoryController.fetchCategories();
    _categories.value = _categoryController.categories;
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage(
      imageQuality: 80,
    );

    if (images != null && images.isNotEmpty) {
      _selectedImages.addAll(images.map((image) => File(image.path)));
    }
  }

  bool _validateForm() {
    if (_formKey.currentState?.validate() != true) {
      return false;
    }

    if (_selectedImages.isEmpty) {
      _utility.showSnack(
          'Warning',
          'No images selected. Your service will use a default image.',
          3,
          true);
      // Still allow form submission without images
    }

    if (_serviceType == 'Accommodation' &&
        _propertyTypeController.text.isEmpty) {
      _utility.showSnack('Error', 'Please select a property type', 3, true);
      return false;
    }

    if (_serviceType == 'Food' && _selectedCharacteristics.isEmpty) {
      _utility.showSnack(
          'Warning',
          'Consider adding dietary characteristics to help customers find your service',
          3,
          false);
      // Still allow form submission without characteristics
    }

    return true;
  }

  Future<void> _saveService() async {
    if (!_validateForm()) return;

    try {
      _isLoading.value = true;

      // Basic service details
      final Map<String, dynamic> serviceData = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'normal_price': double.parse(_normalPriceController.text),
        'promotional_price': double.parse(_promotionalPriceController.text),
        'rating': 0.0,
        'distance': 0.0,
        'view_count': 0, // Add missing view_count field
        'provider_id': _userController.currentUser.value?.id,
        'business_id': widget.business.id,
        'company_id': _companyController.company.value?.id,
        'is_active': true,
        'created_at': DateTime.now(),
      };

      // Add type-specific fields based on service type
      if (_serviceType == 'Accommodation') {
        serviceData['bedroom_count'] = int.tryParse(_bedroomCountController.text) ?? 0;
        serviceData['bathroom_count'] = int.tryParse(_bathroomCountController.text) ?? 0;
        serviceData['has_kitchen'] = _hasKitchen;
        serviceData['property_type'] = _propertyTypeController.text;
        serviceData['characteristics'] = _selectedAccommodationCharacteristics;
      } else if (_serviceType == 'Food') {
        serviceData['cuisine'] = _cuisineController.text;
        serviceData['is_delivery_available'] = _isDeliveryAvailable;
        serviceData['food_category'] = _foodCategoryController.text;
        serviceData['caracteristics'] = _selectedCharacteristics;
      }

      final newService = ServiceItem(
        title: serviceData['title'],
        description: serviceData['description'],
        category: _selectedCategory!,
        categoryId: _selectedCategory!.id,
        images: [], // Will be updated after upload
        normalPrice: serviceData['normal_price'],
        promotionalPrice: serviceData['promotional_price'],
        rating: serviceData['rating'],
        distance: serviceData['distance'],
        bedroomCount: serviceData['bedroom_count'],
        bathroomCount: serviceData['bathroom_count'],
        hasKitchen: serviceData['has_kitchen'],
        propertyType: serviceData['property_type'],
        cuisine: serviceData['cuisine'],
        isDeliveryAvailable: serviceData['is_delivery_available'],
        foodCategory: serviceData['food_category'],
        caracteristics: _serviceType == 'Food'
            ? serviceData['caracteristics']
            : serviceData['characteristics'],
        providerId: serviceData['provider_id'],
        businessId: serviceData['business_id'],
        companyId: serviceData['company_id'],
        createdAt: serviceData['created_at'],
        isActive: serviceData['is_active'],
        currency: widget.business.currency,
      );

      // Save images for potential retry
      _pendingImages = _selectedImages.toList();

      final result = await _servicesController.addService(
        newService,
        images: _selectedImages.isNotEmpty ? _selectedImages : null,
      );

      _isLoading.value = false;

      if (result) {
        _createdServiceId = newService.id;
        if (_servicesController.hasUploadFailed.value) {
          // Show retry dialog
          _showRetryDialog();
        } else {
          // Get.back();
        }
      } else {
        _utility.showSnack('Error', 'Failed to add service', 3, true);
      }
    } catch (e) {
      _isLoading.value = false;
      _utility.showSnack('Error', 'An error occurred: $e', 3, true);
    }
  }

  void _showRetryDialog() {
    Get.dialog(
      RetryUploadDialog(
        onRetry: () async {
          await _retryImageUpload();
        },
      ),
    );
  }

  Future<void> _retryImageUpload() async {
    if (_createdServiceId == null || _pendingImages.isEmpty) return;

    // Create a local variable to ensure non-null value
    final serviceId = _createdServiceId!;

    final result = await _servicesController.uploadFiles(_pendingImages, serviceId);

    if (result) {
      Get.back(); // Return to previous screen
    }
  }

  Widget _buildServiceTypeSelector() {
    return ServiceTypeSelector(
      serviceType: _serviceType,
      onServiceTypeChanged: (value) {
        setState(() {
          _serviceType = value;
        });
      },
    );
  }

  Widget _buildCategorySelector() {
    return ServiceCategorySelector(
      category: widget.business.category!,
    );
  }

  Widget _buildAccommodationFields() {
    if (_serviceType != 'Accommodation') return Container();

    return ServiceAccommodationFields(
      bedroomCountController: _bedroomCountController,
      bathroomCountController: _bathroomCountController,
      propertyTypeController: _propertyTypeController,
      characteristicController: _accommodationCharacteristicController,
      propertyTypes: _propertyTypes,
      selectedCharacteristics: _selectedAccommodationCharacteristics,
      hasKitchen: _hasKitchen,
      onHasKitchenChanged: (value) {
        setState(() {
          _hasKitchen = value;
        });
      },
      onCharacteristicAdded: (characteristic) {
        setState(() {
          _selectedAccommodationCharacteristics.add(characteristic);
        });
      },
      onCharacteristicRemoved: (characteristic) {
        setState(() {
          _selectedAccommodationCharacteristics.remove(characteristic);
        });
      },
    );
  }

  Widget _buildFoodFields() {
    if (_serviceType != 'Food') return Container();

    return ServiceFoodFields(
      cuisineController: _cuisineController,
      foodCategoryController: _foodCategoryController,
      characteristicController: _characteristicController,
      foodCategories: _foodCategories,
      selectedCharacteristics: _selectedCharacteristics,
      isDeliveryAvailable: _isDeliveryAvailable,
      onDeliveryAvailableChanged: (value) {
        setState(() {
          _isDeliveryAvailable = value;
        });
      },
      onCharacteristicAdded: (characteristic) {
        setState(() {
          _selectedCharacteristics.add(characteristic);
        });
      },
      onCharacteristicRemoved: (characteristic) {
        setState(() {
          _selectedCharacteristics.remove(characteristic);
        });
      },
    );
  }

  Widget _buildPriceFields() {
    return ServicePriceFields(
      normalPriceController: _normalPriceController,
      promotionalPriceController: _promotionalPriceController,
    );
  }

  Widget _buildImageCarousel() {
    return EditableImageCarousel(
      selectedImages: _selectedImages,
      currentImageIndex: _currentImageIndex,
      existingImages: const [], // Empty for new service
      onPickImages: _pickImages,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: CustomText(
          text: 'Add New Service',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: whiteColor,
        ),
        backgroundColor: firstColor.withValues(alpha: 0.9),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: whiteColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Replace the old image selection with the new carousel
              _buildImageCarousel(),

              // Form Sections
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Service Type Selection
                    _buildServiceTypeSelector(),
                    const SizedBox(height: 16),

                    // Category Selection
                    _buildCategorySelector(),
                    const SizedBox(height: 16),

                    // Basic Service Information
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            spreadRadius: 1,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info, color: firstColor),
                              const SizedBox(width: 10),
                              CustomText(
                                text: "Basic Information",
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: blackColor,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          CustomText(
                            text: "Service Title",
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: blackColor,
                          ),
                          const SizedBox(height: 8),
                          CustomTextField(
                            hintText: "Enter service title",
                            borderColor: blackColor.withValues(alpha: 0.1),
                            radius: 10,
                            controller: _titleController,
                            prefixIcon: Icon(Icons.title, color: firstColor),
                            validator: (value) {
                              if (value!.isEmpty) return "Title is required";
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          CustomText(
                            text: "Description",
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: blackColor,
                          ),
                          const SizedBox(height: 8),
                          CustomTextField(
                            hintText: "Enter service description",
                            controller: _descriptionController,
                            maxLines: 4,
                            radius: 10,
                            borderColor: blackColor.withValues(alpha: 0.1),
                            prefixIcon:
                                Icon(Icons.description, color: firstColor),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Description is required";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          _buildPriceFields(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Accommodation specific fields
                    _buildAccommodationFields(),

                    // Food specific fields
                    _buildFoodFields(),

                    const SizedBox(height: 24),

                    // Save Button
                    CommonButton(
                      text: 'Save Service',
                      width: double.infinity,
                      isLoading: _isLoading,
                      onTap: _saveService,
                      textColor: whiteColor,
                      bgColor: firstColor,
                      verticalPadding: 15,
                      radius: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
