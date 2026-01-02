import 'package:flutter/material.dart';
import 'package:trendygenie/models/service_item.dart';
import 'package:trendygenie/utils/globalVariable.dart';
import 'package:trendygenie/utils/currency_helper.dart';

class ServiceGridCard extends StatelessWidget {
  final ServiceItem service;

  const ServiceGridCard({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.network(
              service.images.isNotEmpty 
                  ? service.images.first 
                  : 'https://via.placeholder.com/300x200?text=No+Image',
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 16,
                      backgroundImage: AssetImage('assets/images/profile.jpg'),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: 'Artist Name',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: blackColor,
                        ),
                        CustomText(
                          text: 'Beauty Artist',
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[600]!,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: '${CurrencyHelper.formatPrice(service.promotionalPrice, service.currency)}/hr',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: firstColor,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        CustomText(
                          text: service.rating.toString(),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: blackColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
