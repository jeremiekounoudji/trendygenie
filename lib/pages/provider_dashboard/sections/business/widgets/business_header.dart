import 'package:flutter/material.dart';
import '../../../../../utils/globalVariable.dart';

class BusinessHeader extends StatelessWidget {
  const BusinessHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Overview',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: blackColor,
        ),
        const SizedBox(height: 8),
        CustomText(
          text: 'Monitor and manage your business portfolio',
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Colors.grey[600]!,
        ),
      ],
    );
  }
}
