import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trendygenie/utils/globalVariable.dart';
import 'package:trendygenie/widgets/general_widgets/common_button.dart';
import 'package:trendygenie/controllers/register_controller.dart';
import 'package:trendygenie/widgets/auth/auth_container.dart';
import 'package:trendygenie/controllers/user_controller.dart';
import 'package:trendygenie/models/user_model.dart';
import 'package:trendygenie/controllers/auth_controller.dart';

import '../login/login_page.dart';
import 'register_step_four.dart';
import 'register_step_two.dart';

class RegisterStepThree extends StatefulWidget {
  RegisterStepThree({Key? key}) : super(key: key);

  @override
  _RegisterStepThreeState createState() => _RegisterStepThreeState();
}

class _RegisterStepThreeState extends State<RegisterStepThree> {
  final RegisterController controller = Get.put(RegisterController());
  final UserController userController = Get.put(UserController());
  final AuthController authController = Get.put(AuthController());
  RxBool isLoading = false.obs;

  Future<void> handleAccountTypeSelection() async {
    if (controller.validateStepThree()) {
      isLoading.value = true;
      try {
        final user = UserModel(
          id: authController.currentUser.value!.id,
          email: authController.currentUser.value!.email!,
          fullName: '${controller.firstNameController.text} ${controller.lastNameController.text}',
          phoneNumber: controller.phoneController.text,
          userType: controller.accountType.value,
          isEmailVerified: false,
          isPhoneVerified: false,
          preferences: UserPreferences(),
          isActive: true,
          createdAt: DateTime.now(),
        );

        log('user: ${user.toJson().toString()}');
        final success = await userController.createUser(user);
        
        if (success) {
          if (controller.accountType.value == 'provider') {
            Get.to(() => RegisterStepTwo(), transition: Transition.rightToLeft);
          } else {
            Get.offAllNamed('/home');
          }
        } else {
          Get.snackbar(
            'Error',
            userController.errorMessage.value,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } finally {
        isLoading.value = false;
      }
    }
  }

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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(
                        text: 'Select Account Type',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: blackColor,
                      ),
                      const SizedBox(height: 8),
                      CustomText(
                        text: 'Choose how you want to use TrendyGenie',
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey[600]!,
                        align: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      _buildAccountTypeSelector(
                        'Customer', 
                        'Shop and purchase items',
                        Icons.shopping_bag_outlined,
                        () => controller.setAccountType('customer'),
                      ),
                      const SizedBox(height: 16),
                      _buildAccountTypeSelector(
                        'Provider', 
                        'List and sell your products',
                        Icons.store_outlined,
                        () => controller.setAccountType('provider'),
                      ),
                      const SizedBox(height: 32),
                      CommonButton(
                        textColor: whiteColor,
                        bgColor: firstColor,
                        text: 'Continue',
                        isLoading: isLoading,
                        onTap: handleAccountTypeSelection,
                      ),
                    ],
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

  Widget _buildAccountTypeSelector(
    String title, 
    String description, 
    IconData icon,
    VoidCallback onTap
  ) {
    return Obx(() => InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: controller.accountType.value == title.toLowerCase()
              ? firstColor.withOpacity(0.1)
              : Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: controller.accountType.value == title.toLowerCase()
                ? firstColor
                : Colors.grey.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: controller.accountType.value == title.toLowerCase()
                    ? firstColor
                    : Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: controller.accountType.value == title.toLowerCase()
                    ? whiteColor
                    : Colors.grey,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: title,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: blackColor,
                  ),
                  const SizedBox(height: 4),
                  CustomText(
                    text: description,
                    fontSize: 14,
                    color: Colors.grey[600]!,
                    fontWeight: FontWeight.normal,
                  ),
                ],
              ),
            ),
            Radio(
              value: title.toLowerCase(),
              groupValue: controller.accountType.value,
              onChanged: (_) => onTap(),
              activeColor: firstColor,
            ),
          ],
        ),
      ),
    ));
  }
}
