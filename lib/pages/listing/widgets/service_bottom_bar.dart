import 'package:flutter/material.dart';
import '../../../models/service_item.dart';
import '../../../utils/globalVariable.dart';
import '../../../utils/currency_helper.dart';

class ServiceBottomBar extends StatelessWidget {
  final ServiceItem service;

  const ServiceBottomBar({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: firstColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomText(
                  text: CurrencyHelper.formatPrice(service.promotionalPrice, service.currency),
                  fontSize: 20,
                  align: TextAlign.center,
                  fontWeight: FontWeight.bold,
                  color: whiteColor,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: whiteColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: largeBorder,
              ),
            ),
            child: CustomText(
              text: "Book now",
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: firstColor,
            ),
          ),
        ],
      ),
    );
  }
}