import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trendygenie/utils/globalVariable.dart';
import 'package:trendygenie/widgets/general_widgets/textfield.dart';
import 'package:trendygenie/widgets/general_widgets/common_button.dart';
import 'package:trendygenie/controllers/register_controller.dart';
import 'package:trendygenie/widgets/auth/auth_container.dart';
import 'package:trendygenie/widgets/general_widgets/validators.dart';
import 'package:trendygenie/pages/authentication/pin/pin_page.dart';
import 'package:trendygenie/controllers/auth_controller.dart';

import 'register_step_three.dart';

class RegisterStepOne extends StatefulWidget {
  RegisterStepOne({Key? key}) : super(key: key);

  @override
  _RegisterStepOneState createState() => _RegisterStepOneState();
}

class _RegisterStepOneState extends State<RegisterStepOne> {
  final RegisterController controller = Get.put(RegisterController());
  final AuthController authController = Get.find<AuthController>();

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
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText(
                          text: 'Create Account',
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: blackColor,
                        ),
                        const SizedBox(height: 8),
                        CustomText(
                          text: 'Please fill in your information',
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[600]!,
                        ),
                        const SizedBox(height: 32),
                        CustomTextField(
                          hintText: 'First Name',
                          inputType: TextInputType.name,
                          controller: controller.firstNameController,
                          validator: (value) => Validators.isStringNotEmpty(value) 
                              ? null 
                              : 'First name is required',
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          hintText: 'Last Name',
                          inputType: TextInputType.name,
                          controller: controller.lastNameController,
                          validator: (value) => Validators.isStringNotEmpty(value) 
                              ? null 
                              : 'Last name is required',
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          hintText: 'Email',
                          inputType: TextInputType.emailAddress,
                          controller: controller.emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            }
                            if (!GetUtils.isEmail(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          hintText: 'Phone Number . e.g +234 562******',
                          inputType: TextInputType.phone,
                          controller: controller.phoneController,

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Phone number is required';
                            }
                            if (!GetUtils.isPhoneNumber(value)) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          hintText: 'Password',
                          inputType: TextInputType.visiblePassword,
                          controller: controller.passwordController,
                          obscureText: controller.isPasswordVisible,
                          maxLines: 1,
                          // suffix: IconButton(
                          //   icon: Icon(
                          //     controller.isPasswordVisible.value
                          //         ? Icons.visibility
                          //         : Icons.visibility_off,
                          //     color: firstColor,
                          //   ),
                          //   onPressed: controller.togglePasswordVisibility,
                          // ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          hintText: 'Confirm Password',
                          inputType: TextInputType.visiblePassword,
                          controller: controller.confirmPasswordController,
                          obscureText: controller.isConfirmPasswordVisible,
                          maxLines: 1,
                          // suffix: IconButton(
                          //   icon: Icon(
                          //     controller.isConfirmPasswordVisible.value
                          //         ? Icons.visibility
                          //         : Icons.visibility_off,
                          //     color: firstColor,
                          //   ),
                          //   onPressed: controller.toggleConfirmPasswordVisibility,
                          // ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != controller.passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          hintText: 'Date of Birth',
                          inputType: TextInputType.datetime,
                          controller: controller.dateOfBirthController,
                          readOnly: true,
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() {
                                controller.dateOfBirthController.text = 
                                    DateFormat('yyyy-MM-dd').format(picked);
                              });
                            }
                          },
                          validator: (value) => Validators.isStringNotEmpty(value) 
                              ? null 
                              : 'Date of birth is required',
                        ),
                        const SizedBox(height: 32),
                        CommonButton(
                          textColor: whiteColor,
                          bgColor: firstColor,
                          text: 'Next',
                          isLoading: controller.isLoading,
                          onTap: () async {
                            if (controller.validateStepOne()) {
                              controller.isLoading.value = true;
                              try {
                                log(controller.emailController.text);
                                log(controller.passwordController.text);
                                log('${controller.firstNameController.text} ${controller.lastNameController.text}');
                                log(controller.phoneController.text);
                                final success = await authController.signUp(
                                  email: controller.emailController.text,
                                  password: controller.passwordController.text,
                                  fullName: '${controller.firstNameController.text} ${controller.lastNameController.text}',
                                  phoneNumber: controller.phoneController.text,
                                );
                                
                                if (success) {
                                  Get.to(() => RegisterStepThree(), transition: Transition.rightToLeft);
                                } else {
                                  Get.snackbar(
                                    'Error',
                                    authController.authError.value,
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                }
                              } finally {
                                controller.isLoading.value = false;
                              }
                            }
                          },
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: "Already have an account? ",
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey[600]!,
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
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
