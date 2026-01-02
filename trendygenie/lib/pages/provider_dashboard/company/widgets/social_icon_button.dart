import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../utils/globalVariable.dart';

class SocialIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String? url;
  final String label;

  const SocialIconButton({
    super.key,
    required this.icon,
    required this.color,
    required this.url,
    required this.label,
  });

  Future<void> _handleTap() async {
    if (url != null && url!.isNotEmpty) {
      final uri = Uri.parse(url!);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error', 
          'Could not open $label', 
          backgroundColor: Colors.red, 
          colorText: whiteColor,
        );
      }
    } else {
      Get.snackbar(
        'Info', 
        '$label link not available', 
        backgroundColor: greyColor, 
        colorText: whiteColor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _handleTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1), 
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }
}
