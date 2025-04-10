import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trendygenie/models/service_item.dart';
import 'package:trendygenie/pages/home/widget/agency_card.dart';
import 'package:trendygenie/widgets/general_widgets/shimmer.dart';
import '../../../utils/globalVariable.dart';
import '../see_all_agencies.dart';

class AgenciesList extends StatelessWidget {
  final List<ServiceItem> services;
  final bool isLoading;

  const AgenciesList({
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
                text: 'Top Agencies',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
              TextButton(
                onPressed: () => Get.to(() => SeeAllAgenciesPage(
                      categoryTitle: "Top Agencies",
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
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return AgencyCard(service: service);
                },
              ),
            ),
        ],
      ),
    );
  }
} 