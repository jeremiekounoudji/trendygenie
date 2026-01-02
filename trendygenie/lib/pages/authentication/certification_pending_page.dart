import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trendygenie/utils/globalVariable.dart';
import 'package:trendygenie/widgets/general_widgets/common_button.dart';

class CertificationPendingPage extends StatelessWidget {
  const CertificationPendingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  // Logo/Brand at top (optional, based on your image)
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 60, 
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: firstColor, // App's green color
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 80),
                  
                  // Card with profile and checkmark
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        // Profile icon
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[300],
                          ),
                          child: Icon(
                            Icons.person,
                            color: Colors.grey[600],
                            size: 22,
                          ),
                        ),
                        
                        const SizedBox(width: 12),
                        
                        // Grey line representing text
                        Container(
                          width: 80,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        
                        const SizedBox(width: 12),
                        
                        // Checkmark in circle
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: firstColor, // App's green color
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Success text
                  const Text(
                    "Certification Pending",
                    style: TextStyle(
                      fontSize: 24,
                        fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Description text
                  Text(
                    "Your account is under review.\nWe'll notify you once verification is complete.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Button
                  ElevatedButton(
                    onPressed: () => Get.offAllNamed('/login'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: firstColor, // App's green color
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Back to Login",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      ),
                      ),
                    ],
                  ),
            ),
          ),
        ),
      ),
    );
  }
} 