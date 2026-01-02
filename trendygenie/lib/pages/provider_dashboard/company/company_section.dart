import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/company_controller.dart';
import '../../../utils/globalVariable.dart';
import '../../../widgets/custom_shimmer.dart';
import '../../../models/company_model.dart';
import 'edit_company_page.dart';
import 'widgets/company_header.dart';
import 'widgets/setting_tile.dart';
import 'widgets/social_icon_button.dart';
import 'widgets/logout_dialog.dart';

class CompanySection extends StatelessWidget {
  const CompanySection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CompanyController>();
    return Scaffold(
      backgroundColor: whiteColor,
      body: Obx(() {
        if (controller.isLoading.value) return const Center(child: CustomShimmer(height: 200, width: double.infinity));
        if (controller.error.value.isNotEmpty) return _buildErrorState(controller.error.value);
        if (controller.company.value == null) return _buildEmptyState();
        return _buildCompanyProfile(controller);
      }),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: secondColor),
          const SizedBox(height: 8),
          Text(error, style: TextStyle(color: secondColor, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.business_outlined, size: 64, color: greyColor),
          const SizedBox(height: 16),
          Text('No company information available', style: TextStyle(color: greyColor, fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildCompanyProfile(CompanyController controller) {
    final company = controller.company.value!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CompanyHeader(company: company, controller: controller),
          const SizedBox(height: 24),
          _buildAccountSettings(company, controller),
          const SizedBox(height: 16),
          _buildBusinessSettings(company, controller),
          const SizedBox(height: 16),
          _buildSocialSection(company),
          const SizedBox(height: 24),
          _buildLogoutSection(),
        ],
      ),
    );
  }

  Widget _buildAccountSettings(CompanyModel company, CompanyController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Account Settings', style: TextStyle(color: blackColor, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        SettingTile(title: 'Personal Information', icon: Icons.person_outline, onTap: () => _showPersonalInfoSheet(company, controller)),
        SettingTile(title: 'Password & Security', icon: Icons.lock_outline, onTap: () => _showPasswordSheet()),
        SettingTile(title: 'Notification Preferences', icon: Icons.notifications_none, onTap: () => _showNotificationSheet()),
      ],
    );
  }

  Widget _buildBusinessSettings(CompanyModel company, CompanyController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Business Settings', style: TextStyle(color: blackColor, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        SettingTile(title: 'Company Details', icon: Icons.business_outlined, onTap: () => Get.to(() => EditCompanyPage(company: company))),
        SettingTile(title: 'Business Location', icon: Icons.location_on_outlined, onTap: () => _showLocationSheet(company, controller)),
      ],
    );
  }

  Widget _buildSocialSection(CompanyModel company) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Friends & Social', style: TextStyle(color: blackColor, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Row(
          children: [
            SocialIconButton(icon: Icons.facebook, color: const Color(0xFF1877F2), url: company.website, label: 'Facebook'),
            const SizedBox(width: 16),
            SocialIconButton(icon: Icons.camera_alt, color: const Color(0xFFE4405F), url: company.website, label: 'Instagram'),
            const SizedBox(width: 16),
            SocialIconButton(icon: Icons.music_note, color: blackColor, url: company.website, label: 'TikTok'),
          ],
        ),
      ],
    );
  }

  Widget _buildLogoutSection() {
    return Column(
      children: [
        const Divider(height: 1),
        const SizedBox(height: 16),
        ListTile(
          onTap: () => LogoutDialog.show(),
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.logout, color: redColor),
          title: Text('Logout', style: TextStyle(color: redColor, fontSize: 16, fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }

  void _showPersonalInfoSheet(CompanyModel company, CompanyController controller) {
    final nameCtrl = TextEditingController(text: company.name);
    final emailCtrl = TextEditingController(text: company.email);
    final phoneCtrl = TextEditingController(text: company.phone);
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: whiteColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          _sheetHeader('Personal Information'),
          const SizedBox(height: 16),
          TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Company Name', border: OutlineInputBorder())),
          const SizedBox(height: 16),
          TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
          const SizedBox(height: 16),
          TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Phone', border: OutlineInputBorder())),
          const SizedBox(height: 24),
          _saveButton(() async { await controller.updateField('name', nameCtrl.text); await controller.updateField('email', emailCtrl.text); await controller.updateField('phone', phoneCtrl.text); Get.back(); }, 'Save Changes'),
          const SizedBox(height: 16),
        ]),
      ),
      isScrollControlled: true,
    );
  }

  void _showPasswordSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: whiteColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          _sheetHeader('Change Password'),
          const SizedBox(height: 16),
          TextField(obscureText: true, decoration: const InputDecoration(labelText: 'Current Password', border: OutlineInputBorder())),
          const SizedBox(height: 16),
          TextField(obscureText: true, decoration: const InputDecoration(labelText: 'New Password', border: OutlineInputBorder())),
          const SizedBox(height: 16),
          TextField(obscureText: true, decoration: const InputDecoration(labelText: 'Confirm Password', border: OutlineInputBorder())),
          const SizedBox(height: 24),
          _saveButton(() => Get.back(), 'Update Password'),
          const SizedBox(height: 16),
        ]),
      ),
      isScrollControlled: true,
    );
  }

  void _showNotificationSheet() {
    final push = true.obs; final email = true.obs; final orders = true.obs; final promo = false.obs;
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: whiteColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          _sheetHeader('Notification Settings'),
          const SizedBox(height: 16),
          Obx(() => SwitchListTile(title: const Text('Push Notifications'), value: push.value, onChanged: (v) => push.value = v, activeThumbColor: firstColor)),
          Obx(() => SwitchListTile(title: const Text('Email Notifications'), value: email.value, onChanged: (v) => email.value = v, activeThumbColor: firstColor)),
          Obx(() => SwitchListTile(title: const Text('Order Updates'), value: orders.value, onChanged: (v) => orders.value = v, activeThumbColor: firstColor)),
          Obx(() => SwitchListTile(title: const Text('Promotional Messages'), value: promo.value, onChanged: (v) => promo.value = v, activeThumbColor: firstColor)),
          const SizedBox(height: 24),
          _saveButton(() => Get.back(), 'Save Settings'),
          const SizedBox(height: 16),
        ]),
      ),
      isScrollControlled: true,
    );
  }

  void _showLocationSheet(CompanyModel company, CompanyController controller) {
    final addressCtrl = TextEditingController(text: company.address);
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: whiteColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          _sheetHeader('Business Location'),
          const SizedBox(height: 16),
          TextField(controller: addressCtrl, maxLines: 3, decoration: const InputDecoration(labelText: 'Business Address', border: OutlineInputBorder())),
          const SizedBox(height: 24),
          _saveButton(() async { await controller.updateField('address', addressCtrl.text); Get.back(); }, 'Update Location'),
          const SizedBox(height: 16),
        ]),
      ),
      isScrollControlled: true,
    );
  }

  Widget _sheetHeader(String title) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Text(title, style: TextStyle(color: blackColor, fontSize: 18, fontWeight: FontWeight.bold)),
    IconButton(onPressed: () => Get.back(), icon: Icon(Icons.close, color: greyColor)),
  ]);

  Widget _saveButton(VoidCallback onTap, String text) => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(backgroundColor: firstColor, foregroundColor: whiteColor, padding: const EdgeInsets.symmetric(vertical: 16)),
      child: Text(text),
    ),
  );
}
