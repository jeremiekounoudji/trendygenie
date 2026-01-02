import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trendygenie/controllers/auth_controller.dart';
import 'package:trendygenie/utils/globalVariable.dart';
import 'package:trendygenie/widgets/general_widgets/common_button.dart';
import 'package:trendygenie/widgets/general_widgets/textfield.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({super.key});

  final AuthController authController = Get.put(AuthController());
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: firstColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: whiteColor),
          onPressed: () => Get.back(),
        ),
        title: CustomText(
          text: 'Forgot Password',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: whiteColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Icon or Image
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: firstColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_reset_rounded,
                    size: 100,
                    color: firstColor,
                  ),
                ),
                const SizedBox(height: 32),
                // Title
                CustomText(
                  text: "Forgot your password?",
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: blackColor,
                ),
                const SizedBox(height: 16),
                // Description
                CustomText(
                  text: "Don't worry! It happens. Please enter the email address associated with your account.",
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey[600]!,
                  align: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // Email Input
                CustomTextField(
                  controller: emailController,
                  hintText: "Enter your email",
                  inputType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!GetUtils.isEmail(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                // Submit Button
                CommonButton(
                  text: "Reset Password",
                  textColor: whiteColor,
                  bgColor: firstColor,
                  isLoading: authController.isLoading,
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      final success = await authController.sendPasswordResetEmail(
                        emailController.text,
                      );
                      
                      if (success) {
                        Get.snackbar(
                          'Success',
                          'Password reset link has been sent to your email',
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.green,
                          colorText: whiteColor,
                          duration: const Duration(seconds: 4),
                          icon: Icon(Icons.check_circle, color: whiteColor),
                        );
                        
                        // Optional: Navigate back after short delay
                        Future.delayed(
                          const Duration(seconds: 2),
                          () => Get.back(),
                        );
                      } else {
                        Get.snackbar(
                          'Error',
                          authController.authError.value,
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.red,
                          colorText: whiteColor,
                          duration: const Duration(seconds: 4),
                          icon: Icon(Icons.error, color: whiteColor),
                        );
                      }
                    }
                  },
                ),
                const SizedBox(height: 24),
                // Back to Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(


                      text: "Remember your password? ",
                      
                      fontSize: 14,
                      color: Colors.grey[600]!,
                      fontWeight: FontWeight.normal,
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: CustomText(
                        text: "Login",
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: firstColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 