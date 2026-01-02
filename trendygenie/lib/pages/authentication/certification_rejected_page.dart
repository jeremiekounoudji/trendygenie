import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/globalVariable.dart';
import '../../pages/authentication/register/register_step_four.dart';

class CertificationRejectedPage extends StatelessWidget {
  final authController = Get.find<AuthController>();
  
  CertificationRejectedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const CustomText(
          text: 'Certification Rejected',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        backgroundColor: Colors.red.shade700,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.red.shade700,
              ),
              const SizedBox(height: 20),
              const CustomText(
                text: 'Certification Rejected',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              const SizedBox(height: 20),
              const CustomText(
                text: 'Your company certification request has been rejected. Please review the following information and resubmit your application.',
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.black87,
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
                  children:  [
                    CustomText(
                      text: 'Possible reasons for rejection:',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: blackColor,
                    ),
                    const SizedBox(height: 10),
                    CustomText(
                      text: '• Incomplete or invalid business documentation',
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: blackColor,
                    ),
                    CustomText(
                      text: '• Business license issues',
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: blackColor,
                    ),
                    CustomText(
                      text: '• Insufficient service information',
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: blackColor,
                    ),
                    CustomText(
                      text: '• Unverifiable business details',
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: blackColor,
                    ),
                    CustomText(
                      text: '• Failure to meet quality standards',
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: blackColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                
                onPressed: () {
                  Get.offAll(() => const RegisterStepFour(), transition: Transition.leftToRightWithFade);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: firstColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child:  CustomText(
                  text: 'Update Company Details',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: whiteColor,
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  authController.signOut();
                },
                style: TextButton.styleFrom(
                  foregroundColor: redColor,
                ),
                child:  CustomText(
                  text: 'Sign Out',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: redColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 