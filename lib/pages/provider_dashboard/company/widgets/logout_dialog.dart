import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/auth_controller.dart';
import '../../../../utils/globalVariable.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  static void show() {
    Get.dialog(
      const LogoutDialog(),
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: whiteColor, 
          shape: BoxShape.rectangle, 
          borderRadius: BorderRadius.circular(16), 
          boxShadow: const [
            BoxShadow(
              color: Colors.black26, 
              blurRadius: 10.0, 
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.logout_rounded, color: redColor, size: 48),
            const SizedBox(height: 16),
            Text(
              'Confirm Logout', 
              style: TextStyle(
                color: blackColor, 
                fontSize: 20, 
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Are you sure you want to logout from your account?', 
              textAlign: TextAlign.center, 
              style: TextStyle(color: greyColor, fontSize: 16),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), 
                      side: BorderSide(color: greyColor.withOpacity(0.5)),
                    ),
                  ),
                  child: Text(
                    'Cancel', 
                    style: TextStyle(
                      color: greyColor, 
                      fontSize: 16, 
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => authController.logout(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: redColor, 
                    foregroundColor: whiteColor, 
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    'Logout', 
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
