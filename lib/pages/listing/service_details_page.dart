import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trendygenie/models/service_item.dart';
import 'package:trendygenie/utils/globalVariable.dart';
import 'package:trendygenie/widgets/general_widgets/common_image.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:trendygenie/widgets/general_widgets/spacer.dart';

class ServiceDetailsPage extends StatelessWidget {
  final ServiceItem service;

  const ServiceDetailsPage({
    Key? key,
    required this.service,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image and top buttons
            Stack(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: CommonImageWidget(
                    isLocalImage: false,
                    onlineImagePath: service.image,
                    height: 400,
                    width: double.infinity,
                    rounded: 30,
                    loadingWidget: Container(
                      height: 400,
                      width: double.infinity,
                      color: Colors.grey[300],
                    ),
                    errorWidget: Container(
                      height: 400,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: Icon(Icons.error, color: Colors.red),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: whiteColor,
                          radius: 20,
                          child: IconButton(
                            icon: Icon(Icons.arrow_back,
                                color: blackColor, size: 20),
                            onPressed: () => Get.back(),
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: whiteColor,
                          radius: 20,
                          child: IconButton(
                            icon: Icon(Icons.favorite_border_outlined,
                                color: blackColor, size: 20),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Rating
                  CustomText(
                    text: service.title,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: blackColor,
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star,
                          color: const Color.fromARGB(255, 255, 196, 0),
                          size: 16),
                      SizedBox(width: 4),
                      CustomText(
                        text: "${service.rating}",
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: blackColor,
                      ),
                      CustomText(
                        text: " (${service.rating} reviews)",
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Entire home section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "Entire home",
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: blackColor,
                          ),
                          CustomText(
                            text: "Hosted by ${service.title}",
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey[600],
                          ),
                        ],
                      ),
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(service.image),
                      ),
                    ],
                  ),

                  // description
                  Verticalspace(h: 20),
                  CustomText(
                    text:
                        "Check yourself in with the lockbox Check yourself in with the lockboxCheck yourself in with the lockboxCheck yourself in with the lockboxCheck yourself in with the lockbox",
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    max: 10,
                    overflow: TextOverflow.ellipsis,
                    color: Colors.grey[900],
                  ),

                  Divider(height: 48, color: Colors.grey[300]),

                  // Amenities
                  CustomText(
                    text: "Caracteristics",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: blackColor,
                  ),
                  SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _tagCard(Icons.wifi, "Wi-Fi"),
                      _tagCard(Icons.tv, "65\" HDTV"),
                      _tagCard(Icons.fireplace, "Indoor fireplace"),
                      _tagCard(Icons.dry, "Hair dryer"),
                      _tagCard(Icons.local_laundry_service, "Washing machine"),
                      _tagCard(Icons.dry_cleaning, "Dryer"),
                      _tagCard(Icons.kitchen, "Refrigerator"),
                      _tagCard(Icons.wash, "Dishwasher"),
                    ],
                  ),

                  Divider(height: 48, color: Colors.grey[300]),

                  // Location Map
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "Location",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: blackColor,
                      ),
                      SizedBox(height: 12),
                      Container(
                        height: 300,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: mediumBorder,
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: ClipRRect(
                          borderRadius: mediumBorder,
                          child: OpenStreetMapSearchAndPick(
                            buttonColor: firstColor,
                            buttonText: 'Location',
                            onPicked: (pickedData) {
                              // Handle picked location if needed
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: firstColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomText(
                    text: "€${service.price}",
                    fontSize: 20,
                    align: TextAlign.center,
                    fontWeight: FontWeight.bold,
                    color: whiteColor,
                  ),
                ),
                // CustomText(
                //   text: "14-21 Oct · 3 nights",
                //   fontSize: 14,
                //   fontWeight: FontWeight.normal,
                //   color: Colors.grey[600],
                // ),
              ],
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: whiteColor,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: largeBorder,
                ),
              ),
              child: CustomText(
                text: "Book now",
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: firstColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tagCard(IconData icon, String label) {
    return Container(
      // width: 50,
      decoration: BoxDecoration(
        color: firstColor.withOpacity(.1),
        borderRadius: smallerBorder,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      margin: EdgeInsets.only(right: 8),
      child: IntrinsicWidth(
        child: Row(
          children: [
            // Icon(icon, size: 15, color: blackColor.withOpacity(.4)),
            // SizedBox(width: 5),
            CustomText(
              text: label,
              fontSize: 13,
              fontWeight: FontWeight.normal,
              color: blackColor,
            ),
          ],
        ),
      ),
    );
  }
}
