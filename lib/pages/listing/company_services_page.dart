import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/service_item.dart';
import '../../utils/globalVariable.dart';
import '../../widgets/general_widgets/shimmer.dart';
import '../home/widget/accommodation_card.dart';
import '../home/widget/agency_card.dart';
import '../home/widget/food_card.dart';
import '../home/widget/restaurant_card.dart';
import '../../controllers/company_services_controller.dart';

class CompanyServicesPage extends StatefulWidget {
  final String companyId;
  final String categoryName;
  final String companyName;

  const CompanyServicesPage({
    Key? key,
    required this.companyId,
    required this.categoryName,
    required this.companyName,
  }) : super(key: key);

  @override
  State<CompanyServicesPage> createState() => _CompanyServicesPageState();
}

class _CompanyServicesPageState extends State<CompanyServicesPage> {
  late final ScrollController _scrollController;
  late final CompanyServicesController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(CompanyServicesController(companyId: widget.companyId));
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      controller.loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildServiceCard(ServiceItem service) {
    log('widget.categoryName: ${widget.categoryName}');
    switch (widget.categoryName.toLowerCase()) {
      case 'hotel':
      case 'apartment':
        return AccommodationCard(service: service);
      case 'restaurant':
      case 'cafe':
        return FoodCard(service: service);
      case 'agency':
        return AgencyCard(service: service);
      default:
        return FoodCard(service: service);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: whiteColor,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: blackColor),
                      onPressed: () => Get.back(),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: widget.companyName,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: blackColor,
                        ),
                        CustomText(
                          text: widget.categoryName,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: blackColor.withOpacity(0.6),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Services List
            Expanded(
              child: Obx(() {
                return FutureBuilder<List<ServiceItem>>(
                  future: controller.initialFetch.obs.value,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting && !controller.hasData.value) {
                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: 3,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: LoadingShimmer(
                            h: 110,
                            w: double.infinity,
                          ),
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: CustomText(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          text: 'Error loading services',
                          color: Colors.red,
                        ),
                      );
                    }
                    if (controller.services.isEmpty) {
                      return Center(
                        child: CustomText(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          text: 'No services found',
                          color: blackColor,
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: controller.services.length + (controller.hasMore.value ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == controller.services.length) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: _buildServiceCard(controller.services[index]),
                        );
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
} 