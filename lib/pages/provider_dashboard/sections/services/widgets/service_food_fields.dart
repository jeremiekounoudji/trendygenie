import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';
import '../../../../../../utils/globalVariable.dart';
import '../../../../../../widgets/general_widgets/textfield.dart';

class ServiceFoodFields extends StatefulWidget {
  final TextEditingController cuisineController;
  final TextEditingController foodCategoryController;
  final TextEditingController characteristicController;
  final List<String> foodCategories;
  final List<String> selectedCharacteristics;
  final bool isDeliveryAvailable;
  final Function(bool) onDeliveryAvailableChanged;
  final Function(String) onCharacteristicAdded;
  final Function(String) onCharacteristicRemoved;

  const ServiceFoodFields({
    super.key,
    required this.cuisineController,
    required this.foodCategoryController,
    required this.characteristicController,
    required this.foodCategories,
    required this.selectedCharacteristics,
    required this.isDeliveryAvailable,
    required this.onDeliveryAvailableChanged,
    required this.onCharacteristicAdded,
    required this.onCharacteristicRemoved,
  });

  @override
  State<ServiceFoodFields> createState() => _ServiceFoodFieldsState();
}

class _ServiceFoodFieldsState extends State<ServiceFoodFields> {
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
              Icon(Icons.restaurant, color: firstColor),
              const SizedBox(width: 10),
              CustomText(
                text: "Food Service Details",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
            ],
          ),
          const SizedBox(height: 20),
          CustomText(
            text: "Cuisine",
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: blackColor,
          ),
          const SizedBox(height: 8),
          CustomTextField(
            hintText: "e.g. Italian, Chinese, Mexican",
            controller: widget.cuisineController,
            radius: 10,
            prefixIcon: Icon(Icons.restaurant_menu, color: firstColor),
            borderColor: blackColor.withOpacity(0.1),
            validator: (value) {
              if (value!.isEmpty) return "Cuisine is required";
              return null;
            },
          ),
          const SizedBox(height: 15),
          CustomText(
            text: "Food Category",
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
                  children: widget.foodCategories
                      .map(
                        (category) => InkWell(
                          onTap: () {
                            setState(() {
                              widget.foodCategoryController.text = category;
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
                                  category,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: widget.foodCategoryController.text == category
                                        ? firstColor
                                        : blackColor,
                                  ),
                                ),
                                if (widget.foodCategoryController.text == category)
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
                    widget.foodCategoryController.text.isNotEmpty
                        ? widget.foodCategoryController.text
                        : "Select Food Category",
                    style: TextStyle(
                      fontSize: 16,
                      color: widget.foodCategoryController.text.isNotEmpty
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
              text: "Delivery Available",
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: blackColor,
            ),
            value: widget.isDeliveryAvailable,
            activeColor: firstColor,
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (value) {
              widget.onDeliveryAvailableChanged(value!);
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
                  hintText: "Add a characteristic",
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
                          onDeleted: () => widget.onCharacteristicRemoved(characteristic),
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