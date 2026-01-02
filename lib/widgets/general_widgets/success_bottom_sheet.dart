import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/globalVariable.dart';
import 'common_button.dart';

class SuccessBottomSheet extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onButtonTap;
  final bool isDismissible;
  final bool enableDrag;

  const SuccessBottomSheet({
    super.key,
    required this.title,
    required this.message,
    required this.buttonText,
    required this.onButtonTap,
    this.isDismissible = false,
    this.enableDrag = false,
  });

  static void show({
    required String title,
    required String message,
    required String buttonText,
    required VoidCallback onButtonTap,
    bool isDismissible = false,
    bool enableDrag = false,
  }) {
    Get.bottomSheet(
      SuccessBottomSheet(
        title: title,
        message: message,
        buttonText: buttonText,
        onButtonTap: onButtonTap,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
      ),
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Success Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: firstColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle,
              color: firstColor,
              size: 40,
            ),
          ),
          const SizedBox(height: 20),
          
          // Success Message
          CustomText(
            text: title,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: blackColor,
            align: TextAlign.center,
          ),
          const SizedBox(height: 10),
          
          CustomText(
            text: message,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: blackColor.withOpacity(0.6),
            align: TextAlign.center,
          ),
          const SizedBox(height: 30),
          
          // Action Button
          CommonButton(
            text: buttonText,
            textColor: whiteColor,
            bgColor: firstColor,
            width: double.infinity,
            verticalPadding: 15,
            radius: 10,
            onTap: onButtonTap,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
} 