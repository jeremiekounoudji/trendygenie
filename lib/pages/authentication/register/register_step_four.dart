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

class RegisterStepFour extends StatefulWidget {
  const RegisterStepFour({Key? key}) : super(key: key);

  @override
  _RegisterStepFourState createState() => _RegisterStepFourState();
}

class _RegisterStepFourState extends State<RegisterStepFour> {
  final RegisterController registerController = Get.find<RegisterController>();
  final AuthController authController = Get.find<AuthController>();
  final ImagePicker _picker = ImagePicker();
  final CompanyController companyController = Get.find<CompanyController>();
  final RxInt currentStep = 0.obs;
  final RxBool isProcessing = false.obs;

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
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),
                AuthContainer(
                  child: Obx(() => registerController.accountType.value == 'provider'
                      ? _buildProviderForm()
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

  Widget _buildProviderForm() {
    return Obx(() => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Progress indicator
        Row(
          children: [
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: firstColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: currentStep.value >= 1 ? firstColor : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Step content
        if (currentStep.value == 0)
          _buildCompanyInfoStep()
        else
          _buildDocumentsStep(),
      ],
    ));
  }
  
  Widget _buildCompanyInfoStep() {
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
        const SizedBox(height: 32),
        CommonButton(
          textColor: whiteColor,
          bgColor: firstColor,
          text: 'Next: Upload Documents',
          isLoading: isProcessing,
          onTap: () async {
            if (_validateCompanyInfo()) {
              currentStep.value = 1;
            }
          },
        ),
      ],
    );
  }
  
  Widget _buildDocumentsStep() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText(
          text: 'Verification Documents',
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: blackColor,
        ),
        const SizedBox(height: 8),
        CustomText(
          text: 'Please upload the required documents',
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.grey[600]!,
        ),
        const SizedBox(height: 32),
        _buildFilePicker('Company Logo', registerController.companyLogo),
        const SizedBox(height: 16),
        _buildFilePicker('Owner ID/Passport', registerController.ownerIdImage),
        const SizedBox(height: 16),
        _buildFilePicker('Selfie Photo', registerController.selfieImage),
        const SizedBox(height: 32),
        
        // Upload progress
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
        
        // Navigation buttons
        Row(
          children: [
            Expanded(
              child: CommonButton(
                textColor: blackColor,
                bgColor: Colors.grey[200]!,
                text: 'Back',
                onTap: () {
                  currentStep.value = 0;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CommonButton(
          textColor: whiteColor,
          bgColor: firstColor,
          text: 'Complete Registration',
          isLoading: companyController.isLoading,
          onTap: () async {
                  await _submitCompanyRegistration();
                },
              ),
            ),
          ],
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
          padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: title,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
                const SizedBox(height: 4),
              Obx(() => CustomText(
                  text: file.value != null 
                      ? file.value!.name 
                      : 'No file selected',
                fontSize: 14,
                  fontWeight: FontWeight.normal,
                color: Colors.grey[600]!,
              )),
            ],
          ),
        ),
          ElevatedButton(
            onPressed: () async {
              final result = await _picker.pickImage(source: ImageSource.gallery);
              if (result != null) {
                file.value = result;
    }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: firstColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              file.value != null ? 'Change' : 'Select',
              style: TextStyle(color: whiteColor),
            ),
          ),
        ],
      ),
    );
  }

  bool _validateCompanyInfo() {
    if (registerController.companyNameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Company name is required',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    
    if (registerController.companyAddressController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Company address is required',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    
    if (registerController.companyRegNumberController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Registration number is required',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    
    return true;
  }
  
  bool _validateDocuments() {
    if (registerController.companyLogo.value == null) {
      Get.snackbar(
        'Error',
        'Company logo is required',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    
    if (registerController.ownerIdImage.value == null) {
      Get.snackbar(
        'Error',
        'Owner ID document is required',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    
    if (registerController.selfieImage.value == null) {
      Get.snackbar(
        'Error',
        'Selfie photo is required',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    
    return true;
  }

  Future<void> _submitCompanyRegistration() async {
    if (!_validateDocuments()) {
      return;
    }
    
    isProcessing.value = true;
    
    try {
      // Create company model without category
      final company = CompanyModel(
        name: registerController.companyNameController.text,
        registrationNumber: registerController.companyRegNumberController.text,
        address: registerController.companyAddressController.text,
        ownerId: authController.currentUser.value!.id,
        status: CompanyStatus.pending,
        createdAt: DateTime.now(),
      );

      log('Creating company: ${company.toJson()}');
      
      final success = await companyController.createCompany(
        company,
        logo: registerController.companyLogo.value!,
        ownerId: registerController.ownerIdImage.value!,
        selfie: registerController.selfieImage.value!,
      );
      
      if (success) {
        log('Company created successfully');
        Get.offAllNamed('/certification-pending');
      } else {
        log('Company creation failed: ${companyController.errorMessage.value}');
        Get.snackbar(
          'Error',
          'Failed to create company: ${companyController.errorMessage.value}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
      }
    } catch (e) {
      log('Error creating company: $e');
      Get.snackbar(
        'Error',
        'Failed to create company: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
    );
    } finally {
      isProcessing.value = false;
    }
  }
}
