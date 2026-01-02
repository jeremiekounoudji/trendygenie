import 'package:flutter/material.dart';
import '../../../../../../utils/globalVariable.dart';

class ServiceTypeSelector extends StatefulWidget {
  final String serviceType;
  final Function(String) onServiceTypeChanged;

  const ServiceTypeSelector({
    super.key,
    required this.serviceType,
    required this.onServiceTypeChanged,
  });

  @override
  State<ServiceTypeSelector> createState() => _ServiceTypeSelectorState();
}

class _ServiceTypeSelectorState extends State<ServiceTypeSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: firstColor.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.category, color: firstColor),
              const SizedBox(width: 10),
              CustomText(
                text: "Service Type",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
            ],
          ),
          const SizedBox(height: 15),
          Column(
            children: [
              RadioListTile<String>(
                title: CustomText(
                  text: 'General',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: blackColor,
                ),
                value: 'General',
                groupValue: widget.serviceType,
                activeColor: firstColor,
                onChanged: (value) {
                  widget.onServiceTypeChanged(value!);
                },
              ),
              RadioListTile<String>(
                title: CustomText(
                  text: 'Accommodation',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: blackColor,
                ),
                value: 'Accommodation',
                groupValue: widget.serviceType,
                activeColor: firstColor,
                onChanged: (value) {
                  widget.onServiceTypeChanged(value!);
                },
              ),
              RadioListTile<String>(
                title: CustomText(
                  text: 'Food',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: blackColor,
                ),
                value: 'Food',
                groupValue: widget.serviceType,
                activeColor: firstColor,
                onChanged: (value) {
                  widget.onServiceTypeChanged(value!);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
} 