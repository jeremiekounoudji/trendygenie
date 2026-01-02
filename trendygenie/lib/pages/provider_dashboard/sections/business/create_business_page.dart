import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trendygenie/controllers/company_controller.dart';
import '../../../../controllers/business_controller.dart';
import '../../../../controllers/category_controller.dart';
import '../../../../utils/globalVariable.dart';
import '../../../../widgets/general_widgets/textfield.dart';
import '../../../../widgets/general_widgets/common_button.dart';
import '../../../../models/business_model.dart';
import '../../../../models/enums.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'widgets/location_section.dart';
import 'widgets/currency_selector.dart';
import 'widgets/business_hours_section.dart';

class CreateBusinessPage extends StatefulWidget {
  const CreateBusinessPage({super.key});

  @override
  State<CreateBusinessPage> createState() => _CreateBusinessPageState();
}

class _CreateBusinessPageState extends State<CreateBusinessPage> {
  final BusinessController businessController = Get.find<BusinessController>();
  final CompanyController companyController = Get.find<CompanyController>();
  final CategoryController categoryController = Get.find<CategoryController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  
  // List to store phone number controllers
  final List<TextEditingController> phoneControllers = [TextEditingController()];
  
  // Loading state
  final RxBool isLoading = false.obs;
  
  String? selectedCategoryId;
  String? logoUrl;
  String selectedCurrency = 'NGN'; // Default to Naira
  List<String> businessHours = [];

  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  
  final List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void initState() {
    super.initState();
    categoryController.fetchCategories();
  }
  
  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    addressController.dispose();
    emailController.dispose();
    for (var controller in phoneControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void addPhoneField() {
    setState(() {
      phoneControllers.add(TextEditingController());
    });
  }

  void removePhoneField(int index) {
    setState(() {
      phoneControllers[index].dispose();
      phoneControllers.removeAt(index);
    });
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        // TODO: Upload image to storage and get URL
        // For now, we'll just update the UI
        setState(() {
          logoUrl = image.path;
        });
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: ${e.toString()}',
        backgroundColor: redColor.withOpacity(0.8),
        colorText: whiteColor,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
      );
    }
  }

  Widget _buildCategorySelection() {
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
              Icon(Icons.category, color: firstColor),
              const SizedBox(width: 10),
              CustomText(
                text: "Business Category",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
            ],
          ),
          const SizedBox(height: 15),
          
          Obx(() {
            final categories = categoryController.categories;
            return CustomPopup(
              barrierColor: Colors.black12,
              backgroundColor: whiteColor,
              arrowColor: whiteColor,
              showArrow: true,
              // arrowHeight: 10,
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
                    children: categories.map((category) => 
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedCategoryId = category.id;
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.withOpacity(0.1),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                category.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: selectedCategoryId == category.id 
                                    ? firstColor 
                                    : blackColor,
                                ),
                              ),
                              if (selectedCategoryId == category.id)
                                Icon(Icons.check, color: firstColor, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ).toList(),
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
                      selectedCategoryId != null 
                        ? categories.firstWhere((cat) => cat.id == selectedCategoryId).name
                        : "Select Category",
                      style: TextStyle(
                        fontSize: 16,
                        color: selectedCategoryId != null ? blackColor : Colors.grey,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: firstColor.withOpacity(0.9),
        title: CustomText(
          text: "Create New Business",
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: whiteColor,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: whiteColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top curved section with logo selection
            InkWell(
              onTap: _pickImage,
              child: Container(
                margin: const EdgeInsets.all(10),
                width: double.infinity,
                height: 200, // Fixed height for better proportions
                decoration: BoxDecoration(
                  color: whiteColor.withOpacity(0.2),
                  border: Border.all(color: firstColor.withOpacity(0.8),),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  image: logoUrl != null
                    ? DecorationImage(
                        image: FileImage(File(logoUrl!)),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          firstColor.withOpacity(0.1),
                          BlendMode.srcOver,
                        ),
                      )
                    : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_a_photo,
                      size: 30,
                      color: firstColor,
                    ),
                    const SizedBox(height: 15),
                    CustomText(
                      text: logoUrl != null ? "Change Business Logo" : "Add Business Logo",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: firstColor,
                    ),
                  ],
                ),
              ),
            ),
            
            // Form Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Business Details Section
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
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
                              Icon(Icons.business, color: firstColor),
                              const SizedBox(width: 10),
                              CustomText(
                                text: "Business Details",
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: blackColor.withOpacity(.6),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          
                          CustomTextField(
                            controller: nameController,
                            hintText: "Business Name",
                            borderColor: greyColor,
                            prefixIcon: Icon(Icons.store, color: firstColor),
                            radius: 8,
                            maxLines: 1,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Business name is required";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          
                          CustomTextField(
                            controller: descriptionController,
                            hintText: "Business Description",
                            prefixIcon: Icon(Icons.description, color: firstColor),
                            maxLines: 3,
                            borderColor: greyColor,
                            radius: 8,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Description is required";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          
                          CustomTextField(
                            controller: addressController,
                            hintText: "Business Address",
                            borderColor: greyColor,
                            prefixIcon: Icon(Icons.location_on, color: firstColor),
                            radius: 8,
                            maxLines: 1,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Address is required";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Category Selection Section
                    _buildCategorySelection(),
                    
                    const SizedBox(height: 20),
                    
                    // Currency Selection Section
                    CurrencySelector(
                      selectedCurrency: selectedCurrency,
                      onCurrencyChanged: (currency) {
                        setState(() {
                          selectedCurrency = currency;
                        });
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Contact Information Section
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
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
                              Icon(Icons.contact_phone, color: firstColor),
                              const SizedBox(width: 10),
                              CustomText(
                                text: "Contact Information",
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: blackColor,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          
                          CustomTextField(
                            controller: emailController,
                            hintText: "Contact Email",
                            borderColor: greyColor,
                            prefixIcon: Icon(Icons.email, color: firstColor),
                            inputType: TextInputType.emailAddress,
                            radius: 8,
                            maxLines: 1,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Email is required";
                              } else if (!GetUtils.isEmail(value)) {
                                return "Please enter a valid email";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(

                                text: "Phone Numbers",
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: blackColor,
                              ),
                              IconButton(
                                icon: Icon(Icons.add_circle, color: firstColor),
                                onPressed: addPhoneField,
                              ),
                            ],
                          ),
                          
                          ...List.generate(
                            phoneControllers.length,
                            (index) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      borderColor: greyColor,
                                      controller: phoneControllers[index],
                                      hintText: "Phone Number ${index + 1}",
                                      prefixIcon: Icon(Icons.phone, color: firstColor),
                                      inputType: TextInputType.phone,
                                      radius: 8,
                                      maxLines: 1,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Phone number is required";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  if (phoneControllers.length > 1)
                                    IconButton(
                                      icon: Icon(Icons.remove_circle, color: redColor),
                                      onPressed: () => removePhoneField(index),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    LocationSection(
                      latitudeController: latitudeController,
                      longitudeController: longitudeController,
                      businessController: businessController,
                      onGetLocation: _getCurrentLocation,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Business Hours Section
                    BusinessHoursSection(
                      businessHours: businessHours,
                      onBusinessHoursChanged: (hours) => setState(() => businessHours = hours),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Submit Button
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: CommonButton(
                        text: "Create Business",
                        textColor: whiteColor,
                        bgColor: firstColor,
                        width: double.infinity,
                        verticalPadding: 15,
                        radius: 10,
                        isLoading: isLoading,
                        onTap: _submitForm,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (selectedCategoryId == null) {
        Get.snackbar(
          'Error',
          'Please select a business category',
          backgroundColor: redColor.withOpacity(0.8),
          colorText: whiteColor,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(10),
          borderRadius: 10,
        );
        return;
      }
      
      isLoading.value = true;
      final business = BusinessModel(
        name: nameController.text,
        description: descriptionController.text,
        address: addressController.text,
        contactEmail: emailController.text,
        contactPhone: phoneControllers.map((controller) => controller.text).toList(),
        companyId: companyController.company.value!.id!,
        status: BusinessStatus.pending,
        categoryId: selectedCategoryId,
        logoUrl: logoUrl,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        businessHours: businessHours,
        latitude: double.tryParse(latitudeController.text),
        longitude: double.tryParse(longitudeController.text),
        currency: selectedCurrency,
      );

      // Store logo file path for retry if needed
      final String? tempLogoPath = logoUrl;
      XFile? logoFile = tempLogoPath != null ? XFile(tempLogoPath) : null;

      bool isCreated = await businessController.createBusiness(business.toJson(), logo: logoFile);
      debugPrint('isCreated: $isCreated');
      
      if(isCreated) {
        // If business was created but logo upload failed, show retry button
        if (businessController.error.value.contains('logo upload failed')) {
          Get.dialog(
            AlertDialog(
              title: CustomText(
                text: 'Logo Upload Failed',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    text: 'Business was created successfully but the logo upload failed. Would you like to retry uploading the logo?',
                    fontSize: 14,
                    color: blackColor,
                    fontWeight: FontWeight.normal,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Get.back(); // Close dialog
                          Get.back(); // Go back to previous screen
                        },
                        child: CustomText(
                          text: 'Skip',
                          fontSize: 14,
                          color: greyColor,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(width: 10),
                      CommonButton(
                        text: 'Retry Upload',
                        textColor: whiteColor,
                        bgColor: firstColor,
                        onTap: () async {
                          if (logoFile != null) {
                            // Get the created business ID from the response
                            final createdBusiness = businessController.businesses
                                .firstWhere((b) => b.name == business.name);
                            
                            await businessController.updateBusiness(
                              createdBusiness.id!,
                              {},  // No other fields to update
                              logo: logoFile
                            );
                          }
                          Get.back(); // Close dialog
                          Get.back(); // Go back to previous screen
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else {
          Get.back(); // Pop the create business page after successful creation
        }
        isLoading.value = false;
      } else {
        isLoading.value = false;
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    final location = await businessController.getLocation();
    if (location != null) {
      latitudeController.text = location['latitude']!.toString();
      longitudeController.text = location['longitude']!.toString();
    }
  }
} 