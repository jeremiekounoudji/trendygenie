import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trendygenie/utils/globalVariable.dart';
import 'package:trendygenie/utils/currency_helper.dart';
import 'package:trendygenie/widgets/general_widgets/common_image.dart';
import 'package:trendygenie/models/service_item.dart';
import '../../../pages/listing/service_details_page.dart';

class FoodCard extends StatelessWidget {
  final ServiceItem service;
  final VoidCallback? onTap;

  const FoodCard({
    super.key,
    required this.service,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {
        Get.to(() => ServiceDetailsPage(service: service));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16, bottom: 8),
        width: 300,
        height: 110,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CommonImageWidget(
              isLocalImage: false,
              onlineImagePath: service.images.isNotEmpty 
                  ? service.images.first 
                  : 'https://via.placeholder.com/300x200?text=No+Image',
              rounded: 10,
              width: 100,
              height: 90,
              loadingWidget: Container(
                color: Colors.grey[300],
                width: 100,
                height: 100,
              ),
              errorWidget: Container(
                color: Colors.grey[300],
                width: 100,
                height: 100,
                child: const Icon(Icons.restaurant, color: Colors.grey),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.restaurant_menu, size: 16),
                        const SizedBox(width: 8),
                        CustomText(
                          text: service.category.name,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600]!,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    CustomText(
                      text: service.title,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: blackColor,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        CustomText(
                          text: service.rating.toString(),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600]!,
                        ),
                        const SizedBox(width: 8),
                        CustomText(
                          text: CurrencyHelper.formatPrice(service.promotionalPrice, service.currency),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: firstColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
