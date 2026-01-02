import 'package:flutter/material.dart';
import '../../../../../../utils/globalVariable.dart';

class StatusOptionItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final VoidCallback hidePopup;
  final String selectedValue;
  final Function(String) onValueChanged;

  const StatusOptionItem({
    super.key,
    required this.label,
    required this.value,
    this.color,
    required this.hidePopup,
    required this.selectedValue,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedValue == value;
    
    return GestureDetector(
      onTap: () {
        onValueChanged(value);
        hidePopup();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? (color ?? firstColor).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            isSelected
                ? Icon(Icons.radio_button_checked, size: 18, color: color ?? firstColor)
                : const Icon(Icons.radio_button_unchecked, size: 18, color: Colors.grey),
            const SizedBox(width: 8),
            CustomText(
              text: label,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? (color ?? firstColor) : blackColor,
            ),
          ],
        ),
      ),
    );
  }
} 