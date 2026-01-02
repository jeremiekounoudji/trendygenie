import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/business_model.dart';
import '../../../utils/globalVariable.dart';
import '../../provider_dashboard/sections/business/edit_business_page.dart';

class EditBusinessBottomBar extends StatelessWidget {
  final BusinessModel business;

  const EditBusinessBottomBar({
    super.key,
    required this.business,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => Get.to(() => EditBusinessPage(business: business)),
            icon: Icon(Icons.edit, color: whiteColor, size: 20),
            label: CustomText(
              text: "Edit Business",
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: whiteColor,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: firstColor,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
            ),
          ),
        ),
      ),
    );
  }
}