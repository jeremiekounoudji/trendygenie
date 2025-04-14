import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trendygenie/widgets/general_widgets/validators.dart';

class RegisterController extends GetxController {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final location = ''.obs;
  final accountType = ''.obs;
  final companyNameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  final companyAddressController = TextEditingController();
  final companyRegNumberController = TextEditingController();
  final shippingAddressController = TextEditingController();

  final companyLogo = Rx<XFile?>(null);
  final ownerIdImage = Rx<XFile?>(null);
  final selfieImage = Rx<XFile?>(null);

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final formKey = GlobalKey<FormState>();

  final confirmPasswordController = TextEditingController();
  final isConfirmPasswordVisible = false.obs;

  final locationAddress = ''.obs;

  bool validateStepOne() {
    if (!formKey.currentState!.validate()) {
      return false;
    }
    return Validators.isStringNotEmpty(firstNameController.text) &&
        Validators.isStringNotEmpty(lastNameController.text) &&
        Validators.isStringNotEmpty(dateOfBirthController.text) &&
        Validators.isStringNotEmpty(phoneController.text) &&
        passwordController.text == confirmPasswordController.text;
  }

  bool validateStepTwo() {
    return Validators.isStringNotEmpty(location.value);
  }

  bool validateStepThree() {
    return Validators.isStringNotEmpty(accountType.value);
  }

  bool validateStepFour() {
    if (accountType.value == 'provider') {
      return Validators.isStringNotEmpty(companyNameController.text) &&
          Validators.isStringNotEmpty(companyAddressController.text) &&
          Validators.isStringNotEmpty(companyRegNumberController.text) &&
          companyLogo.value != null &&
          ownerIdImage.value != null &&
          selfieImage.value != null;
    } else {
      return Validators.isStringNotEmpty(shippingAddressController.text);
    }
  }

  void setLocation(String newLocation) {
    location.value = newLocation;
  }

  void setAccountType(String type) {
    accountType.value = type;
  }

  void submitRegistration() {
    // Implement the registration logic here
    // This could involve sending data to an API, storing in local database, etc.
    print('Registration submitted');
    // After successful registration, you might want to navigate to a success page or login page
    Get.offAllNamed('/login');
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    dateOfBirthController.dispose();
    passwordController.dispose();
    emailController.dispose();
    phoneController.dispose();
    companyNameController.dispose();
    companyAddressController.dispose();
    companyRegNumberController.dispose();
    shippingAddressController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
