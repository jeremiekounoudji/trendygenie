import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:trendygenie/utils/globalVariable.dart';
import 'package:trendygenie/widgets/general_widgets/textfield.dart';
import 'package:trendygenie/widgets/general_widgets/common_button.dart';

import '../login/login_page.dart';
import '../pin/pin_page.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: firstColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: 'Wecome to TrendyGenie',
                fontSize: 24,
                align: TextAlign.center,
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
              const SizedBox(height: 16),
              const CustomTextField(
                hintText: 'Email',
                inputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hintText: 'Password',
                inputType: TextInputType.visiblePassword,
                maxLines: 1,
                obscureText: true.obs,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hintText: 'Confirm Password',
                inputType: TextInputType.visiblePassword,
                maxLines: 1,
                obscureText: true.obs,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: CommonButton(
                  textColor: whiteColor,
                  bgColor: firstColor,
                  text: 'Register',
                  verticalPadding: 15,
                  onTap: () {
                    Get.to(() => const PinPage(), transition: Transition.fadeIn);
                  },
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.to(() =>  LoginPage(), transition: Transition.leftToRight);
                },
                child: const Text('Already have an account? Login'),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: firstColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        'assets/icons/phone.svg',
                        color: whiteColor,
                        height: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  CircleAvatar(
                    backgroundColor: secondColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        'assets/icons/phone.svg',
                        color: whiteColor,
                        height: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  CircleAvatar(
                    backgroundColor: thirdColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        'assets/icons/phone.svg',
                        color: whiteColor,
                        height: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
