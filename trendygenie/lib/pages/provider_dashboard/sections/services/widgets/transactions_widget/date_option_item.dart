import 'package:flutter/material.dart';
import '../../../../../../utils/globalVariable.dart';

class DateOptionItem extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback hidePopup;
  final String selectedValue;
  final Function(String) onValueChanged;
  final VoidCallback onLoadInitialData;

  const DateOptionItem({
    super.key,
    required this.label,
    required this.value,
    required this.hidePopup,
    required this.selectedValue,
    required this.onValueChanged,
    required this.onLoadInitialData,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedValue == value;
    
    return GestureDetector(
      onTap: () {
        onValueChanged(value);
        hidePopup();
        onLoadInitialData();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? firstColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            isSelected
                ? Icon(Icons.radio_button_checked, size: 18, color: firstColor)
                : const Icon(Icons.radio_button_unchecked, size: 18, color: Colors.grey),
            const SizedBox(width: 8),
            CustomText(
              text: label,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? firstColor : blackColor,
            ),
          ],
        ),
      ),
    );
  }
}
