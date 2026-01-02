import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/company_controller.dart';
import '../../../../models/company_model.dart';
import '../../../../utils/globalVariable.dart';
import '../edit_company_page.dart';

class CompanyHeader extends StatelessWidget {
  final CompanyModel company;
  final CompanyController controller;

  const CompanyHeader({
    super.key,
    required this.company,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => controller.pickLogo(),
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: greyColor.withOpacity(0.2),
                  backgroundImage: company.companyLogo != null 
                      ? NetworkImage(company.companyLogo!) 
                      : null,
                  child: company.companyLogo == null 
                      ? Icon(Icons.business, size: 40, color: firstColor) 
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 15, 
                    backgroundColor: firstColor, 
                    child: Icon(Icons.camera_alt, size: 16, color: whiteColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            company.name, 
            style: TextStyle(
              color: blackColor, 
              fontSize: 24, 
              fontWeight: FontWeight.bold,
            ), 
            textAlign: TextAlign.center,
          ),
          if (company.email != null) ...[
            const SizedBox(height: 4),
            Text(
              company.email!, 
              style: TextStyle(
                color: greyColor, 
                fontSize: 16, 
                fontWeight: FontWeight.normal,
              ), 
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => Get.to(() => EditCompanyPage(company: company)),
            icon: const Icon(Icons.edit),
            label: const Text('Edit Profile'),
            style: ElevatedButton.styleFrom(
              backgroundColor: firstColor, 
              foregroundColor: whiteColor, 
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
