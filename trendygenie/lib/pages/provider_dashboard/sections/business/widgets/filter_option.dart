import 'package:flutter/material.dart';
import '../../../../../utils/globalVariable.dart';

class FilterOption extends StatelessWidget {
  final String label;
  final String status;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterOption({
    super.key,
    required this.label,
    required this.status,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? firstColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? firstColor : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 12),
            CustomText(
              text: label,
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: isSelected ? firstColor : Colors.grey[800],
            ),
          ],
        ),
      ),
    );
  }
}
