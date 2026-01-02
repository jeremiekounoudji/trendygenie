import 'package:flutter/material.dart';
import '../../../../../utils/globalVariable.dart';

class OptionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const OptionItem({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: CustomText(
        text: label,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: color,
      ),
      onTap: onTap,
    );
  }
}
