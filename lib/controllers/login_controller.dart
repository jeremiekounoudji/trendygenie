import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trendygenie/controllers/auth_controller.dart';

class LoginController extends GetxController {
  final AuthController authController = Get.put(AuthController());
  
  // Form key for validation
  final formKey = GlobalKey<FormState>();
  
  // Text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  // Observable for password visibility
  final isPasswordVisible = false.obs;

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Login function
  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      final success = await authController.signIn(
        email: emailController.text,
        password: passwordController.text,
      );
      
      if (success) {
        Get.offAllNamed('/home');
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
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
} 