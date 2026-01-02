import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trendygenie/controllers/business_controller.dart';
import 'package:trendygenie/pages/listing/see_all_selected_category_companies.dart';
import 'package:trendygenie/utils/globalVariable.dart';
import '../../../widgets/business/business_card.dart';
import '../../../models/business_model.dart';

class TopRestaurant extends StatelessWidget {
  TopRestaurant({super.key});

  final BusinessController businessController = Get.put(BusinessController());
  final RxList<BusinessModel> nearbyRestaurants = <BusinessModel>[].obs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'Best Restaurants Near You',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
              TextButton(
                onPressed: () => Get.to(() => SeeAllSelectedCategoryCompanies(
                      categoryTitle: "Restaurants Near you",
                      businesses: nearbyRestaurants,
                      isLoading: businessController.isLoading.value,
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
          FutureBuilder<List<BusinessModel>>(
            future: businessController.fetchNearRestaurants(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: CustomText(
                    text: businessController.error.value,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.red,
                  ),
                );
              }

              final restaurants = snapshot.data ?? [];
              nearbyRestaurants.value = restaurants;

              if (restaurants.isEmpty) {
                return const Center(
                  child: CustomText(
                    text: 'No restaurants found nearby',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: restaurants.length,
                itemBuilder: (context, index) {
                  final business = restaurants[index];
                  return BusinessCard(
                    business: business,
                    index: index,
                    businessController: businessController,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
