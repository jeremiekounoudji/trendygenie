import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../controllers/business_controller.dart';
import '../../../../../utils/globalVariable.dart';
import '../../../../../widgets/general_widgets/common_button.dart';
import '../../../../../widgets/general_widgets/textfield.dart';

class LocationSection extends StatelessWidget {
  final TextEditingController latitudeController;
  final TextEditingController longitudeController;
  final BusinessController businessController;
  final Function() onGetLocation;

  const LocationSection({
    super.key,
    required this.latitudeController,
    required this.longitudeController,
    required this.businessController,
    required this.onGetLocation,
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
            color: Colors.black.withOpacity(0.05),
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
              Icon(Icons.location_on, color: firstColor),
              const SizedBox(width: 10),
              CustomText(
                text: "Business Location",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: latitudeController,
                  hintText: "Latitude",
                  borderColor: greyColor,
                  prefixIcon: Icon(Icons.location_searching, color: firstColor),
                  inputType: TextInputType.number,
                  radius: 8,
                  maxLines: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Latitude is required";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomTextField(
                  controller: longitudeController,
                  hintText: "Longitude",
                  borderColor: greyColor,
                  prefixIcon: Icon(Icons.location_searching, color: firstColor),
                  inputType: TextInputType.number,
                  radius: 8,
                  maxLines: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Longitude is required";
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          
       CommonButton(
                text: "Get Current Location",
                textColor: whiteColor,
                bgColor: firstColor,
                width: double.infinity,
                verticalPadding: 15,
                isLoading: businessController.isLoadingLocation,
                radius: 10,
                onTap: onGetLocation,
              ),
          
          if (businessController.locationError.value.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: CustomText(
                text: businessController.locationError.value,
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: redColor,
              ),
            ),
        ],
      ),
    );
  }
} 