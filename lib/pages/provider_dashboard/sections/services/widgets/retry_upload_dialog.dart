import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/globalVariable.dart';

class RetryUploadDialog extends StatelessWidget {
  final Function() onRetry;

  const RetryUploadDialog({
    super.key,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const CustomText(
        text: 'Image Upload Failed',
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      content: const CustomText(
        text: 'Would you like to retry uploading the images now or do it later?',
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: Colors.black87,
      ),
      actions: [
        TextButton(
          child: CustomText(
            text: 'Retry Now',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: firstColor,
          ),
          onPressed: () async {
            Get.back(); // Close dialog
            await onRetry();
          },
        ),
        TextButton(
          child: CustomText(
            text: 'Do it Later',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: secondColor,
          ),
          onPressed: () {
            Get.back(); // Close dialog
            Get.back(); // Return to previous screen
          },
        ),
      ],
    );
  }
} 