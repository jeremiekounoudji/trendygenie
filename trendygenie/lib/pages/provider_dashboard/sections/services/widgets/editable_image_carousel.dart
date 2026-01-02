import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../../../../../utils/globalVariable.dart';
import '../../../../../widgets/general_widgets/common_image.dart';
import '../../../../../widgets/general_widgets/shimmer.dart';

class EditableImageCarousel extends StatelessWidget {
  final RxList<File> selectedImages;
  final RxInt currentImageIndex;
  final List<String> existingImages;
  final VoidCallback onPickImages;

  const EditableImageCarousel({
    super.key,
    required this.selectedImages,
    required this.currentImageIndex,
    required this.existingImages,
    required this.onPickImages,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final totalImages = existingImages.length + selectedImages.length;
      
      if (totalImages == 0) {
        return _buildEmptyState();
      }

      return Container(
        height: Get.height * 0.3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: PageView.builder(
                onPageChanged: (index) => currentImageIndex.value = index,
                itemCount: totalImages,
                itemBuilder: (context, index) {
                  if (index < existingImages.length) {
                    // Show existing image
                    return CommonImageWidget(
                      onlineImagePath: existingImages[index],
                      width: double.infinity,
                      height: Get.height * 0.3,
                      isLocalImage: false,
                      rounded: 15,
                      loadingWidget: LoadingShimmer(
                        h: Get.height * 0.3,
                        w: double.infinity,
                      ),
                    );
                  } else {
                    // Show new selected image
                    final fileIndex = index - existingImages.length;
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.file(
                        selectedImages[fileIndex],
                        width: double.infinity,
                        height: Get.height * 0.3,
                        fit: BoxFit.cover,
                      ),
                    );
                  }
                },
              ),
            ),
            
            // Add Images Button
            Positioned(
              top: 16,
              right: 16,
              child: GestureDetector(
                onTap: onPickImages,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: firstColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.add_photo_alternate,
                    color: whiteColor,
                    size: 20,
                  ),
                ),
              ),
            ),

            // Page Indicator
            if (totalImages > 1)
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CustomText(
                      text: '${currentImageIndex.value + 1} / $totalImages',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: whiteColor,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildEmptyState() {
    return GestureDetector(
      onTap: onPickImages,
      child: Container(
        height: Get.height * 0.3,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.grey[300]!,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 12),
            CustomText(
              text: 'Tap to add images',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 4),
            CustomText(
              text: 'You can select multiple images',
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: Colors.grey[500],
            ),
          ],
        ),
      ),
    );
  }
}