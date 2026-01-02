import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

import '../../../../controllers/services_controller.dart';
import '../../../../models/business_model.dart';
import '../../../../models/service_item.dart';
import '../../../../models/enums.dart';
import '../../../../utils/globalVariable.dart';
import '../../../../utils/currency_helper.dart';
import '../../../../utils/utility.dart';
import '../../../../widgets/general_widgets/textfield.dart';
import '../../../../widgets/general_widgets/common_button.dart';
import 'widgets/service_accommodation_fields.dart';
import 'widgets/service_food_fields.dart';
import 'widgets/service_price_fields.dart';
import 'widgets/editable_image_carousel.dart';

class EditServicePage extends StatefulWidget {
  final BusinessModel business;
  final ServiceItem service;

  const EditServicePage({
    super.key,
    required this.business,
    required this.service,
  });

  @override
  State<EditServicePage> createState() => _EditServicePageState();
}

class _EditServicePageState extends State<EditServicePage> {
  final ServicesController _servicesController = Get.find<ServicesController>();
  final Utility _utility = Get.put(Utility());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Form controllers
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _normalPriceController;
  late TextEditingController _promotionalPriceController;
  late TextEditingController _bedroomCountController;
  late TextEditingController _bathroomCountController;
  late TextEditingController _propertyTypeController;
  late TextEditingController _cuisineController;
  late TextEditingController _foodCategoryController;

  // Form state
  final RxBool _hasKitchen = false.obs;
  final RxBool _isDeliveryAvailable = false.obs;
  final RxList<String> _characteristics = <String>[].obs;
  final RxString _propertyType = ''.obs;
  final RxString _foodCategory = ''.obs;
  final RxString _cuisine = ''.obs;

  // Store original values for comparison
  late final List<String> _originalCharacteristics;

  final RxInt _currentImageIndex = 0.obs;
  final RxList<File> _selectedImages = <File>[].obs;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing service data
    _titleController = TextEditingController(text: widget.service.title);
    _descriptionController = TextEditingController(text: widget.service.description);
    _normalPriceController = TextEditingController(text: widget.service.normalPrice.toString());
    _promotionalPriceController = TextEditingController(text: widget.service.promotionalPrice.toString());
    _bedroomCountController = TextEditingController(text: widget.service.bedroomCount?.toString() ?? '');
    _bathroomCountController = TextEditingController(text: widget.service.bathroomCount?.toString() ?? '');
    _propertyTypeController = TextEditingController(text: widget.service.propertyType ?? '');
    _cuisineController = TextEditingController(text: widget.service.cuisine ?? '');
    _foodCategoryController = TextEditingController(text: widget.service.foodCategory ?? '');

    // Initialize state
    _hasKitchen.value = widget.service.hasKitchen ?? false;
    _isDeliveryAvailable.value = widget.service.isDeliveryAvailable ?? false;
    
    // Store original characteristics for comparison (create independent copy)
    _originalCharacteristics = List<String>.from(widget.service.caracteristics ?? []);
    _characteristics.value = List<String>.from(widget.service.caracteristics ?? []);
    
    // Determine service type based on existing data
    if (widget.service.propertyType != null || 
        widget.service.bedroomCount != null || 
        widget.service.bathroomCount != null ||
        widget.service.hasKitchen != null) {
      _propertyType.value = widget.service.propertyType ?? 'Apartment';
    }
    
    if (widget.service.foodCategory != null || 
        widget.service.cuisine != null || 
        widget.service.isDeliveryAvailable != null) {
      _foodCategory.value = widget.service.foodCategory ?? 'Restaurant';
      _cuisine.value = widget.service.cuisine ?? '';
    }
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
    super.dispose();
  }

  Map<String, dynamic> _getUpdatedFields() {
    final updates = <String, dynamic>{};

    // Only add fields that have changed
    if (_titleController.text != widget.service.title) {
      updates['title'] = _titleController.text;
    }
    if (_descriptionController.text != widget.service.description) {
      updates['description'] = _descriptionController.text;
    }
    if (_normalPriceController.text != widget.service.normalPrice.toString()) {
      updates['normal_price'] = double.tryParse(_normalPriceController.text) ?? 0.0;
    }
    if (_promotionalPriceController.text != widget.service.promotionalPrice.toString()) {
      updates['promotional_price'] = double.tryParse(_promotionalPriceController.text) ?? 0.0;
    }

    // Add accommodation-specific fields if they exist
    if (widget.service.propertyType != null || 
        widget.service.bedroomCount != null || 
        widget.service.bathroomCount != null ||
        widget.service.hasKitchen != null ||
        _propertyType.value.isNotEmpty) {
      
      if (_bedroomCountController.text != (widget.service.bedroomCount?.toString() ?? '')) {
        updates['bedroom_count'] = int.tryParse(_bedroomCountController.text);
      }
      if (_bathroomCountController.text != (widget.service.bathroomCount?.toString() ?? '')) {
        updates['bathroom_count'] = int.tryParse(_bathroomCountController.text);
      }
      if (_propertyTypeController.text != (widget.service.propertyType ?? '')) {
        updates['property_type'] = _propertyTypeController.text.isNotEmpty ? _propertyTypeController.text : null;
      }
      if (_hasKitchen.value != (widget.service.hasKitchen ?? false)) {
        updates['has_kitchen'] = _hasKitchen.value;
      }
    }

    // Add food-specific fields if they exist
    if (widget.service.foodCategory != null || 
        widget.service.cuisine != null || 
        widget.service.isDeliveryAvailable != null ||
        _foodCategory.value.isNotEmpty) {
      
      if (_foodCategoryController.text != (widget.service.foodCategory ?? '')) {
        updates['food_category'] = _foodCategoryController.text.isNotEmpty ? _foodCategoryController.text : null;
      }
      if (_cuisineController.text != (widget.service.cuisine ?? '')) {
        updates['cuisine'] = _cuisineController.text.isNotEmpty ? _cuisineController.text : null;
      }
      if (_isDeliveryAvailable.value != (widget.service.isDeliveryAvailable ?? false)) {
        updates['is_delivery_available'] = _isDeliveryAvailable.value;
      }
    }

    // Add caracteristics if they've changed
    final currentCharacteristics = _characteristics.toList();
    
    if (!listEquals(currentCharacteristics, _originalCharacteristics)) {
      updates['caracteristics'] = currentCharacteristics;
    }

    return updates;
  }

  Future<void> _handleUpdate() async {
    if (_formKey.currentState?.validate() == true) {
      final updates = _getUpdatedFields();
      
      if (updates.isEmpty && _selectedImages.isEmpty) {
        _utility.showSnack('Info', 'No changes detected', 3, false);
        return;
      }

      final success = await _servicesController.updateService(
        widget.service.id ?? '',
        updates,
        newImages: _selectedImages.isNotEmpty ? _selectedImages.toList() : null,
      );

      if (success && !_servicesController.hasUploadFailed.value) {
        // Get.back();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if service is pending deletion
    final bool isPendingDeletion = widget.service.status == ServiceStatus.requestDeletion.name;
    
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: blackColor),
          onPressed: () => Get.back(),
        ),
        title: CustomText(
          text: isPendingDeletion ? 'Service Deletion Request' : 'Edit Service',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: blackColor,
        ),
      ),
      body: isPendingDeletion ? _buildDeletionRequestView() : _buildEditView(),
      bottomNavigationBar: isPendingDeletion ? _buildCancelDeletionButton() : _buildUpdateButton(),
    );
  }

  Widget _buildDeletionRequestView() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Warning Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red),
                    const SizedBox(width: 10),
                    CustomText(
                      text: "Deletion Request Pending",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                CustomText(
                  text: "This service has been requested for deletion and is currently under admin review. You cannot edit the service while the deletion request is pending.",
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.red.withValues(alpha: 0.8),
                ),
                const SizedBox(height: 15),
                CustomText(
                  text: "If you want to keep this service, you can cancel the deletion request below.",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.red.withValues(alpha: 0.9),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Service Info (Read-only)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "Service Information",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: blackColor,
                ),
                const SizedBox(height: 15),
                _buildReadOnlyField("Title", widget.service.title),
                _buildReadOnlyField("Category", widget.service.category.name),
                _buildReadOnlyField("Price", CurrencyHelper.formatPrice(widget.service.promotionalPrice, widget.service.currency)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: CustomText(
              text: "$label:",
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          Expanded(
            child: CustomText(
              text: value,
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: blackColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditView() {
    return Obx(() => _servicesController.isLoading.value
        ? const Center(child: CircularProgressIndicator())
        : Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Carousel
                  EditableImageCarousel(
                    selectedImages: _selectedImages,
                    currentImageIndex: _currentImageIndex,
                    existingImages: widget.service.images,
                    onPickImages: _pickImages,
                  ),
                  const SizedBox(height: 24),

                  // Basic Information
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
                          controller: _titleController,
                          hintText: "Enter service title",
                          borderColor: blackColor.withValues(alpha: 0.1),
                          radius: 10,
                          prefixIcon: Icon(Icons.title, color: firstColor),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a title';
                            }
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
                          controller: _descriptionController,
                          hintText: "Enter service description",
                          borderColor: blackColor.withValues(alpha: 0.1),
                          radius: 10,
                          maxLines: 4,
                          prefixIcon: Icon(Icons.description, color: firstColor),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a description';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        // Category Display (not editable)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: firstColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.category, color: firstColor, size: 16),
                              const SizedBox(width: 8),
                              CustomText(
                                text: widget.service.category.name,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: firstColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Service Type Specific Fields
                  Obx(() {
                    // Show accommodation fields if service has accommodation data
                    final hasAccommodationData = _propertyType.value.isNotEmpty ||
                        widget.service.propertyType != null ||
                        widget.service.bedroomCount != null ||
                        widget.service.bathroomCount != null ||
                        widget.service.hasKitchen != null;
                    
                    if (hasAccommodationData) {
                      return Column(
                        children: [
                          ServiceAccommodationFields(
                            bedroomCountController: _bedroomCountController,
                            bathroomCountController: _bathroomCountController,
                            propertyTypeController: _propertyTypeController,
                            characteristicController: TextEditingController(),
                            propertyTypes: ['Apartment', 'House', 'Villa', 'Hotel Room', 'Cottage', 'Other'],
                            selectedCharacteristics: _characteristics.toList(),
                            hasKitchen: _hasKitchen.value,
                            onHasKitchenChanged: (value) => _hasKitchen.value = value,
                            onCharacteristicAdded: (value) {
                              _characteristics.add(value);
                              setState(() {}); // Trigger rebuild
                            },
                            onCharacteristicRemoved: (value) {
                              _characteristics.remove(value);
                              setState(() {}); // Trigger rebuild
                            },
                          ),
                          const SizedBox(height: 24),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  }),

                  Obx(() {
                    // Show food fields if service has food data
                    final hasFoodData = _foodCategory.value.isNotEmpty ||
                        widget.service.foodCategory != null ||
                        widget.service.cuisine != null ||
                        widget.service.isDeliveryAvailable != null;
                    
                    if (hasFoodData) {
                      return Column(
                        children: [
                          ServiceFoodFields(
                            cuisineController: _cuisineController,
                            foodCategoryController: _foodCategoryController,
                            characteristicController: TextEditingController(),
                            foodCategories: ['Restaurant', 'Fast Food', 'Cafe', 'Bakery', 'Food Truck', 'Other'],
                            selectedCharacteristics: _characteristics.toList(),
                            isDeliveryAvailable: _isDeliveryAvailable.value,
                            onDeliveryAvailableChanged: (value) => _isDeliveryAvailable.value = value,
                            onCharacteristicAdded: (value) {
                              _characteristics.add(value);
                              setState(() {}); // Trigger rebuild
                            },
                            onCharacteristicRemoved: (value) {
                              _characteristics.remove(value);
                              setState(() {}); // Trigger rebuild
                            },
                          ),
                          const SizedBox(height: 24),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  }),

                  // Price Fields
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
                            Icon(Icons.attach_money, color: firstColor),
                            const SizedBox(width: 10),
                            CustomText(
                              text: "Pricing Information",
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: blackColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ServicePriceFields(
                          normalPriceController: _normalPriceController,
                          promotionalPriceController: _promotionalPriceController,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ));
  }

  Widget _buildUpdateButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 90,
      decoration: BoxDecoration(
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: CommonButton(
        text: 'Update Service',
        onTap: _handleUpdate,
        bgColor: firstColor,
        radius: 12,
        textColor: whiteColor,
      ),
    );
  }

  Widget _buildCancelDeletionButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 90,
      decoration: BoxDecoration(
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: CommonButton(
        text: 'Cancel Delete Request',
        onTap: _handleCancelDeletion,
        bgColor: Colors.orange,
        radius: 12,
        textColor: whiteColor,
      ),
    );
  }

  Future<void> _handleCancelDeletion() async {
    final updatedService = await _servicesController.cancelServiceDeletion(widget.service.id ?? '');
    
    if (updatedService != null) {
      Get.back(); // Return to previous screen
    }
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
} 