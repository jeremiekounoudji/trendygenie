import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trendygenie/models/service_item.dart';
import 'package:trendygenie/pages/home/widget/accommodation_card_2.dart';
import 'package:trendygenie/widgets/general_widgets/shimmer.dart';
import '../../utils/globalVariable.dart';
import '../../widgets/general_widgets/textfield.dart';

class SeeAllAccommodationPage extends StatelessWidget {
  final String categoryTitle;
  final List<ServiceItem> services;
  final bool isLoading;
  final TextEditingController searchController = TextEditingController();

  SeeAllAccommodationPage({
    super.key,
    required this.categoryTitle,
    required this.services,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: bgColor,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: blackColor),
                      onPressed: () => Get.back(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomText(
                      text: categoryTitle,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: blackColor,
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar using CustomTextField
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomTextField(
                controller: searchController,
                hintText: 'Search in $categoryTitle',
                prefixIcon: const Icon(Icons.search),
                radius: 12,
                filled: true,
                fillColor: bgColor,
                borderColor: Colors.transparent,
                showLabel: false,
                onChanged: (value) {
                  // Implement search logic here
                  print('Searching for: $value');
                },
              ),
            ),

            const SizedBox(height: 16),

            // Services List
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.builder(
                  itemCount: isLoading ? 3 : services.length,
                  itemBuilder: (context, index) {
                    if (isLoading) {
                      return const Padding(
                        padding: EdgeInsets.only(bottom: 16.0),
                        child: LoadingShimmer(
                          h: 200,

                          w: double.infinity,
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: AccommodationCard2(service: services[index]),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}