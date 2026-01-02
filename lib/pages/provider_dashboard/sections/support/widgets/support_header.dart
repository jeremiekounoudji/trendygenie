import 'package:flutter/material.dart';
import '../../../../../utils/globalVariable.dart';

class SupportHeader extends StatelessWidget {
  const SupportHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [firstColor, firstColor.withOpacity(0.7), firstColor.withOpacity(0.7)],
        ),
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
      child: Row(
        children: [
          Icon(Icons.support_agent, color: whiteColor, size: 40),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: 'Help & Support', color: whiteColor, fontSize: 28.0, fontWeight: FontWeight.bold),
              CustomText(text: 'How can we help you today?', color: whiteColor.withOpacity(0.9), fontSize: 16.0, fontWeight: FontWeight.normal),
            ],
          ),
        ],
      ),
    );
  }
}
