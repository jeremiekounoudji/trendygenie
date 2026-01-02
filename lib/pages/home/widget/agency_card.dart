import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trendygenie/utils/globalVariable.dart';
import 'package:trendygenie/widgets/general_widgets/common_image.dart';
import 'package:trendygenie/models/service_item.dart';
import 'package:trendygenie/pages/listing/service_details_page.dart';

class AgencyCard extends StatelessWidget {
  final ServiceItem service;
  final VoidCallback? onTap;

  const AgencyCard({
    super.key,
    required this.service,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Get.to(() => ServiceDetailsPage(service: service)),
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitlePriceRating(),
                 
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return CommonImageWidget(
      isLocalImage: false,
      onlineImagePath: service.images.isNotEmpty 
          ? service.images.first 
          : 'https://via.placeholder.com/300x200?text=No+Image',
      rounded: 16,
      height: 140,
      width: double.infinity,
      loadingWidget: Container(
        color: Colors.grey[300],
        height: 150,
        width: double.infinity,
      ),
      errorWidget: Container(
        color: Colors.grey[300],
        height: 150,
        width: double.infinity,
        child: const Icon(Icons.error, color: Colors.red),
      ),
    );
  }

  Widget _buildTitlePriceRating() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomText(
                text: service.title,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: blackColor,
                max: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
           
          ],
        ),
        Row(
          children: [
            Icon(Icons.location_on, color: firstColor, size: 16),
            const SizedBox(width: 4),
            Expanded(
              child: CustomText(
                text: "${service.distance.toString()} km",
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: blackColor.withValues(alpha: 0.5),
                max: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.star, color: Colors.amber, size: 16),
            const SizedBox(width: 4),
            CustomText(
              text: service.rating.toString(),
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: blackColor,
            ),
          ],
        ),
        
      ],
    );
  }

}