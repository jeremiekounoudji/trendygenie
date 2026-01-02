import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/company_services_controller.dart';
import '../../../models/service_item.dart';
import '../../../models/business_model.dart';
import '../../../models/enums.dart';
import '../../../utils/globalVariable.dart';
import '../../../widgets/general_widgets/shimmer.dart';
import '../../home/widget/accommodation_card.dart';
import '../../home/widget/agency_card.dart';
import '../../home/widget/food_card.dart';
import '../../provider_dashboard/sections/services/business_service_detail_page.dart';

class ServicesList extends StatelessWidget {
  final CompanyServicesController controller;
  final ScrollController scrollController;
  final String categoryName;
  final BusinessModel? business;
  final bool isOwner;

  const ServicesList({
    super.key,
    required this.controller,
    required this.scrollController,
    required this.categoryName,
    this.business,
    this.isOwner = false,
  });

  Widget _buildServiceCard(ServiceItem service) {
    // Define navigation callback
    VoidCallback? onTapCallback;
    if (isOwner && business != null) {
      onTapCallback = () => Get.to(() => BusinessServiceDetailPage(
        service: service,
        business: business!,
      ));
    }
    
    final serviceCard = _getServiceCardWidget(service, onTapCallback);
    
    // Add red border if service is pending deletion
    if (service.status == ServiceStatus.requestDeletion.name) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.red.withValues(alpha: 0.6),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withValues(alpha: 0.1),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Stack(
          children: [
            serviceCard,
            // Deletion pending indicator
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomText(
                  text: 'Deletion Pending',
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    }
    
    return serviceCard;
  }

  Widget _getServiceCardWidget(ServiceItem service, VoidCallback? onTap) {
    switch (categoryName.toLowerCase()) {
      case 'hotel':
      case 'apartment':
        return AccommodationCard(service: service, onTap: onTap);
      case 'restaurant':
      case 'cafe':
        return FoodCard(service: service, onTap: onTap);
      case 'agency':
        return AgencyCard(service: service, onTap: onTap);
      default:
        return FoodCard(service: service, onTap: onTap);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return FutureBuilder<List<ServiceItem>>(
        future: controller.initialFetch.obs.value,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && !controller.hasData.value) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 3,
              itemBuilder: (context, index) => const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: LoadingShimmer(
                  h: 110,
                  w: double.infinity,
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            return const Center(
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
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: controller.services.length + (controller.hasMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.services.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
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
    });
  }
}