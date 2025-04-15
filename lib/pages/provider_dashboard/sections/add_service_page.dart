import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../controllers/services_controller.dart';
import '../../../controllers/category_controller.dart';
import '../../../models/service_item.dart';
import '../../../models/category_model.dart';
import '../../../utils/globalVariable.dart';
import '../../../utils/utility.dart';
import '../../../widgets/general_widgets/textfield.dart';
import '../../../widgets/general_widgets/common_button.dart';

class AddServicePage extends StatefulWidget {
  final String businessId;
  
  const AddServicePage({
    Key? key,
    required this.businessId,
  }) : super(key: key);

  @override
  State<AddServicePage> createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  final ServicesController _servicesController = Get.find<ServicesController>();
  final CategoryController _categoryController = Get.put(CategoryController());
  final Utility _utility = Get.put(Utility());
  
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  
  File? _selectedImage;
  SubCategoryModel? _selectedCategory;
  final RxBool _isLoading = false.obs;
  final RxList<SubCategoryModel> _subCategories = <SubCategoryModel>[].obs;
  
  @override
  void initState() {
    super.initState();
    _loadCategories();
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }
  
  Future<void> _loadCategories() async {
    await _categoryController.fetchCategories();
    await _categoryController.fetchSubCategories();
    _subCategories.value = _categoryController.subCategories;
  }
  
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }
  
  bool _validateForm() {
    if (_titleController.text.isEmpty) {
      _utility.showSnack('Error', 'Please enter a title for your service', 3, true);
      return false;
    }
    
    if (_descriptionController.text.isEmpty) {
      _utility.showSnack('Error', 'Please enter a description for your service', 3, true);
      return false;
    }
    
    if (_priceController.text.isEmpty) {
      _utility.showSnack('Error', 'Please enter a price for your service', 3, true);
      return false;
    }
    
    if (_selectedCategory == null) {
      _utility.showSnack('Error', 'Please select a category for your service', 3, true);
      return false;
    }
    
    return true;
  }
  
  Future<void> _saveService() async {
    if (!_validateForm()) return;
    
    try {
      _isLoading.value = true;
      
      // In a real app, you would upload the image to storage
      // and get the URL. For this example, we'll use a placeholder
      String imageUrl = _selectedImage != null 
          ? 'https://via.placeholder.com/300' // Replace with actual image upload
          : 'https://via.placeholder.com/300';
      
      final newService = ServiceItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Temporary ID, will be replaced by database
        title: _titleController.text,
        description: _descriptionController.text,
        category: _selectedCategory!,
        image: imageUrl,
        price: double.parse(_priceController.text),
        rating: 0.0, // New service starts with no rating
        distance: 0.0, // This would be calculated based on location
        providerId: widget.businessId,
        isActive: true,
        createdAt: DateTime.now(),
      );
      
      final result = await _servicesController.addService(newService);
      
      _isLoading.value = false;
      
      if (result) {
        _utility.showSnack('Success', 'Service added successfully', 3);
        Get.back();
      } else {
        _utility.showSnack('Error', 'Failed to add service', 3, true);
      }
    } catch (e) {
      _isLoading.value = false;
      _utility.showSnack('Error', 'An error occurred: $e', 3, true);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'Add New Service',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: blackColor,
        ),
        backgroundColor: whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: blackColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'Service Information',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: blackColor,
            ),
            const SizedBox(height: 24),
            
            // Image Upload
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    image: _selectedImage != null
                        ? DecorationImage(
                            image: FileImage(_selectedImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _selectedImage == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey[400]),
                            const SizedBox(height: 8),
                            CustomText(
                              text: 'Add Service Image',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600]!,
                            ),
                          ],
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Title
            CustomText(
              text: 'Service Title',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: blackColor,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              hintText: 'Enter service title',
              controller: _titleController,
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            
            // Description
            CustomText(
              text: 'Description',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: blackColor,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              hintText: 'Enter service description',
              controller: _descriptionController,
              onChanged: (value) {},
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            
            // Price
            CustomText(
              text: 'Price',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: blackColor,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              hintText: 'Enter price',
              controller: _priceController,
              onChanged: (value) {},
              inputType: TextInputType.number,
              prefixIcon: Icon(Icons.attach_money, color: firstColor),
            ),
            const SizedBox(height: 16),
            
            // Category Dropdown
            CustomText(
              text: 'Category',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: blackColor,
            ),
            const SizedBox(height: 8),
            Obx(() {
              if (_categoryController.isLoading.value) {
                return Container(
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Center(
                    child: CircularProgressIndicator(color: firstColor),
                  ),
                );
              }
              
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                  color: whiteColor,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<SubCategoryModel>(
                    isExpanded: true,
                    hint: const Text('Select a category'),
                    value: _selectedCategory,
                    items: _subCategories
                        .map((category) => DropdownMenuItem(
                              value: category,
                              child: Text(category.name),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                ),
              );
            }),
            const SizedBox(height: 32),
            
            // Save Button
            Obx(() => CommonButton(
              text: 'Save Service',
              width: double.infinity,
              isLoading: _isLoading,
              onTap: _saveService,
              textColor: whiteColor,
              bgColor: firstColor,
            )),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
} 