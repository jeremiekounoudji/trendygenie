import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:trendygenie/controllers/auth_controller.dart';
import 'package:trendygenie/controllers/user_controller.dart';
import 'package:trendygenie/pages/listing/listing_page.dart';
import 'package:trendygenie/utils/globalVariable.dart';
import 'package:trendygenie/widgets/general_widgets/logout_confirmation_modal.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final AuthController authController = Get.find<AuthController>();
  final UserController userController = Get.find<UserController>();

  Future<void> _handleLogout() async {
    // Show confirmation dialog
    final bool? shouldLogout = await showDialog<bool>(
      context: Get.context!,
      builder: (context) => const LogoutConfirmationModal(),
    );

    if (shouldLogout == true) {
      await authController.logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header with gradient background
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  firstColor,
                  firstColor.withValues(alpha: 0.8),
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Profile Avatar
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: whiteColor.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: whiteColor.withValues(alpha: 0.3),
                          width: 3,
                        ),
                      ),
                      child: Icon(
                        FontAwesomeIcons.user,
                        size: 50,
                        color: whiteColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // User Name
                    Obx(() => CustomText(
                      text: userController.currentUser.value?.fullName ?? 'User',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: whiteColor,
                      align: TextAlign.center,
                    )),
                    const SizedBox(height: 8),
                    
                    // User Email
                    Obx(() => CustomText(
                      text: userController.currentUser.value?.email ?? 'user@example.com',
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: whiteColor.withValues(alpha: 0.9),
                      align: TextAlign.center,
                    )),
                  ],
                ),
              ),
            ),
          ),
          
          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildMenuItem(
                  icon: FontAwesomeIcons.idCard,
                  title: 'KYC Verification',
                  subtitle: 'Verify your identity',
                  onTap: () {
                    // Navigate to KYC verification
                  },
                ),
                _buildMenuItem(
                  icon: FontAwesomeIcons.userPen,
                  title: 'Edit Profile',
                  subtitle: 'Update your information',
                  onTap: () {
                    // Navigate to edit profile
                  },
                ),
                _buildMenuItem(
                  icon: FontAwesomeIcons.bell,
                  title: 'Notifications',
                  subtitle: 'Manage notifications',
                  onTap: () {
                    // Navigate to notifications settings
                  },
                ),
                _buildMenuItem(
                  icon: FontAwesomeIcons.lock,
                  title: 'Privacy',
                  subtitle: 'Privacy settings',
                  onTap: () {
                    // Navigate to privacy settings
                  },
                ),
                _buildMenuItem(
                  icon: FontAwesomeIcons.circleQuestion,
                  title: 'Help & Support',
                  subtitle: 'Need help?',
                  onTap: () {
                    // Navigate to help & support
                  },
                ),
                _buildMenuItem(
                  icon: FontAwesomeIcons.list,
                  title: 'View Listings',
                  subtitle: 'Browse all services',
                  onTap: () {
                    Get.to(() => ListingPage());
                  },
                ),
                const SizedBox(height: 16),
                _buildMenuItem(
                  icon: FontAwesomeIcons.rightFromBracket,
                  title: 'Logout',
                  subtitle: 'Sign out of your account',
                  onTap: _handleLogout,
                  isDestructive: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isDestructive 
                        ? Colors.red.withValues(alpha: 0.1)
                        : firstColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: isDestructive ? Colors.red : firstColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: title,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDestructive ? Colors.red : blackColor,
                      ),
                      const SizedBox(height: 4),
                      CustomText(
                        text: subtitle,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey[600]!,
                      ),
                    ],
                  ),
                ),
                
                // Arrow icon
                Icon(
                  FontAwesomeIcons.chevronRight,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}