import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/globalVariable.dart';
import '../widgets/general_widgets/common_button.dart';

class CertificationSuspendedPage extends StatelessWidget {
  final isLoading = false.obs;
  
  CertificationSuspendedPage({Key? key}) : super(key: key);

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@trendygenie.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Account Suspension Inquiry',
        'body': 'Hello,\n\nI would like to inquire about my suspended account.\n\nBest regards,',
      }),
    );

    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
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

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 100,
                color: firstColor,
              ),
              const SizedBox(height: 20),
              CustomText(
                text: 'Account Suspended',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
              const SizedBox(height: 10),
              CustomText(
                text: 'Your account has been suspended. Please contact support for more information.',
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: blackColor,
                align: TextAlign.center,
              ),
              const SizedBox(height: 30),
              CommonButton(
                text: 'Contact Support',
                textColor: whiteColor,
                bgColor: firstColor,
                isLoading: isLoading,
                onTap: _launchEmail,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 