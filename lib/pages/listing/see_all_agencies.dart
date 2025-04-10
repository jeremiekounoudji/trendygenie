import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trendygenie/models/service_item.dart';
import 'package:trendygenie/pages/home/widget/agency_card.dart';
import 'package:trendygenie/widgets/general_widgets/shimmer.dart';
import '../../utils/globalVariable.dart';
import '../../widgets/general_widgets/textfield.dart';

class SeeAllAgenciesPage extends StatelessWidget {
  final String categoryTitle;
  final List<ServiceItem> services;
  final bool isLoading;
  final TextEditingController searchController = TextEditingController();

  SeeAllAgenciesPage({
    Key? key,
    required this.categoryTitle,
    required this.services,
    this.isLoading = false,
  }) : super(key: key);

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
                      icon: Icon(Icons.arrow_back, color: firstColor),
                      onPressed: () => Get.back(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  CustomText(
                    text: categoryTitle,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: blackColor,
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomTextField(
                hintText: 'Search agencies...',
                controller: searchController,
                radius: 10,
                showLabel: false,
                borderColor: whiteColor,
                fillColor: bgColor,
                filled: true,
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                onChanged: (value) {
                  // Implement search logic here
                  print('Searching for: $value');
                },
                
              ),
            ),

            SizedBox(height: 16),

            // Services List
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.builder(
                  itemCount: isLoading ? 3 : services.length,
                  itemBuilder: (context, index) {
                    if (isLoading) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: LoadingShimmer(
                          h: 200,
                          w: double.infinity,
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: AgencyCard(service: services[index]),
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