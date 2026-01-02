import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trendygenie/widgets/service_card.dart';
import '../../../../../controllers/services_controller.dart';
import '../../../../../models/business_model.dart';
import '../../../../../models/enums.dart';
import '../../../../../utils/globalVariable.dart';
import '../../../../../widgets/general_widgets/shimmer.dart';
import '../add_service_page.dart';

class ServicesTab extends StatelessWidget {
  final BusinessModel business;
  final ServicesController servicesController;
  final ScrollController? scrollController;
  final Function? onLoadMore;

  const ServicesTab({
    super.key,
    required this.business,
    required this.servicesController,
    this.scrollController,
    this.onLoadMore,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'active':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'suspended':
        return Colors.grey;
      case 'deleted':
        return Colors.black;
      default:
        return Colors.grey;
    }
  }

  Widget _buildFilterChipsRow() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip(
            'All',
            isSelected: servicesController.selectedStatus.value == null,
            onSelected: (selected) {
              if (selected) {
                servicesController.selectedStatus.value = null;
                servicesController.fetchServicesForBusiness(business.id!, 0, 10);
              }
            },
          ),
          const SizedBox(width: 8),
          ...ServiceStatus.values.map((status) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _buildFilterChip(
              status.name.toUpperCase(),
              isSelected: servicesController.selectedStatus.value == status.name,
              onSelected: (selected) {
                servicesController.selectedStatus.value = selected ? status.name : null;
                servicesController.fetchServicesForBusiness(business.id!, 0, 10);
              },
            ),
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder<bool>(
          future: servicesController.fetchServicesForBusiness(business.id!, 0, 10),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingState();
            }

            return Obx(() {
              if (servicesController.services.isEmpty) {
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildFilterChipsRow(),
                    const SizedBox(height: 32),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.business_center_outlined, 
                            size: 64, 
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          CustomText(
                            text: 'No services available',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600]!,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              return ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: servicesController.services.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildFilterChipsRow();
                  }
                  final service = servicesController.services[index - 1];
                  return ServiceCard(
                    service: service, 
                    onEdit: () {},
                    business: business,
                    onDelete: () {}
                  );
                },
              );
            });
          },
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            backgroundColor: firstColor,
            onPressed: () => Get.to(() => AddServicePage(business: business)),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, {
    required bool isSelected,
    required Function(bool) onSelected,
  }) {
    return FilterChip(
    
      label: CustomText(
        text: label,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: isSelected ? Colors.white : firstColor,
      ),
      
      selected: isSelected,
      selectedColor: firstColor,
      backgroundColor: Colors.white,
      showCheckmark: false,
      shape: RoundedRectangleBorder(
      side: BorderSide.none,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      onSelected: onSelected,
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: LoadingShimmer(
            h: 120,
            w: double.infinity,
          ),
        );
      },
    );
  }
} 