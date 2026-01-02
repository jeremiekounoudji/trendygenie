import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trendygenie/utils/globalVariable.dart';

class LogoutConfirmationModal extends StatelessWidget {
  const LogoutConfirmationModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                FontAwesomeIcons.rightFromBracket,
                color: Colors.red,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            
            // Title
            CustomText(
              text: 'Logout',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: blackColor,
              align: TextAlign.center,
            ),
            const SizedBox(height: 12),
            
            // Message
            CustomText(
              text: 'Are you sure you want to logout from your account?',
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.grey[600]!,
              align: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // Buttons
            Row(
              children: [
                // Cancel button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: CustomText(
                      text: 'Cancel',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600]!,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Logout button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: CustomText(
                      text: 'Logout',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: whiteColor,
                    ),
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