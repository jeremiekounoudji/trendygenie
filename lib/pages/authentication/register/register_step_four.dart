import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trendygenie/utils/globalVariable.dart';
import 'package:trendygenie/widgets/general_widgets/textfield.dart';
import 'package:trendygenie/widgets/general_widgets/common_button.dart';
import 'package:trendygenie/controllers/register_controller.dart';
import 'package:trendygenie/controllers/auth_controller.dart';
import 'package:trendygenie/widgets/general_widgets/validators.dart';
import 'package:trendygenie/widgets/auth/auth_container.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:trendygenie/models/company_model.dart';
import 'package:trendygenie/controllers/company_controller.dart';

class RegisterStepFour extends StatelessWidget {
  RegisterStepFour({Key? key}) : super(key: key);

  final RegisterController registerController = Get.find<RegisterController>();
  final AuthController authController = Get.find<AuthController>();
  final ImagePicker _picker = ImagePicker();
  final CompanyController companyController = Get.find<CompanyController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/location-bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 40),
                AuthContainer(
                  child: Obx(() => registerController.accountType.value == 'provider'
                      ? _buildSellerForm()
                      : _buildBuyerForm()),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSellerForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText(
          text: 'Company Information',
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: blackColor,
        ),
        const SizedBox(height: 8),
        CustomText(
          text: 'Please provide your business details',
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.grey[600]!,
        ),
        const SizedBox(height: 32),
        CustomTextField(
          hintText: 'Company Name',
          controller: registerController.companyNameController,
          validator: (value) => Validators.isStringNotEmpty(value) 
              ? null 
              : 'Company name is required',
        ),
        const SizedBox(height: 16),
        CustomTextField(
          hintText: 'Company Address',
          controller: registerController.companyAddressController,
          validator: (value) => Validators.isStringNotEmpty(value) 
              ? null 
              : 'Company address is required',
        ),
        const SizedBox(height: 16),
        CustomTextField(
          hintText: 'Company Registration Number',
          controller: registerController.companyRegNumberController,
          validator: (value) => Validators.isStringNotEmpty(value) 
              ? null 
              : 'Registration number is required',
        ),
        const SizedBox(height: 16),
        _buildCategorySelector(),
        const SizedBox(height: 32),
        CustomText(
          text: 'Verification Documents',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: blackColor,
        ),
        const SizedBox(height: 16),
        _buildFilePicker('Company Logo', registerController.companyLogo),
        const SizedBox(height: 16),
        _buildFilePicker('Owner ID/Passport', registerController.ownerIdImage),
        const SizedBox(height: 16),
        _buildFilePicker('Selfie Photo', registerController.selfieImage),
        const SizedBox(height: 32),
        Obx(() => companyController.currentUploadFile.isNotEmpty
          ? Column(
              children: [
                const SizedBox(height: 16),
                CustomText(
                  text: 'Uploading ${companyController.currentUploadFile.value}',
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey[600]!,
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: companyController.uploadProgress.value,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(firstColor),
                ),
              ],
            )
          : const SizedBox.shrink()
        ),
        CommonButton(
          textColor: whiteColor,
          bgColor: firstColor,
          text: 'Complete Registration',
          isLoading: companyController.isLoading,
          onTap: () async {
              log('company: ${registerController.companyNameController.text}');

            if (registerController.validateStepFour()) {
              log('company: ${registerController.companyNameController.text}');
              // final company = CompanyModel(
              //   name: registerController.companyNameController.text,
              //   registrationNumber: registerController.companyRegNumberController.text,
              //   address: registerController.companyAddressController.text,
              //   category: registerController.selectedCategory.value,
              //   ownerId: authController.currentUser.value!.id,
                
              //   status: CompanyStatus.pending,
              //   createdAt: DateTime.now(),
              // );

              // final success = await companyController.createCompany(
              //   company,
              //   logo: registerController.companyLogo.value!,
              //   ownerId: registerController.ownerIdImage.value!,
              //   selfie: registerController.selfieImage.value!,
              // );
              
              // if (success) {
              //   Get.offAllNamed('/certification-pending');
              // } else {
              //   Get.snackbar(
              //     'Error',
              //     companyController.errorMessage.value,
              //     snackPosition: SnackPosition.BOTTOM,
              //     backgroundColor: Colors.red,
              //     colorText: Colors.white,
              //   );
              // }
            }
          },
        ),
      ],
    );
  }

  Widget _buildBuyerForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText(
          text: 'Shipping Information',
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: blackColor,
        ),
        const SizedBox(height: 8),
        CustomText(
          text: 'Where should we deliver your orders?',
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.grey[600]!,
        ),
        const SizedBox(height: 32),
        CustomTextField(
          hintText: 'Shipping Address',
          controller: registerController.shippingAddressController,
          validator: (value) => Validators.isStringNotEmpty(value) 
              ? null 
              : 'Shipping address is required',
        ),
        const SizedBox(height: 32),
        CommonButton(
          textColor: whiteColor,
          bgColor: firstColor,
          text: 'Complete Registration',
          isLoading: registerController.isLoading,
          onTap: () async {
            if (registerController.validateStepFour()) {
              final success = await authController.signUp(
                email: registerController.emailController.text,
                password: registerController.passwordController.text,
                fullName: '${registerController.firstNameController.text} ${registerController.lastNameController.text}',
                phoneNumber: registerController.phoneController.text,
              );
              
              if (success) {
                await authController.sendEmailConfirmation();
                
                if (registerController.accountType.value == 'seller') {
                  Get.offAllNamed('/certification-pending');
                } else {
                  Get.offAllNamed('/home');
                }
              } else {
                Get.snackbar(
                  'Error',
                  authController.authError.value,
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            }
          },
        ),
      ],
    );
  }

  Widget _buildFilePicker(String title, Rx<XFile?> file) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => _pickFile(file),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.file_upload, size: 32, color: firstColor),
              const SizedBox(height: 8),
              CustomText(
                text: title,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
              const SizedBox(height: 8),
              Obx(() => CustomText(
                text: file.value == null
                    ? 'Tap to select file'
                    : file.value!.path.split('/').last,
                fontSize: 14,
                color: Colors.grey[600]!,
                fontWeight: FontWeight.normal,
              )),
            ],
          ),
        ),
      ),
    );
  }

  void _pickFile(Rx<XFile?> file) async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      file.value = pickedFile;
    }
  }

  Widget _buildCategorySelector() {
    return CustomPopup(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            text: 'Select Category',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: blackColor,
          ),
          const SizedBox(height: 16),
          ...List.generate(
            5,
            (index) => ListTile(
              title: Text('Category ${index + 1}'),
              onTap: () {
                registerController.selectedCategory.value = 'Category ${index + 1}';
                Get.back();
              },
            ),
          ),
        ],
      ),
      child: CustomTextField(
        hintText: 'Category',
        readOnly: true,
        controller: registerController.companyCategoryController,
        validator: (value) => Validators.isStringNotEmpty(value) 
            ? null 
            : 'Category is required',
      ),
    );
  }
}
