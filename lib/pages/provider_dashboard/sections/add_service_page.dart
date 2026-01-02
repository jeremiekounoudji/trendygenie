import 'dart:developer';

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
import 'package:flutter_popup/flutter_popup.dart';
import 'services/widgets/service_price_fields.dart';

class AddServicePage extends StatefulWidget {
  final BusinessModel  business;

  const AddServicePage({
    super.key,
    required this.business,
  });

  @override
  State<AddServicePage> createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  final ServicesController _servicesController = Get.find<ServicesController>();
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

  File? _selectedImage;
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
  final List<String> _availableCharacteristics = [
    'Vegetarian',
    'Vegan',
    'Gluten Free',
    'Dairy Free',
    'Nut Free',
    'Organic'
  ];
  final List<String> _selectedCharacteristics = [];

  // Service type
  String _serviceType = 'General';

  @override
  void initState() {
    super.initState();
    _loadCategories();
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

  Future<void> _loadCategories() async {
    await _categoryController.fetchCategories();
    _categories.value = _categoryController.categories;
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  bool _validateForm() {
    if (_formKey.currentState?.validate() != true) {
      return false;
    }

    if (_selectedCategory == null) {
      _utility.showSnack(
          'Error', 'Please select a category for your service', 3, true);
      return false;
    }

    if (_selectedImage == null) {
      _utility.showSnack('Warning',
          'No image selected. Your service will use a default image.', 3, true);
      // Still allow form submission without image
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
      log("business id");

    if (!_validateForm()) return;

    try {
      _isLoading.value = true;
      log(widget.business.id.toString(),name: 'business id');

      // In a real app, you would upload the image to storage
      // and get the URL. For this example, we'll use a placeholder
      String imageUrl = _selectedImage != null
          ? 'https://via.placeholder.com/300' // Replace with actual image upload
          : 'https://via.placeholder.com/300';

      // Basic service details
      final Map<String, dynamic> serviceData = {
        'id': DateTime.now()
            .millisecondsSinceEpoch
            .toString(), // Temporary ID, will be replaced by database
        'title': _titleController.text,
        'description': _descriptionController.text,
        'normal_price': double.parse(_normalPriceController.text),
        'promotional_price': double.parse(_promotionalPriceController.text),
        'rating': 0.0, // New service starts with no rating
        'distance': 0.0, // This would be calculated based on location
        'provider_id': _userController
            .currentUser.value?.id, // Changed from providerId to provider_id
        'business_id': widget.business.id, // Added business_id
        'company_id': _companyController.company.value?.id, // Added company_id
        'is_active': true, // Changed from isActive to is_active
        'created_at': DateTime.now(),
      };

      // Add type-specific fields based on service type
      if (_serviceType == 'Accommodation') {
        serviceData['bedroom_count'] =
            int.tryParse(_bedroomCountController.text) ??
                0; // Changed from bedroomCount to bedroom_count
        serviceData['bathroom_count'] =
            int.tryParse(_bathroomCountController.text) ??
                0; // Changed from bathroomCount to bathroom_count
        serviceData['has_kitchen'] =
            _hasKitchen; // Changed from hasKitchen to has_kitchen
        serviceData['property_type'] = _propertyTypeController
            .text; // Changed from propertyType to property_type
      } else if (_serviceType == 'Food') {
        serviceData['cuisine'] = _cuisineController.text;
        serviceData['is_delivery_available'] =
            _isDeliveryAvailable; // Changed from isDeliveryAvailable to is_delivery_available
        serviceData['food_category'] = _foodCategoryController
            .text; // Changed from foodCategory to food_category
        serviceData['caracteristics'] =
            _selectedCharacteristics; // Changed from caracteristics
      }

      final newService = ServiceItem(
        id: serviceData['id'],
        title: serviceData['title'],
        description: serviceData['description'],
        category: _selectedCategory!,
        categoryId: _selectedCategory!.id,
        images: [imageUrl],
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
        caracteristics: serviceData['caracteristics'],
        providerId: serviceData['provider_id'],
        businessId: serviceData['business_id'],
        companyId: serviceData['company_id'],
        createdAt: serviceData['created_at'],
        isActive: serviceData['is_active'],
      );

      final result = await _servicesController.addService(newService);

      _isLoading.value = false;

      if (result) {
        _utility.showSnack('Success', 'Service added successfully', 3, false);
        Get.back();
      } else {
        _utility.showSnack('Error', 'Failed to add service', 3, true);
      }
    } catch (e) {
      _isLoading.value = false;
      _utility.showSnack('Error', 'An error occurred: $e', 3, true);
    }
  }

  Widget _buildServiceTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: firstColor.withOpacity(0.1),
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
              Icon(Icons.category, color: firstColor),
              const SizedBox(width: 10),
              CustomText(
                text: "Service Type",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
            ],
          ),
          const SizedBox(height: 15),
          Column(
            children: [
              RadioListTile<String>(
                title: CustomText(
                  text: 'General',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: blackColor,
                ),
                value: 'General',
                groupValue: _serviceType,
                activeColor: firstColor,
                onChanged: (value) {
                  setState(() {
                    _serviceType = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: CustomText(
                  text: 'Accommodation',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: blackColor,
                ),
                value: 'Accommodation',
                groupValue: _serviceType,
                activeColor: firstColor,
                onChanged: (value) {
                  setState(() {
                    _serviceType = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: CustomText(
                  text: 'Food',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: blackColor,
                ),
                value: 'Food',
                groupValue: _serviceType,
                activeColor: firstColor,
                onChanged: (value) {
                  setState(() {
                    _serviceType = value!;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: blackColor.withOpacity(0.1),
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
              Icon(Icons.category, color: firstColor),
              const SizedBox(width: 10),
              CustomText(
                text: "Service Category",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
            ],
          ),
          const SizedBox(height: 15),
          Obx(() {
            if (_categoryController.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(color: firstColor),
              );
            }

            return CustomPopup(
              barrierColor: Colors.black12,
              backgroundColor: whiteColor,
              arrowColor: whiteColor,
              showArrow: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              contentDecoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                  ),
                ],
              ),
              content: Container(
                constraints: const BoxConstraints(maxHeight: 200),
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _categories
                        .map(
                          (category) => InkWell(
                            onTap: () {
                              setState(() {
                                _selectedCategory = category;
                              });
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.withOpacity(0.1),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    category.name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color:
                                          _selectedCategory?.id == category.id
                                              ? firstColor
                                              : blackColor,
                                    ),
                                  ),
                                  if (_selectedCategory?.id == category.id)
                                    Icon(Icons.check,
                                        color: firstColor, size: 20),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedCategory != null
                          ? _selectedCategory!.name
                          : "Select Category",
                      style: TextStyle(
                        fontSize: 16,
                        color: _selectedCategory != null
                            ? blackColor
                            : Colors.grey,
                      ),
                    ),
                    Icon(Icons.arrow_drop_down, color: firstColor),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAccommodationFields() {
    if (_serviceType != 'Accommodation') return Container();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
              Icon(Icons.hotel, color: firstColor),
              const SizedBox(width: 10),
              CustomText(
                text: "Accommodation Details",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Bedrooms",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: blackColor,
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hintText: "Number of bedrooms",
                      controller: _bedroomCountController,
                      inputType: TextInputType.number,
                      borderColor: blackColor.withOpacity(0.1),
                      prefixIcon: Icon(Icons.bed, color: firstColor),
                      radius: 10,
                      validator: (value) {
                        if (value!.isEmpty) return "Required";
                        if (int.tryParse(value) == null) {
                          return "Enter a number";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Bathrooms",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: blackColor,
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hintText: "Number of bathrooms",
                      controller: _bathroomCountController,
                      borderColor: blackColor.withOpacity(0.1),
                      inputType: TextInputType.number,
                      radius: 10,
                      prefixIcon: Icon(Icons.bathtub, color: firstColor),
                      validator: (value) {
                        if (value!.isEmpty) return "Required";
                        if (int.tryParse(value) == null) {
                          return "Enter a number";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          CustomText(
            text: "Property Type",
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: blackColor,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(color: blackColor.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                hint: const Text("Select property type"),
                value: _propertyTypeController.text.isNotEmpty
                    ? _propertyTypeController.text
                    : null,
                items: _propertyTypes
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _propertyTypeController.text = value!;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 15),
          CheckboxListTile(
            title: CustomText(
              text: "Has Kitchen",
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: blackColor,
            ),
            value: _hasKitchen,
            activeColor: firstColor,
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (value) {
              setState(() {
                _hasKitchen = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFoodFields() {
    if (_serviceType != 'Food') return Container();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
              Icon(Icons.restaurant, color: firstColor),
              const SizedBox(width: 10),
              CustomText(
                text: "Food Service Details",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
            ],
          ),
          const SizedBox(height: 20),
          CustomText(
            text: "Cuisine",
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: blackColor,
          ),
          const SizedBox(height: 8),
          CustomTextField(
            hintText: "e.g. Italian, Chinese, Mexican",
            controller: _cuisineController,
            radius: 10,
            prefixIcon: Icon(Icons.restaurant_menu, color: firstColor),
            borderColor: blackColor.withOpacity(0.1),
            validator: (value) {
              if (value!.isEmpty) return "Cuisine is required";
              return null;
            },
          ),
          const SizedBox(height: 15),
          CustomText(
            text: "Food Category",
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: blackColor,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(color: blackColor.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                hint: const Text("Select food category"),
                value: _foodCategoryController.text.isNotEmpty
                    ? _foodCategoryController.text
                    : null,
                items: _foodCategories
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _foodCategoryController.text = value!;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 15),
          CheckboxListTile(
            title: CustomText(
              text: "Delivery Available",
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: blackColor,
            ),
            value: _isDeliveryAvailable,
            activeColor: firstColor,
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (value) {
              setState(() {
                _isDeliveryAvailable = value!;
              });
            },
          ),
          const SizedBox(height: 15),
          CustomText(
            text: "Dietary Options",
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: blackColor,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableCharacteristics
                .map((option) => FilterChip(
                      label: Text(option),
                      selected: _selectedCharacteristics.contains(option),
                      selectedColor: firstColor.withOpacity(0.2),
                      checkmarkColor: firstColor,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedCharacteristics.add(option);
                          } else {
                            _selectedCharacteristics.remove(option);
                          }
                        });
                      },
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceFields() {
    return ServicePriceFields(
      normalPriceController: _normalPriceController,
      promotionalPriceController: _promotionalPriceController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'Add New Service',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: whiteColor,
        ),
        backgroundColor: firstColor.withOpacity(0.9),
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
              // Image Upload Section
              InkWell(
                onTap: _pickImage,
                child: Container(
                  margin: const EdgeInsets.all(10),
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: whiteColor.withOpacity(0.2),
                    border: Border.all(color: firstColor.withOpacity(0.8)),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    image: _selectedImage != null
                        ? DecorationImage(
                            image: FileImage(_selectedImage!),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.1),
                              BlendMode.srcOver,
                            ),
                          )
                        : null,
                  ),
                  child: _selectedImage == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              size: 40,
                              color: firstColor,
                            ),
                            const SizedBox(height: 15),
                            CustomText(
                              text: "Add Service Image",
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: firstColor,
                            ),
                            const SizedBox(height: 8),
                            CustomText(
                              text:
                                  "Upload a high-quality image to attract customers",
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: greyColor,
                            ),
                          ],
                        )
                      : null,
                ),
              ),

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
                            color: Colors.black.withOpacity(0.1),
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
