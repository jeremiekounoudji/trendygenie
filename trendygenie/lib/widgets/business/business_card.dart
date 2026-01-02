import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/business_model.dart';
import '../../utils/globalVariable.dart';
import '../../controllers/business_controller.dart';
import '../../widgets/general_widgets/common_image.dart';
import '../../pages/listing/company_services_page.dart';
import 'business_hours_display.dart';

class BusinessCard extends StatelessWidget {
  final BusinessModel business;
  final int index;
  final BusinessController businessController;

  const BusinessCard({
    super.key,
    required this.business,
    required this.index,
    required this.businessController,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => CompanyServicesPage(
          companyId: business.companyId, 
          categoryName: business.category?.name ?? "", 
          companyName: business.name,
          business: business,
        ));
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
            // Image container with CommonImageWidget
            CommonImageWidget(
              isLocalImage: false,
              onlineImagePath: business.logoUrl,
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
                child: const Icon(Icons.error, color: Colors.red),
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Profile row
                    Row(
                      children: [
                        // Profile image
                        const CircleAvatar(
                          radius: 16,
                          backgroundImage:
                              AssetImage('assets/images/profile.jpg'),
                        ),
                        const SizedBox(width: 8),
                        // Name and rating
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: business.name,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: blackColor,
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 14),
                                  const SizedBox(width: 4),
                                  CustomText(
                                    text: business.rating.toString(),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600]!,
                                  ),
                                  const Spacer(),
                                  if (business.businessHours.isNotEmpty)
                                    BusinessHoursDisplay(
                                      businessHours: business.businessHours,
                                      isCompact: true,
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Address
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: CustomText(
                            text: business.address,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: firstColor,
                            max: 1,
                          ),
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