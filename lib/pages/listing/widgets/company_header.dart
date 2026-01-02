import 'package:flutter/material.dart';
import '../../../utils/globalVariable.dart';

class CompanyHeader extends StatelessWidget {
  final String companyName;
  final String categoryName;
  final VoidCallback onBack;

  const CompanyHeader({
    super.key,
    required this.companyName,
    required this.categoryName,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: whiteColor,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: blackColor),
              onPressed: onBack,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: companyName,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: blackColor,
                ),
                CustomText(
                  text: categoryName,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: blackColor.withOpacity(0.6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}