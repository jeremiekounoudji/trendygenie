import 'package:flutter/material.dart';
import '../../../../../models/service_item.dart';
import '../../../../../utils/globalVariable.dart';
import '../../../../../utils/currency_helper.dart';

class ServiceHeaderInfo extends StatelessWidget {
  final ServiceItem service;

  const ServiceHeaderInfo({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and Price
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomText(
                text: service.title,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
            ),
            CustomText(
              text: CurrencyHelper.formatPrice(service.promotionalPrice, service.currency),
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: firstColor,
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Rating and Location Row
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 20),
            const SizedBox(width: 4),
            CustomText(
              text: service.rating.toString(),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: blackColor,
            ),
            const SizedBox(width: 16),
            Icon(Icons.location_on_outlined, color: Colors.grey[600], size: 20),
            const SizedBox(width: 4),
            CustomText(
              text: '${service.distance.toStringAsFixed(1)} km',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
            if (service.viewCount > 0) ...[
              const SizedBox(width: 16),
              Icon(Icons.remove_red_eye_outlined, color: Colors.grey[600], size: 20),
              const SizedBox(width: 4),
              CustomText(
                text: '${service.viewCount} views',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ],
          ],
        ),
        const SizedBox(height: 20),

        // Category Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: firstColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: CustomText(
            text: service.category.name,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: firstColor,
          ),
        ),
      ],
    );
  }
}
