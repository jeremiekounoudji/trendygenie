import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trendygenie/utils/globalVariable.dart';
import 'package:trendygenie/widgets/general_widgets/common_button.dart';
import 'package:trendygenie/controllers/register_controller.dart';
import 'package:trendygenie/widgets/auth/auth_container.dart';
import 'package:geolocator/geolocator.dart';
import 'package:trendygenie/utils/utility.dart';
import 'register_step_three.dart';
import 'register_step_four.dart';
import 'package:trendygenie/controllers/company_controller.dart';

class RegisterStepTwo extends StatelessWidget {
  RegisterStepTwo({super.key});

  final RegisterController controller = Get.find<RegisterController>();
  final CompanyController companyController = Get.find<CompanyController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/location-bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                AuthContainer(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: 'Set Your Location',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: blackColor,
                      ),
                      const SizedBox(height: 8),
                      CustomText(
                        text: 'Allow TrendyGenie to get your location for better experience',
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey[600]!,
                        align: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: firstColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Obx(() => CustomText(
                          text: controller.location.value.isEmpty 
                              ? 'Location not set' 
                              : controller.location.value,
                          fontSize: 16,
                          align: TextAlign.center,
                          color: blackColor,
                          fontWeight: FontWeight.normal,
                        )),
                      ),
                      const SizedBox(height: 32),
                      CommonButton(
                        textColor: whiteColor,
                        bgColor: firstColor,
                        text: 'Get My Location',
                        isLoading: controller.isLoading,
                        onTap: () async {
                          bool serviceEnabled = 
                              await Geolocator.isLocationServiceEnabled();
                          if (!serviceEnabled) {
                            bool locationEnabled = 
                                await Geolocator.openLocationSettings();
                            if (!locationEnabled) {
                              Utility().showSnack(
                                'Location Services Disabled',
                                'Please enable location services and try again.',
                                3, true
                              );
                              return;
                            }
                          }

                          LocationPermission permission = 
                              await Geolocator.checkPermission();
                          if (permission == LocationPermission.denied) {
                            permission = await Geolocator.requestPermission();
                            if (permission == LocationPermission.denied) {
                              Get.snackbar('Permission Denied',
                                  'Location permissions are denied');
                              return;
                            }
                          }

                          if (permission == LocationPermission.deniedForever) {
                            Get.snackbar('Permission Denied',
                                'Location permissions are permanently denied');
                            return;
                          }

                          Position position = await Geolocator.getCurrentPosition();
                          controller.setLocation(
                              '${position.latitude}, ${position.longitude}');
                        },
                      ),
                      const SizedBox(height: 16),
                      CommonButton(
                        textColor: whiteColor,
                        bgColor: firstColor,
                        text: 'Next',
                        onTap: () async {
                          if (controller.validateStepTwo()) {
                            final locationParts = controller.location.value.split(',');
                            if (locationParts.length == 2) {
                              // final success = await companyController.updateCompanyLocation(
                              //   companyId: companyController.currentCompany.value!.id!,
                              //   latitude: double.parse(locationParts[0].trim()),
                              //   longitude: double.parse(locationParts[1].trim()),
                              //   address: controller.locationAddress.value,
                              // );
                                Get.to(() => const RegisterStepFour(), transition: Transition.rightToLeft);

                              
                              
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
