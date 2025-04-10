import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:trendygenie/controllers/login_controller.dart';
import 'package:trendygenie/pages/authentication/register/register_step_one.dart';
import 'package:trendygenie/utils/globalVariable.dart';
import 'package:trendygenie/widgets/general_widgets/textfield.dart';
import 'package:trendygenie/widgets/general_widgets/common_button.dart';
import 'package:trendygenie/widgets/auth/auth_container.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final LoginController controller = Get.put(LoginController());

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
                // Logo or App Name
                // Container(
                //   width: 120,
                //   height: 120,
                //   decoration: BoxDecoration(
                //     color: whiteColor.withOpacity(0.9),
                //     shape: BoxShape.circle,
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.black.withOpacity(0.1),
                //         blurRadius: 20,
                //         spreadRadius: 5,
                //       ),
                //     ],
                //   ),
                //   child: Center(
                //     child: Image.asset(
                //       'assets/images/logo.png',
                //       width: 80,
                //       height: 80,
                //     ),
                //   ),
                // ),
                const SizedBox(height: 40),
                // Auth Container
                AuthContainer(
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText(
                          text: 'Welcome Back',
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: blackColor,
                        ),
                        const SizedBox(height: 8),
                        CustomText(

                          text: 'Sign in to continue',
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          color: Colors.grey[600]!,
                        ),
                        const SizedBox(height: 32),
                        CustomTextField(
                          hintText: 'Email',
                          inputType: TextInputType.emailAddress,
                          controller: controller.emailController,
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
                        const SizedBox(height: 16),
CustomTextField(
                          hintText: 'Password',
                          inputType: TextInputType.visiblePassword,
                          controller: controller.passwordController,
                          maxLines: 1,
                          obscureText: controller.isPasswordVisible,
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
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => Get.toNamed('/forgot-password'),
                            child: CustomText(
                              text: 'Forgot Password?',
                              fontSize: 14,
                              color: firstColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        CommonButton(
                          textColor: whiteColor,
                          bgColor: firstColor,
                          text: 'Login',
                          isLoading: controller.authController.isLoading,
                          onTap: controller.login,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: "Don't have an account? ",
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey[600]!,
                            ),
                            GestureDetector(
                              onTap: () => Get.to(
                                () => RegisterStepOne(),
                                transition: Transition.rightToLeft,
                              ),
                              child: CustomText(
                                text: "Register",
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: firstColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Social Login
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSocialButton(
                              'assets/icons/google-svg.svg',
                              firstColor,
                              () {},
                            ),
                            const SizedBox(width: 16),
                            _buildSocialButton(
                              'assets/icons/facebook-svg.svg',
                              secondColor,
                              () {},
                            ),
                            const SizedBox(width: 16),
                            _buildSocialButton(
                              'assets/icons/apple-svg.svg',
                              thirdColor,
                              () {},
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

  Widget _buildSocialButton(String icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: SvgPicture.asset(
            icon,
            width: 24,
            height: 24,
            // color: color,
          ),
        ),
      ),
    );
  }
}
