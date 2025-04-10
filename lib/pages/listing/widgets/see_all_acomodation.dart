import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/service_item.dart';
import '../../../utils/globalVariable.dart';
import '../../../widgets/general_widgets/common_image.dart';
import '../../../widgets/general_widgets/shimmer.dart';
import '../../home/widget/accommodation_card.dart';
import '../../home/widget/accommodation_card_2.dart';
import '../../home/widget/food_card2.dart';
import '../see_all_accomodation.dart';

class AccomodationsCategoryList extends StatelessWidget {
  final List<ServiceItem> services;
  final bool isLoading;

  const AccomodationsCategoryList({
    super.key,
    required this.services,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'Accomodations',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
              TextButton(
                onPressed: () => Get.to(() => SeeAllAccommodationPage(
                      categoryTitle: "Accomodations",
                      services: services,
                      isLoading: isLoading,
                    )),
                child: CustomText(
                  text: "See all",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: firstColor,
                ),
              ),
            ],
          ),
          if (isLoading) 
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: LoadingShimmer(h: 200, w: 280),
                ),
              ),
            )
          else
            SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return AccommodationCard2(service: service);
                },
              ),
            ),
        ],
      ),
    );
  }
}