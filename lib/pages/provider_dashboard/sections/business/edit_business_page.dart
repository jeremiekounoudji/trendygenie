import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../controllers/business_controller.dart';
import '../../../../controllers/category_controller.dart';
import '../../../../models/business_model.dart';
import '../../../../models/category_model.dart';
import '../../../../utils/globalVariable.dart';
import '../../../../utils/utility.dart';
import '../../../../widgets/general_widgets/common_button.dart';
import '../../../../widgets/general_widgets/success_bottom_sheet.dart';
import 'widgets/business_logo_section.dart';
import 'widgets/business_details_section.dart';
import 'widgets/category_selector.dart';
import 'widgets/currency_selector.dart';
import 'widgets/contact_info_section.dart';
import 'widgets/location_section.dart';
import 'widgets/business_hours_section.dart';

class EditBusinessPage extends StatefulWidget {
  final BusinessModel business;
  const EditBusinessPage({super.key, required this.business});
  @override
  State<EditBusinessPage> createState() => _EditBusinessPageState();
}

class _EditBusinessPageState extends State<EditBusinessPage> {
  final BusinessController businessController = Get.find<BusinessController>();
  final CategoryController categoryController = Get.find<CategoryController>();
  final Utility utilityController = Get.put(Utility());
  final formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();

  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController addressController;
  late TextEditingController emailController;
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;
  final List<TextEditingController> phoneControllers = [];

  CategoryModel? selectedCategory;
  XFile? logoImage;
  late String selectedCurrency;
  List<String> businessHours = [];
  final RxBool isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    _initControllers();
    if (categoryController.categories.isEmpty) categoryController.fetchCategories();
  }

  void _initControllers() {
    nameController = TextEditingController(text: widget.business.name);
    descriptionController = TextEditingController(text: widget.business.description);
    addressController = TextEditingController(text: widget.business.address);
    emailController = TextEditingController(text: widget.business.contactEmail);
    latitudeController = TextEditingController(text: widget.business.latitude?.toString() ?? '');
    longitudeController = TextEditingController(text: widget.business.longitude?.toString() ?? '');
    selectedCategory = widget.business.category;
    selectedCurrency = widget.business.currency;
    businessHours = List.from(widget.business.businessHours);
    if (widget.business.contactPhone.isNotEmpty) {
      for (String phone in widget.business.contactPhone) {
        phoneControllers.add(TextEditingController(text: phone));
      }
    } else {
      phoneControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    addressController.dispose();
    emailController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    for (var c in phoneControllers) { c.dispose(); }
    super.dispose();
  }

  Future<void> _pickLogo() async {
    try {
      final image = await _imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (image != null) setState(() => logoImage = image);
    } catch (e) {
      utilityController.showSnack('Error', 'Failed to pick image: $e', 3, true);
    }
  }

  Future<void> _updateBusiness() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    final phoneNumbers = phoneControllers.map((c) => c.text.trim()).where((p) => p.isNotEmpty).toList();
    final businessData = {
      'name': nameController.text,
      'description': descriptionController.text,
      'address': addressController.text,
      'contact_email': emailController.text,
      'contact_phone': phoneNumbers,
      'category_id': selectedCategory?.id,
      'currency': selectedCurrency,
      'business_hours': businessHours,
      'latitude': double.tryParse(latitudeController.text),
      'longitude': double.tryParse(longitudeController.text),
    };
    final success = await businessController.updateBusiness(widget.business.id!, businessData, logo: logoImage);
    isLoading.value = false;
    if (success) {
      SuccessBottomSheet.show(
        title: "Business Updated!",
        message: "Your business information has been updated.",
        buttonText: "Back",
        onButtonTap: () { Get.back(); Get.back(); },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: firstColor.withValues(alpha: 0.9),
        title: CustomText(text: "Edit Business", fontSize: 20, fontWeight: FontWeight.bold, color: whiteColor),
        leading: IconButton(icon: Icon(Icons.arrow_back, color: whiteColor), onPressed: () => Get.back()),

      ),
      body: Obx(() => categoryController.isLoading.value
          ? Center(child: CircularProgressIndicator(color: firstColor))
          : _buildForm()),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      child: Column(
        children: [
          BusinessLogoSection(logoImagePath: logoImage?.path, existingLogoUrl: widget.business.logoUrl, status: widget.business.status, onTap: _pickLogo),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  BusinessDetailsSection(nameController: nameController, descriptionController: descriptionController, addressController: addressController),
                  const SizedBox(height: 20),
                  CategorySelector(selectedCategory: selectedCategory, categories: categoryController.categories, onCategoryChanged: (c) => setState(() => selectedCategory = c)),
                  const SizedBox(height: 20),
                  CurrencySelector(selectedCurrency: selectedCurrency, onCurrencyChanged: (c) => setState(() => selectedCurrency = c)),
                  const SizedBox(height: 20),
                  ContactInfoSection(
                    emailController: emailController,
                    phoneControllers: phoneControllers,
                    onAddPhone: () => setState(() => phoneControllers.add(TextEditingController())),
                    onRemovePhone: (i) => setState(() { phoneControllers[i].dispose(); phoneControllers.removeAt(i); }),
                  ),
                  const SizedBox(height: 20),
                  LocationSection(
                    latitudeController: latitudeController,
                    longitudeController: longitudeController,
                    businessController: businessController,
                    onGetLocation: () async {
                      final loc = await businessController.getLocation();
                      if (loc != null) { latitudeController.text = loc['latitude']!.toString(); longitudeController.text = loc['longitude']!.toString(); }
                    },
                  ),
                  const SizedBox(height: 20),
                  BusinessHoursSection(
                    businessHours: businessHours,
                    onBusinessHoursChanged: (hours) => setState(() => businessHours = hours),
                  ),
                  const SizedBox(height: 30),
                  CommonButton(text: "Update Business", textColor: whiteColor, bgColor: firstColor, width: double.infinity, verticalPadding: 15, radius: 10, isLoading: isLoading, onTap: _updateBusiness),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
