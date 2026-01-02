import 'package:flutter/material.dart';
import '../../../../../utils/globalVariable.dart';

class QuickHelpCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const QuickHelpCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color, color.withOpacity(0.8)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 35, color: whiteColor),
              const SizedBox(height: 15),
              CustomText(text: title, color: whiteColor, fontSize: 16.0, fontWeight: FontWeight.bold),
              const SizedBox(height: 5),
              CustomText(text: subtitle, color: whiteColor.withOpacity(0.9), fontSize: 12.0, fontWeight: FontWeight.normal),
            ],
          ),
        ),
      ),
    );
  }
}
