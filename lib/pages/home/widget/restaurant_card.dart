import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trendygenie/models/company_model.dart';
import 'package:trendygenie/models/service_item.dart';
import 'package:trendygenie/utils/globalVariable.dart';
import 'package:trendygenie/widgets/general_widgets/common_image.dart';

import '../../listing/company_services_page.dart';
import '../../listing/service_details_page.dart';


class CompanyCard extends StatelessWidget {
  final CompanyModel company;

  const CompanyCard({
    Key? key,
    required this.company,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Get.to(() => ServiceDetailsPage(company: company));
        Get.to(() => CompanyServicesPage(companyId: company.id!, categoryName: company.category.name, companyName: company.name));
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
            // Image container avec CommonImageWidget
            CommonImageWidget(
              isLocalImage: false,
              onlineImagePath: company.companyLogo,
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
                        CircleAvatar(
                          radius: 16,
                          backgroundImage:
                              AssetImage('assets/images/profile.jpg'),
                        ),
                        const SizedBox(width: 8),
                        // Name and rating
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: company.name,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: blackColor,
                            ),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 14),
                                const SizedBox(width: 4),
                                CustomText(
                                  text: company.rating.toString(),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600]!,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Service title
                    CustomText(
                      text: company.name,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: blackColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          CustomText(
                            text: '12km',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: firstColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Distance indicator
          ],
        ),
      ),
    );
  }
}
