import 'package:flutter/material.dart';
import '../../../../../models/service_item.dart';
import '../../../../../utils/globalVariable.dart';
import 'service_section_card.dart';

class ServiceFeaturesSection extends StatelessWidget {
  final ServiceItem service;

  const ServiceFeaturesSection({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    if (service.caracteristics == null || service.caracteristics!.isEmpty) {
      return const SizedBox.shrink();
    }

    return ServiceSectionCard(
      title: 'Features',
      customColor: Colors.blue,
      children: [
        SizedBox(
          height: 35,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: service.caracteristics!.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              return _buildFeatureItem(service.caracteristics![index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: CustomText(
        text: text,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: blackColor.withValues(alpha: 0.7),
      ),
    );
  }
}