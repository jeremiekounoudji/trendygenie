import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trendygenie/controllers/category_controller.dart';
import 'package:trendygenie/controllers/services_controller.dart';
import 'package:trendygenie/pages/listing/widgets/agencies_list.dart';
import 'package:trendygenie/pages/listing/widgets/top_foods.dart';
import 'package:trendygenie/pages/profile/profile_page.dart';
import 'package:trendygenie/utils/globalVariable.dart';
import 'package:trendygenie/widgets/general_widgets/spacer.dart';
import 'package:trendygenie/widgets/general_widgets/textfield.dart';

import 'widgets/near_services.dart';
import 'widgets/recent_places.dart';
import 'widgets/see_all_acomodation.dart';

class ListingPage extends StatelessWidget {
  ListingPage({super.key});

  final ServicesController serviceController = Get.put(ServicesController());
  final CategoryController categoryController = Get.put(CategoryController());
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: firstColor,
              child: Column(
                children: [
                  // Header
                  const Verticalspace(h: 30),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: Icon(
                            Icons.arrow_back_ios,
                            size: 20,
                            color: whiteColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        CustomText(
                          text: 'Hi There',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: whiteColor.withValues(alpha: 0.9),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => Get.to(() => ProfilePage()),
                          child: const CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                AssetImage('assets/images/profile.jpg'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Search bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            hintText: 'Find your best artist...',
                            borderColor: whiteColor,
                            controller: searchController,
                            fillColor: whiteColor,
                            showLabel: false,
                            filled: true,
                            prefixIcon: Icon(
                              Icons.search,
                              color: firstColor,
                            ),
                            radius: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.tune, color: firstColor),
                        ),
                      ],
                    ),
                  ),
                  const Verticalspace(h: 30)
                ],
              ),
            ),

            // Categories
            // _buildCategorySection(),

            // Top services
            Obx(() {
              if (categoryController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (categoryController.categories.isEmpty) {
                return Center(
                  child: CustomText(
                    text: 'No categories found',
                    color: firstColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }

              return Column(
                children: categoryController.categories
                    .map((category) => ServicesList(
                          categoryTitle: category.name,
                          categoryId: category.id,
                        ))
                    .toList(),
              );
            }),

            // Best restauant Around
            TopRestaurant(),

            // CRecent Places
            const RecentPlaces(
              // services: serviceController.categoryOneServices,
              // isLoading: serviceController.isLoading.value,
            ),

            // Category Two
            const Verticalspace(h: 35),
            AccomodationsCategoryList(
              services: serviceController.accomodationServices,
              isLoading: serviceController.isLoading.value,
            ),
            const Verticalspace(h: 35),

            AgenciesList(services: serviceController.accomodationServices)
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    final categories = [
      {'icon': '💅', 'name': 'Manicures'},
      {'icon': '🧖‍️', 'name': 'Facial'},
      {'icon': '✂️', 'name': 'Haircut'},
      {'icon': '🪒', 'name': 'Waxing'},
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Top Services',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: blackColor,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 16),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: firstColor.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          categories[index]['icon']!,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                      const SizedBox(height: 4),
                      CustomText(
                        text: categories[index]['name']!,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: blackColor,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
