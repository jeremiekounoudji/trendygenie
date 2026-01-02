import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../controllers/business_controller.dart';
import '../../../../../utils/globalVariable.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String businessId;
  final String businessName;
  final BusinessController businessController;

  const DeleteConfirmationDialog({
    super.key,
    required this.businessId,
    required this.businessName,
    required this.businessController,
  });

  static void show({
    required String businessId,
    required String businessName,
    required BusinessController businessController,
  }) {
    Get.dialog(
      DeleteConfirmationDialog(
        businessId: businessId,
        businessName: businessName,
        businessController: businessController,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(Icons.warning, color: redColor),
          const SizedBox(width: 8),
          CustomText(
            text: 'Delete Business',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: blackColor,
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Are you sure you want to delete "$businessName"?',
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Colors.grey[800]!,
          ),
          const SizedBox(height: 8),
          CustomText(
            text: 'This action cannot be undone.',
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: Colors.grey[600]!,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: CustomText(
            text: 'Cancel',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: blackColor,
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            Get.back();
            await businessController.deleteBusiness(businessId);
            Get.back();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: redColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: CustomText(
            text: 'Delete',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: whiteColor,
          ),
        ),
      ],
    );
  }
}
