import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trendygenie/pages/home/widget/agency_card.dart';
import 'package:trendygenie/pages/home/widget/food_card2.dart';
import '../../../controllers/services_controller.dart';
import '../../../utils/globalVariable.dart';
import '../category_services_page.dart';

class TopFoods extends StatelessWidget {
  TopFoods({super.key});

  final ServicesController serviceController = Get.find<ServicesController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'Top Foods',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
              TextButton(
      onPressed: () => Get.to(() => const CategoryServicesPage(
        categoryTitle: "Recommended Services",
        categoryId: "topServices",
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
          const SizedBox(height: 16),
          SizedBox(
            height: 230,
            child: Obx(() => ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: serviceController.topServices.length,
              itemBuilder: (context, index) {
                final service = serviceController.topServices[index];
                return FoodCard2(service: service);
              },
            )),
          ),
        ],
      ),
    );
  }
}