import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:trendygenie/pages/authentication/register/register_step_two.dart';
import 'package:trendygenie/utils/globalVariable.dart';
import 'package:trendygenie/widgets/general_widgets/common_button.dart';
import 'package:otp_timer_button/otp_timer_button.dart';

class PinPage extends StatefulWidget {
  const PinPage({Key? key}) : super(key: key);

  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  final TextEditingController pinController = TextEditingController();
  final errorController = StreamController<ErrorAnimationType>();
  OtpTimerButtonController controller = OtpTimerButtonController();
  String currentText = "";

  @override
  void dispose() {
    errorController.close();
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomText(
          text: 'Verification Code',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: whiteColor,
        ),
        backgroundColor: firstColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              CustomText(
                text: 'Verification',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
              const SizedBox(height: 12),
              CustomText(
                text: 'Enter the verification code we sent to your email/phone',
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.grey[600],
                align: TextAlign.center,
              ),
              const SizedBox(height: 40),
              PinCodeTextField(
                length: 6,
                obscureText: false,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(8),
                  fieldHeight: 50,
                  fieldWidth: 45,
                  activeFillColor: Colors.white,
                  activeColor: firstColor,
                  selectedColor: firstColor,
                  inactiveColor: Colors.grey[300],
                  inactiveFillColor: Colors.white,
                  selectedFillColor: Colors.white,
                ),
                animationDuration: const Duration(milliseconds: 300),
                backgroundColor: Colors.transparent,
                enableActiveFill: true,
                errorAnimationController: errorController,
                controller: pinController,
                onCompleted: (v) {
                  // Handle completion
                },
                onChanged: (value) {
                  setState(() {
                    currentText = value;
                  });
                },
                beforeTextPaste: (text) => true,
                appContext: context,
              ),
              const SizedBox(height: 32),
              CommonButton(
                textColor: whiteColor,
                bgColor: firstColor,
                text: 'Verify',
                verticalPadding: 15,
                onTap: () {
                  // Handle verification
                    Get.to(() =>  RegisterStepTwo(), transition: Transition.fadeIn);

                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomText(
                    text: "Didn't receive the code? ",
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey[600],
                  ),
                  OtpTimerButton(
                    controller: controller,
                    backgroundColor: firstColor,
                    radius: 10,
                    onPressed: () {},
                    text: Text('Resend OTP',style: TextStyle(color: whiteColor),),
                    duration: 2,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
