import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trendygenie/widgets/general_widgets/common_image.dart';
import 'package:trendygenie/widgets/general_widgets/shimmer.dart';
import '../models/business_model.dart';
import '../models/service_item.dart';
import '../utils/globalVariable.dart';
import '../utils/currency_helper.dart';
import '../pages/provider_dashboard/sections/services/business_service_detail_page.dart';

class ServiceCard extends StatelessWidget {
  final ServiceItem service;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;
  final BusinessModel business;

  const ServiceCard({
    super.key,
    required this.service,
    this.onEdit,
    this.onDelete,
    this.showActions = false,
    required this.business,
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

  @override
  Widget build(BuildContext context) {
    final status = service.status ?? 'pending';  // Default to pending if null
    
    return GestureDetector(
      onTap: () => Get.to(() => BusinessServiceDetailPage(service: service, business: business)),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                // Service Image
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: CommonImageWidget(
                      onlineImagePath: service.images.isNotEmpty 
                          ? service.images.first 
                          : 'https://via.placeholder.com/300x200?text=No+Image',
                      width: 100,
                      height: 100,
                      isLocalImage: false,
                      rounded: 16,
                      loadingWidget: const LoadingShimmer(h: 100, w: 100),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service Title
                  CustomText(
                    text: service.title,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: blackColor,
                    max: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Service Description
                  CustomText(
                    text: service.description,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey[600],
                    max: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Price and Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: CurrencyHelper.formatPrice(service.promotionalPrice, service.currency),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: firstColor,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        margin: const EdgeInsets.only(left: 30),
                        decoration: BoxDecoration(
                          color: _getStatusColor(status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getStatusColor(status),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _getStatusColor(status).withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: CustomText(
                          text: status.toUpperCase(),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(status),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 