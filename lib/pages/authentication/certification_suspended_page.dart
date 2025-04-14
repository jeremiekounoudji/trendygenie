import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/globalVariable.dart';
import '../../widgets/general_widgets/common_button.dart';

class CertificationSuspendedPage extends StatelessWidget {
  final authController = Get.find<AuthController>();
  final isLoading = false.obs;
  
  CertificationSuspendedPage({Key? key}) : super(key: key);

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@trendygenie.com',
      queryParameters: {
        'subject': 'Account Suspension Inquiry',
        'body': 'Hello Support Team,\n\nI would like to inquire about my suspended account.\n\nBest regards,'
      }
    );
    
    try {
      if (await launchUrl(emailLaunchUri)) {
        // Email client launched successfully
      } else {
        Get.snackbar(
          'Error',
          'Could not launch email client',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: redColor,
          colorText: whiteColor,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to open email client: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: redColor,
        colorText: whiteColor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomText(
          text: 'Account Suspended',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: whiteColor,
        ),
        backgroundColor: redColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Icon(
                Icons.block_outlined,
                size: 80,
                color: redColor,
              ),
              const SizedBox(height: 20),
              CustomText(
                text: 'Account Suspended',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
              const SizedBox(height: 20),
              CustomText(
                text: 'Your company account has been suspended...',
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: blackColor,
                align: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Common reasons for suspension:',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: blackColor,
                    ),
                    const SizedBox(height: 10),
                    CustomText(
                      text: '• Multiple user complaints',
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: blackColor,
                    ),
                    CustomText(
                      text: '• Policy violations',
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: blackColor,
                    ),
                    CustomText(
                      text: '• Quality of service issues',
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: blackColor,
                    ),
                    CustomText(
                      text: '• Expired or invalid documentation',
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: blackColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              CommonButton(
                text: 'Contact Support',
                textColor: whiteColor,
                bgColor: firstColor,
                isLoading: isLoading,
                onTap: _launchEmail,
              ),
              const SizedBox(height: 16),
              CommonButton(
                text: 'Sign Out',
                textColor: redColor,
                bgColor: Colors.transparent,
                haveBorder: true,
                isLoading: isLoading,
                onTap: () => authController.signOut(),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 