import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';
import '../../../../../utils/globalVariable.dart';
import '../../../../../widgets/general_widgets/textfield.dart';

class ServiceAccommodationFields extends StatefulWidget {
  final TextEditingController bedroomCountController;
  final TextEditingController bathroomCountController;
  final TextEditingController propertyTypeController;
  final TextEditingController characteristicController;
  final List<String> propertyTypes;
  final List<String> selectedCharacteristics;
  final bool hasKitchen;
  final Function(bool) onHasKitchenChanged;
  final Function(String) onCharacteristicAdded;
  final Function(String) onCharacteristicRemoved;

  const ServiceAccommodationFields({
    super.key,
    required this.bedroomCountController,
    required this.bathroomCountController,
    required this.propertyTypeController,
    required this.characteristicController,
    required this.propertyTypes,
    required this.selectedCharacteristics,
    required this.hasKitchen,
    required this.onHasKitchenChanged,
    required this.onCharacteristicAdded,
    required this.onCharacteristicRemoved,
  });

  @override
  State<ServiceAccommodationFields> createState() => _ServiceAccommodationFieldsState();
}

class _ServiceAccommodationFieldsState extends State<ServiceAccommodationFields> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
              Icon(Icons.hotel, color: firstColor),
              const SizedBox(width: 10),
              CustomText(
                text: "Accommodation Details",
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Bedrooms",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: blackColor,
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hintText: "Number of bedrooms",
                      controller: widget.bedroomCountController,
                      inputType: TextInputType.number,
                      borderColor: blackColor.withOpacity(0.1),
                      prefixIcon: Icon(Icons.bed, color: firstColor),
                      radius: 10,
                      validator: (value) {
                        if (value!.isEmpty) return "Required";
                        if (int.tryParse(value) == null) {
                          return "Enter a number";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Bathrooms",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: blackColor,
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hintText: "Number of bathrooms",
                      controller: widget.bathroomCountController,
                      borderColor: blackColor.withOpacity(0.1),
                      inputType: TextInputType.number,
                      radius: 10,
                      prefixIcon: Icon(Icons.bathtub, color: firstColor),
                      validator: (value) {
                        if (value!.isEmpty) return "Required";
                        if (int.tryParse(value) == null) {
                          return "Enter a number";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          CustomText(
            text: "Property Type",
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: blackColor,
          ),
          const SizedBox(height: 8),
          CustomPopup(
            barrierColor: Colors.black12,
            backgroundColor: whiteColor,
            arrowColor: whiteColor,
            showArrow: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            contentDecoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                ),
              ],
            ),
            content: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.propertyTypes
                      .map(
                        (type) => InkWell(
                          onTap: () {
                            setState(() {
                              widget.propertyTypeController.text = type;
                            });
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey.withOpacity(0.1),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  type,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: widget.propertyTypeController.text == type
                                        ? firstColor
                                        : blackColor,
                                  ),
                                ),
                                if (widget.propertyTypeController.text == type)
                                  Icon(Icons.check,
                                      color: firstColor, size: 20),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.propertyTypeController.text.isNotEmpty
                        ? widget.propertyTypeController.text
                        : "Select Property Type",
                    style: TextStyle(
                      fontSize: 16,
                      color: widget.propertyTypeController.text.isNotEmpty
                          ? blackColor
                          : Colors.grey,
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, color: firstColor),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          CheckboxListTile(
            title: CustomText(
              text: "Has Kitchen",
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: blackColor,
            ),
            value: widget.hasKitchen,
            activeColor: firstColor,
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (value) {
              widget.onHasKitchenChanged(value!);
            },
          ),
          const SizedBox(height: 15),
          CustomText(
            text: "Characteristics",
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: blackColor,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  hintText: "Add a characteristic (e.g., Pool, Garden, Parking)",
                  controller: widget.characteristicController,
                  radius: 10,
                  borderColor: blackColor.withOpacity(0.1),
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () {
                  if (widget.characteristicController.text.isNotEmpty) {
                    widget.onCharacteristicAdded(widget.characteristicController.text);
                    widget.characteristicController.clear();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: firstColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.add, color: whiteColor),
                ),
              ),
            ],
          ),
          if (widget.selectedCharacteristics.isNotEmpty) ...[
            const SizedBox(height: 15),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.selectedCharacteristics
                  .map((characteristic) => Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          color: firstColor,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: firstColor.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Chip(
                          label: CustomText(
                            text: characteristic,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: whiteColor,
                          ),
                          backgroundColor: firstColor,
                          deleteIconColor: whiteColor,
                          elevation: 0,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          onDeleted: () {
                            widget.onCharacteristicRemoved(characteristic);
                          },
                        ),
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
} 