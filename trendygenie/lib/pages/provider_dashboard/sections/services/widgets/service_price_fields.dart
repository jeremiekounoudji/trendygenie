import 'package:flutter/material.dart';
import '../../../../../utils/globalVariable.dart';
import '../../../../../widgets/general_widgets/textfield.dart';

class ServicePriceFields extends StatelessWidget {
  final TextEditingController normalPriceController;
  final TextEditingController promotionalPriceController;

  const ServicePriceFields({
    super.key,
    required this.normalPriceController,
    required this.promotionalPriceController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "Normal Price",
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: blackColor,
        ),
        const SizedBox(height: 8),
        CustomTextField(
          hintText: "Enter normal price",
          controller: normalPriceController,
          inputType: TextInputType.number,
          radius: 10,
          maxLines: 1,
          prefixIcon: Icon(Icons.attach_money, color: firstColor),
          borderColor: blackColor.withValues(alpha: 0.1),
          validator: (value) {
            if (value!.isEmpty) return "Normal price is required";
            if (double.tryParse(value) == null) return "Enter a valid price";
            return null;
          },
        ),
        const SizedBox(height: 15),
        CustomText(
          text: "Promotional Price",
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: blackColor,
        ),
        const SizedBox(height: 4),
        CustomText(
          text: "This is the price displayed to customers",
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Colors.grey[600]!,
        ),
        const SizedBox(height: 8),
        CustomTextField(
          hintText: "Enter promotional price",
          controller: promotionalPriceController,
          inputType: TextInputType.number,
          radius: 10,
          maxLines: 1,
          borderColor: blackColor.withValues(alpha: 0.1),
          prefixIcon: Icon(Icons.local_offer, color: firstColor),
          validator: (value) {
            if (value!.isEmpty) return "Promotional price is required";
            if (double.tryParse(value) == null) return "Enter a valid price";
            return null;
          },
        ),
      ],
    );
  }
} 