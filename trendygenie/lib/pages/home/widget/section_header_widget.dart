import 'package:flutter/material.dart';
import 'package:trendygenie/utils/globalVariable.dart';

class SectionHeaderWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAllPressed;

  const SectionHeaderWidget({
    super.key,
    required this.title,
    this.onViewAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: title,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: blackColor,
        ),
        if (onViewAllPressed != null)
          TextButton(
            onPressed: onViewAllPressed,
            child: CustomText(
              text: 'View all',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: firstColor,
            ),
          ),
      ],
    );
  }
} 