import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../utils/globalVariable.dart';

class ContactForm extends StatelessWidget {
  final String supportEmail;
  
  const ContactForm({
    super.key,
    this.supportEmail = 'support@trendygenie.com',
  });

  @override
  Widget build(BuildContext context) {
    final subjectController = TextEditingController();
    final messageController = TextEditingController();

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [firstColor.withOpacity(0.1), secondColor.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: firstColor.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.mail_outline, color: firstColor, size: 24),
              const SizedBox(width: 10),
              CustomText(text: 'Send us a message', color: blackColor, fontSize: 20.0, fontWeight: FontWeight.bold),
            ],
          ),
          const SizedBox(height: 20),
          _buildTextField(subjectController, 'Subject', 1),
          const SizedBox(height: 15),
          _buildTextField(messageController, 'Message', 4),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => _sendEmail(subjectController.text, messageController.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: firstColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send_outlined, color: whiteColor, size: 20),
                  const SizedBox(width: 10),
                  const CustomText(text: 'Send Message', color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, int maxLines) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: whiteColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: firstColor.withOpacity(0.2))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: firstColor)),
      ),
    );
  }

  Future<void> _sendEmail(String subject, String message) async {
    final subjectEncoded = Uri.encodeComponent(subject.isNotEmpty ? subject : 'Support Request');
    final bodyEncoded = Uri.encodeComponent(message);
    final emailUrl = 'mailto:$supportEmail?subject=$subjectEncoded&body=$bodyEncoded';

    try {
      if (!await launchUrl(Uri.parse(emailUrl), mode: LaunchMode.externalApplication)) {
        Get.snackbar('Error', 'Could not open email app', backgroundColor: Colors.red, colorText: whiteColor);
      }
    } catch (e) {
      Get.snackbar('Error', 'Could not open email app', backgroundColor: Colors.red, colorText: whiteColor);
    }
  }
}
