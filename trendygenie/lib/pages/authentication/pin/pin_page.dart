import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:trendygenie/controllers/auth_controller.dart';
import 'package:trendygenie/pages/authentication/register/register_step_three.dart';
import 'package:trendygenie/utils/globalVariable.dart';
import 'package:trendygenie/widgets/general_widgets/common_button.dart';

class PinPage extends StatefulWidget {
  const PinPage({super.key});

  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  final TextEditingController pinController = TextEditingController();
  final errorController = StreamController<ErrorAnimationType>();
  final AuthController authController = Get.find<AuthController>();
  
  String currentText = "";
  int _resendCountdown = 0;
  Timer? _resendTimer;
  bool _canResend = true;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    setState(() {
      _canResend = false;
      _resendCountdown = 60;
    });
    
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      
      if (_resendCountdown > 0) {
        setState(() {
          _resendCountdown--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    errorController.close();
    pinController.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    if (currentText.length != 8) {
      errorController.add(ErrorAnimationType.shake);
      Get.snackbar(
        'Error',
        'Please enter the complete 8-digit code',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final success = await authController.verifyOtp(currentText);
    
    if (success) {
      // Clear the controller before navigation to prevent disposal issues
      pinController.clear();
      
      Get.snackbar(
        'Success',
        'Email verified successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      // Use a slight delay to ensure snackbar shows and controller is cleared
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.offAll(() => RegisterStepThree(), transition: Transition.rightToLeft);
      });
    } else {
      errorController.add(ErrorAnimationType.shake);
      Get.snackbar(
        'Error',
        authController.authError.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _resendOtp() async {
    if (!_canResend) return;
    
    final success = await authController.resendOtp();
    
    if (success) {
      _startResendTimer();
      Get.snackbar(
        'Success',
        'Verification code sent to your email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Error',
        authController.authError.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
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
                text: 'Enter the verification code we sent to',
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.grey[600],
                align: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Obx(() => CustomText(
                text: authController.otpEmail.value,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: firstColor,
                align: TextAlign.center,
              )),
              const SizedBox(height: 40),
              PinCodeTextField(
                length: 8,
                obscureText: false,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(8),
                  fieldHeight: 50,
                  fieldWidth: 40,
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
                keyboardType: TextInputType.number,
                onCompleted: (v) {
                  _verifyOtp();
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
                isLoading: authController.isLoading,
                onTap: _verifyOtp,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: "Didn't receive the code? ",
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey[600],
                  ),
                  GestureDetector(
                    onTap: _canResend ? _resendOtp : null,
                    child: Obx(() {
                      if (authController.isLoading.value) {
                        return const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        );
                      }
                      return CustomText(
                        text: _canResend 
                          ? 'Resend Code' 
                          : 'Resend in ${_resendCountdown}s',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _canResend ? firstColor : Colors.grey,
                      );
                    }),
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
