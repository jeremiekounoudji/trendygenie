import 'package:flutter/material.dart';
import '../../../../../utils/globalVariable.dart';

class ContactItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ContactItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: firstColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: firstColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: label,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600]!,
                ),
                CustomText(
                  text: value,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: blackColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
