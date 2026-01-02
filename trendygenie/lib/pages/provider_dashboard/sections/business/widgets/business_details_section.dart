import 'package:flutter/material.dart';
import '../../../../../utils/globalVariable.dart';
import '../../../../../widgets/general_widgets/textfield.dart';

class BusinessDetailsSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController addressController;

  const BusinessDetailsSection({
    super.key,
    required this.nameController,
    required this.descriptionController,
    required this.addressController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
              Icon(Icons.business, color: firstColor),
              const SizedBox(width: 10),
              CustomText(
                text: "Business Details",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: blackColor.withValues(alpha: 0.6),
              ),
            ],
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: nameController,
            hintText: "Business Name",
            borderColor: greyColor,
            prefixIcon: Icon(Icons.store, color: firstColor),
            radius: 8,
            maxLines: 1,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Business name is required";
              }
              return null;
            },
          ),
          const SizedBox(height: 15),
          CustomTextField(
            controller: descriptionController,
            hintText: "Business Description",
            prefixIcon: Icon(Icons.description, color: firstColor),
            maxLines: 3,
            borderColor: greyColor,
            radius: 8,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Description is required";
              }
              return null;
            },
          ),
          const SizedBox(height: 15),
          CustomTextField(
            controller: addressController,
            hintText: "Business Address",
            borderColor: greyColor,
            prefixIcon: Icon(Icons.location_on, color: firstColor),
            radius: 8,
            maxLines: 1,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Address is required";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
