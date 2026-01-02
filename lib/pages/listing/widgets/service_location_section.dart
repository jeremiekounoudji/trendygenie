import 'package:flutter/material.dart';
import '../../../models/service_item.dart';
import '../../../utils/globalVariable.dart';

class ServiceLocationSection extends StatelessWidget {
  final ServiceItem service;

  const ServiceLocationSection({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "Location",
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: blackColor,
        ),
        const SizedBox(height: 12),
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: mediumBorder,
            border: Border.all(color: Colors.grey[300]!),
            color: Colors.grey[100],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, 
                   color: firstColor, size: 48),
              const SizedBox(height: 8),
              CustomText(
                text: "Location Map",
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: blackColor,
              ),
              const SizedBox(height: 4),
              if (service.business != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomText(
                    text: service.business!.address,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey[600],
                    align: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}