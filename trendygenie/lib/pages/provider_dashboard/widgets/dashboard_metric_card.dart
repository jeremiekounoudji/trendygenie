import 'package:flutter/material.dart';
import '../../../utils/globalVariable.dart';

class DashboardMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const DashboardMetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: mediumBorder,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              Icon(
                Icons.arrow_upward,
                color: firstColor,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 12),
          CustomText(
            text: value,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: blackColor,
          ),
          const SizedBox(height: 6),
          CustomText(
            text: title,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600]!,
          ),
        ],
      ),
    );
  }
} 