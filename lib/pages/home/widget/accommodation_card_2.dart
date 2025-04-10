import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trendygenie/utils/globalVariable.dart';
import 'package:trendygenie/widgets/general_widgets/common_image.dart';
import 'package:trendygenie/models/service_item.dart';
import 'package:trendygenie/pages/listing/service_details_page.dart';
import 'package:trendygenie/widgets/general_widgets/spacer.dart';

class AccommodationCard2 extends StatelessWidget {
  final ServiceItem service;

  const AccommodationCard2({
    Key? key,
    required this.service,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => ServiceDetailsPage(service: service)),
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
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
              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleAndRating(),
                  Verticalspace(h: 3),
                  _buildDescription(),
                  const SizedBox(height: 4),
                  _buildCharacteristics(),
                  const SizedBox(height: 2),
                  _buildPriceAndDistance(),
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
      onlineImagePath: service.image,
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

  Widget _buildTitleAndRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 180,
          child: CustomText(
            text: service.title,
            align: TextAlign.left,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            max: 1,
            color: blackColor,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
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

  Widget _buildDescription() {
    return SizedBox(
      width: 250,
      child: CustomText(
        text: service.description,
        fontSize: 13,
        fontWeight: FontWeight.normal,
        max: 2,
        overflow: TextOverflow.ellipsis,
        color: blackColor.withOpacity(.5),
      ),
    );
  }

  Widget _buildCharacteristics() {
    return CustomText(
      text: service.caracteristics?.join('. ') ?? 'No characteristics',
      fontSize: 12,
      fontWeight: FontWeight.normal,
      max: 2,
      color: firstColor,
    );
  }

  Widget _buildPriceAndDistance() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: '\$${service.price.toStringAsFixed(2)}/night',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: blackColor,
        ),
        Row(
          children: [
            Icon(Icons.location_on_outlined, color: Colors.grey[600], size: 16),
            const SizedBox(width: 4),
            CustomText(
              text: '${service.distance.toStringAsFixed(1)}km',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600]!,
            ),
          ],
        ),
      ],
    );
  }
}
