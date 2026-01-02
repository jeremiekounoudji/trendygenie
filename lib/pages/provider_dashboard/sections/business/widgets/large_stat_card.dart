import 'package:flutter/material.dart';
import '../../../../../utils/globalVariable.dart';

class LargeStatCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;
  final IconData icon;

  const LargeStatCard({
    super.key,
    required this.title,
    required this.count,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                text: '$count',
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              const SizedBox(height: 4),
              CustomText(
                text: title,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600]!,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
