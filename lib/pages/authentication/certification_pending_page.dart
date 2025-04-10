import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trendygenie/utils/globalVariable.dart';
import 'package:trendygenie/widgets/general_widgets/common_button.dart';
import 'package:trendygenie/widgets/auth/auth_container.dart';

class CertificationPendingPage extends StatelessWidget {
  const CertificationPendingPage({Key? key}) : super(key: key);

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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.pending_actions,
                        size: 80,
                        color: firstColor,
                      ),
                      const SizedBox(height: 24),
                      CustomText(
                        text: 'Certification Pending',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: blackColor,
                      ),
                      const SizedBox(height: 16),
                      CustomText(
                        text: 'Your account is under review',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700]!,
                      ),
                      const SizedBox(height: 24),
                      CustomText(
                        text: 'We are reviewing your business documents. This process usually takes 24-48 hours. We\'ll notify you once the verification is complete.',
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey[600]!,
                        align: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      CommonButton(
                        textColor: whiteColor,
                        bgColor: firstColor,
                        text: 'Back to Login',
                        onTap: () => Get.offAllNamed('/login'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 