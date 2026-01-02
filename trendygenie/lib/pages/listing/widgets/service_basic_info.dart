import 'package:flutter/material.dart';
import '../../../models/service_item.dart';
import '../../../utils/globalVariable.dart';

class ServiceBasicInfo extends StatelessWidget {
  final ServiceItem service;

  const ServiceBasicInfo({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and Rating
        CustomText(
          text: service.title,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: blackColor,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.star,
                color: Color.fromARGB(255, 255, 196, 0),
                size: 16),
            const SizedBox(width: 4),
            CustomText(
              text: "${service.rating}",
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: blackColor,
            ),
            CustomText(
              text: " (${service.rating} reviews)",
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Colors.grey[600],
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Service Provider Info
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: service.category.name,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: blackColor,
                  ),
                  if (service.business != null) ...[
                    const SizedBox(height: 4),
                    CustomText(
                      text: service.business!.name,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: firstColor,
                    ),
                    const SizedBox(height: 2),
                    CustomText(
                      text: service.business!.address,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey[600],
                    ),
                    if (service.business!.contactPhone.isNotEmpty)
                      CustomText(
                        text: "Phone: ${service.business!.contactPhone.first}",
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey[600],
                      ),
                    CustomText(
                      text: "Email: ${service.business!.contactEmail}",
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey[600],
                    ),
                  ],
                ],
              ),
            ),
            _buildBusinessAvatar(),
          ],
        ),
      ],
    );
  }

  Widget _buildBusinessAvatar() {
    if (service.business?.logoUrl != null) {
      return CircleAvatar(
        radius: 25,
        backgroundColor: Colors.grey[300],
        child: ClipOval(
          child: Image.network(
            service.business!.logoUrl!,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.business, 
                         color: Colors.grey[600], size: 30);
            },
          ),
        ),
      );
    } else {
      return CircleAvatar(
        radius: 25,
        backgroundColor: Colors.grey[300],
        child: Icon(Icons.business, 
                   color: Colors.grey[600], size: 30),
      );
    }
  }
}