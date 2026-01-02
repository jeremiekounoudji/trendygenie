import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/globalVariable.dart';
import '../../../../../widgets/general_widgets/textfield.dart';

class ContactInfoSection extends StatelessWidget {
  final TextEditingController emailController;
  final List<TextEditingController> phoneControllers;
  final VoidCallback onAddPhone;
  final Function(int) onRemovePhone;

  const ContactInfoSection({
    super.key,
    required this.emailController,
    required this.phoneControllers,
    required this.onAddPhone,
    required this.onRemovePhone,
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
              Icon(Icons.contact_phone, color: firstColor),
              const SizedBox(width: 10),
              CustomText(
                text: "Contact Information",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
            ],
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: emailController,
            hintText: "Contact Email",
            borderColor: greyColor,
            prefixIcon: Icon(Icons.email, color: firstColor),
            inputType: TextInputType.emailAddress,
            radius: 8,
            maxLines: 1,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Email is required";
              } else if (!GetUtils.isEmail(value)) {
                return "Please enter a valid email";
              }
              return null;
            },
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: "Phone Numbers",
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: blackColor,
              ),
              IconButton(
                icon: Icon(Icons.add_circle, color: firstColor),
                onPressed: onAddPhone,
              ),
            ],
          ),
          ...List.generate(
            phoneControllers.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      borderColor: greyColor,
                      controller: phoneControllers[index],
                      hintText: "Phone Number ${index + 1}",
                      prefixIcon: Icon(Icons.phone, color: firstColor),
                      inputType: TextInputType.phone,
                      radius: 8,
                      maxLines: 1,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Phone number is required";
                        }
                        return null;
                      },
                    ),
                  ),
                  if (phoneControllers.length > 1)
                    IconButton(
                      icon: Icon(Icons.remove_circle, color: redColor),
                      onPressed: () => onRemovePhone(index),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
