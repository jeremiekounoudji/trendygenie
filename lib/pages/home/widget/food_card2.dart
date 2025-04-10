import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trendygenie/utils/globalVariable.dart';
import 'package:trendygenie/widgets/general_widgets/common_image.dart';
import 'package:trendygenie/models/service_item.dart';
import 'package:trendygenie/pages/listing/service_details_page.dart';

class FoodCard2 extends StatelessWidget {
  final ServiceItem service;

  const FoodCard2({
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
            Stack(
              children: [
                CommonImageWidget(
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
                    child: Icon(Icons.error, color: Colors.red),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: CustomText(
                      text: service.category.name,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900]!,
                    ),
                  ),
                ),
              ],
            ),
           Expanded(child: 
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1,horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: service.title,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: blackColor,
                          ),
                          SizedBox(
                            width: 150,
                            child: CustomText(
                            text: service.description,
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey[600]!,
                            max: 2,
                          ),)
                          
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
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
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: '\$${service.price.toStringAsFixed(2)}/hr',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: firstColor,
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
                  ),
                 
                ],
              ),
            ),)
          ],
        ),
      ),
    );
  }
}