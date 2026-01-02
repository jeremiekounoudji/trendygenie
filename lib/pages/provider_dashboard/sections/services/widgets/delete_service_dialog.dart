import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trendygenie/utils/globalVariable.dart';
import 'package:trendygenie/widgets/general_widgets/common_button.dart';

class DeleteServiceDialog extends StatefulWidget {
  final String serviceName;
  final Future<void> Function() onConfirm;

  const DeleteServiceDialog({
    super.key,
    required this.serviceName,
    required this.onConfirm,
  });

  @override
  State<DeleteServiceDialog> createState() => _DeleteServiceDialogState();
}

class _DeleteServiceDialogState extends State<DeleteServiceDialog> {
  final RxBool isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Warning Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_rounded,
                color: Colors.red,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),

            // Title
            CustomText(
              text: 'Request Service Deletion',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: blackColor,
            ),
            const SizedBox(height: 12),

            // Description
            CustomText(
              text: 'Are you sure you want to request deletion of "${widget.serviceName}"? This will send a delete request to admin for review. You can cancel this request anytime before it\'s approved.',
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Colors.grey[600],
              align: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: CommonButton(
                    text: 'Cancel',
                    onTap: () {
                      if (!isLoading.value) {
                        Get.back();
                      }
                    },
                    bgColor: bgColor,
                    radius: 12,
                    textColor: blackColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CommonButton(
                    text: 'Request',
                    onTap: () async {
                      if (!isLoading.value) {
                        isLoading.value = true;
                        
                        await widget.onConfirm();
                        
                        if (mounted) {
                          isLoading.value = false;
                        }
                      }
                    },
                    bgColor: Colors.red,
                    radius: 12,
                    textColor: whiteColor,
                    isLoading: isLoading,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 