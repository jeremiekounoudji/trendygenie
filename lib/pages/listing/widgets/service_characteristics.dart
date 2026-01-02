import 'package:flutter/material.dart';
import '../../../models/service_item.dart';
import '../../../utils/globalVariable.dart';

class ServiceCharacteristics extends StatelessWidget {
  final ServiceItem service;

  const ServiceCharacteristics({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> allCharacteristics = _getAllCharacteristics();
    
    if (allCharacteristics.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "Characteristics & Amenities",
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: blackColor,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: allCharacteristics.map((c) => _tagCard(c)).toList(),
        ),
      ],
    );
  }

  List<String> _getAllCharacteristics() {
    final List<String> characteristics = [];
    
    // Add all items from caracteristics list
    if (service.caracteristics != null && service.caracteristics!.isNotEmpty) {
      characteristics.addAll(service.caracteristics!);
    }
    
    // Add accommodation details
    if (service.bedroomCount != null && service.bedroomCount! > 0) {
      final bedText = "${service.bedroomCount} Bedroom${service.bedroomCount! > 1 ? 's' : ''}";
      characteristics.add(bedText);
    }
    if (service.bathroomCount != null && service.bathroomCount! > 0) {
      final bathText = "${service.bathroomCount} Bathroom${service.bathroomCount! > 1 ? 's' : ''}";
      characteristics.add(bathText);
    }
    if (service.hasKitchen == true) {
      characteristics.add("Kitchen Available");
    }
    if (service.propertyType != null && service.propertyType!.isNotEmpty) {
      characteristics.add(service.propertyType!);
    }
    
    // Add food service details
    if (service.cuisine != null && service.cuisine!.isNotEmpty) {
      characteristics.add(service.cuisine!);
    }
    if (service.isDeliveryAvailable == true) {
      characteristics.add("Delivery Available");
    }
    if (service.foodCategory != null && service.foodCategory!.isNotEmpty) {
      characteristics.add(service.foodCategory!);
    }
    
    // Add category name if available
    if (service.category.name.isNotEmpty) {
      characteristics.add(service.category.name);
    }
    
    return characteristics;
  }

  Widget _tagCard(String label) {
    return Container(
      decoration: BoxDecoration(
        color: firstColor.withValues(alpha: 0.1),
        borderRadius: largeBorder,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: CustomText(
        text: label,
        fontSize: 13,
        fontWeight: FontWeight.normal,
        color: blackColor,
      ),
    );
  }
}