import 'package:flutter/material.dart';
import '../../../../../models/service_item.dart';
import '../../../../../utils/globalVariable.dart';
import 'service_section_card.dart';

class ServiceFoodDetails extends StatelessWidget {
  final ServiceItem service;

  const ServiceFoodDetails({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    // Check if we have any food service details to show
    bool hasFoodDetails = service.foodCategory != null ||
        service.cuisine != null ||
        service.isDeliveryAvailable != null;
    
    if (!hasFoodDetails) {
      return const SizedBox.shrink();
    }

    return ServiceSectionCard(
      title: 'Food Service Details',
      customColor: Colors.red,
      children: [
        if (service.cuisine != null)
          _buildDetailRow('Cuisine', service.cuisine!),
        if (service.foodCategory != null)
          _buildDetailRow('Food Category', service.foodCategory!),
        if (service.isDeliveryAvailable != null)
          _buildDetailRow('Delivery',
            service.isDeliveryAvailable! ? 'Available' : 'Not Available'),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: firstColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomText(
              text: label,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: firstColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CustomText(
              text: value,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: blackColor,
            ),
          ),
        ],
      ),
    );
  }
}