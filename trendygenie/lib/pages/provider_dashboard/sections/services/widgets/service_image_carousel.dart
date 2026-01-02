import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../../utils/globalVariable.dart';
import '../../../../../widgets/general_widgets/common_image.dart';
import '../../../../../widgets/general_widgets/shimmer.dart';

class ServiceImageCarousel extends StatelessWidget {
  final List<String> images;
  final PageController pageController;
  final RxInt currentPage;

  const ServiceImageCarousel({
    super.key,
    required this.images,
    required this.pageController,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return Container(
        height: Get.height * 0.45,
        color: Colors.grey[300],
        child: const Center(
          child: Icon(Icons.image_not_supported, size: 64, color: Colors.grey),
        ),
      );
    }

    return SizedBox(
      height: Get.height * 0.45,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: pageController,
            onPageChanged: (index) => currentPage.value = index,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return CommonImageWidget(
                onlineImagePath: images[index],
                width: double.infinity,
                height: Get.height * 0.45,
                isLocalImage: false,
                rounded: 0,
                loadingWidget: LoadingShimmer(h: Get.height * 0.45, w: double.infinity),
              );
            },
          ),
          // Page Indicator
          Positioned(
            bottom: 16,
            child: SmoothPageIndicator(
              controller: pageController,
              count: images.length,
              effect: ScaleEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: firstColor,
                dotColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}