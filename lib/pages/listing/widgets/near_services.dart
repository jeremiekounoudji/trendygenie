import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trendygenie/controllers/company_controller.dart';
import 'package:trendygenie/pages/listing/see_all_selected_category_companies.dart';
import 'package:trendygenie/utils/globalVariable.dart';
import 'package:trendygenie/pages/home/widget/restaurant_card.dart';

import '../../../models/company_model.dart';

class TopRestaurant extends StatelessWidget {
  TopRestaurant({Key? key}) : super(key: key);

  final CompanyController companyController = Get.find<CompanyController>();

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
                      // companies: companyController.companiesMap['near-restaurants']??[],
                      // isLoading: companyController.isLoading.value,
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
          FutureBuilder<bool>(
            future: companyController.fetchNearRestaurants(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError || (snapshot.data != null && !snapshot.data!)) {
                return Center(
                  child: CustomText(
                    text: companyController.error.value,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.red,
                  ),
                );
              }

              if (companyController.companiesMap['near-restaurants']?.isEmpty ?? true) {
                return Center(
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
                itemCount: companyController.companiesMap['near-restaurants']?.length ?? 0,
                itemBuilder: (context, index) {
                  final company = companyController.companiesMap['near-restaurants']?[index];
                  return CompanyCard(company: company!);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
