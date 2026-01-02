import 'package:flutter/material.dart';
import '../../../../../models/service_item.dart';
import '../../../../../utils/globalVariable.dart';
import 'service_section_card.dart';

class ServicePropertyDetails extends StatelessWidget {
  final ServiceItem service;

  const ServicePropertyDetails({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    // Check if we have any property details to show
    bool hasPropertyDetails = service.propertyType != null ||
        service.bedroomCount != null ||
        service.bathroomCount != null ||
        service.hasKitchen != null;
    
    if (!hasPropertyDetails) {
      return const SizedBox.shrink();
    }

    return ServiceSectionCard(
      title: 'Property Details',
      customColor: Colors.purple,
      children: [
        if (service.propertyType != null)
          _buildDetailRow('Property Type', service.propertyType!),
        if (service.bedroomCount != null)
          _buildDetailRow('Bedrooms', service.bedroomCount!.toString()),
        if (service.bathroomCount != null)
          _buildDetailRow('Bathrooms', service.bathroomCount!.toString()),
        if (service.hasKitchen != null)
          _buildDetailRow('Kitchen', service.hasKitchen! ? 'Available' : 'Not Available'),
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