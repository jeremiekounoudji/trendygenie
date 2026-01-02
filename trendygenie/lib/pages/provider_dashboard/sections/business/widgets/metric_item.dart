import 'package:flutter/material.dart';
import '../../../../../utils/globalVariable.dart';

class MetricItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color iconColor;

  const MetricItem({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: value,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: blackColor,
            ),
            CustomText(
              text: label,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600]!,
            ),
          ],
        ),
      ],
    );
  }
}
