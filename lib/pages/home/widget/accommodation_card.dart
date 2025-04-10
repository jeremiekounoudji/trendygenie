import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trendygenie/utils/globalVariable.dart';
import 'package:trendygenie/widgets/general_widgets/common_image.dart';
import 'package:trendygenie/models/service_item.dart';
import '../../../pages/listing/service_details_page.dart';

class AccommodationCard extends StatelessWidget {
  final ServiceItem service;

  const AccommodationCard({
    Key? key,
    required this.service,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
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
              onlineImagePath: service.image,
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
                child: Icon(Icons.error, color: Colors.red),
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
                        Icon(Icons.home, size: 16),
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
                        Icon(Icons.bed, size: 14),
                        const SizedBox(width: 4),
                        CustomText(
                          text: '${service.bedroomCount ?? 2} Beds',
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[600]!,
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.bathroom_outlined, size: 14),
                        const SizedBox(width: 4),
                        CustomText(
                          text: '${service.bathroomCount ?? 1} Bath',
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[600]!,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        CustomText(
                          text: service.rating.toString(),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600]!,
                        ),
                        const SizedBox(width: 8),
                        CustomText(
                          text: '\$${service.price.toStringAsFixed(2)}/night',
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