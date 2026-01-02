import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../utils/globalVariable.dart';
import 'support/widgets/support_header.dart';
import 'support/widgets/quick_help_card.dart';
import 'support/widgets/faq_item.dart';
import 'support/widgets/contact_form.dart';

class SupportSection extends StatelessWidget {
  const SupportSection({super.key});

  static const String whatsappNumber = '1234567890';
  static const String phoneNumber = '+1234567890';

  Future<void> _launchWhatsApp() async {
    const whatsappUrl = "whatsapp://send?phone=$whatsappNumber";
    try {
      if (!await launchUrl(Uri.parse(whatsappUrl), mode: LaunchMode.externalApplication)) {
        const webWhatsappUrl = "https://wa.me/$whatsappNumber";
        if (!await launchUrl(Uri.parse(webWhatsappUrl), mode: LaunchMode.externalApplication)) {
          Get.snackbar('Error', 'Could not launch WhatsApp', backgroundColor: Colors.red, colorText: whiteColor);
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Could not launch WhatsApp', backgroundColor: Colors.red, colorText: whiteColor);
    }
  }

  Future<void> _launchPhoneCall() async {
    const phoneUrl = "tel:$phoneNumber";
    try {
      if (!await launchUrl(Uri.parse(phoneUrl), mode: LaunchMode.externalApplication)) {
        Get.snackbar('Error', 'Could not launch phone app', backgroundColor: Colors.red, colorText: whiteColor);
      }
    } catch (e) {
      Get.snackbar('Error', 'Could not launch phone app', backgroundColor: Colors.red, colorText: whiteColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SupportHeader(),
            _buildQuickHelp(),
            _buildFAQSection(),
            const ContactForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickHelp() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.rocket_launch, color: firstColor, size: 24),
              const SizedBox(width: 10),
              CustomText(text: 'Quick Help', color: blackColor, fontSize: 20.0, fontWeight: FontWeight.bold),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              QuickHelpCard(
                title: 'Live Chat',
                subtitle: 'Message us directly',
                icon: Icons.chat_bubble_outline,
                color: firstColor,
                onTap: _launchWhatsApp,
              ),
              const SizedBox(width: 15),
              QuickHelpCard(
                title: 'Call Us',
                subtitle: 'Speak with us now',
                icon: Icons.phone_in_talk_outlined,
                color: secondColor,
                onTap: _launchPhoneCall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFAQSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: firstColor, size: 24),
              const SizedBox(width: 10),
              CustomText(text: 'Common Questions', color: blackColor, fontSize: 20.0, fontWeight: FontWeight.bold),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: const Column(
              children: [
                FAQItem(
                  question: '📱 How do I add a new service?',
                  answer: 'To add a new service, go to the Services tab and tap the "+" button. Fill in the required information about your service including name, description, price, and duration.',
                ),
                FAQItem(
                  question: '📅 How do I manage my bookings?',
                  answer: 'You can manage all your bookings from the Bookings tab. Here you can view upcoming appointments, accept or decline booking requests, and manage your calendar.',
                ),
                FAQItem(
                  question: '💰 How do I view my earnings?',
                  answer: 'Visit the Analytics tab to see detailed reports of your earnings, popular services, and customer statistics. You can filter by different time periods.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
