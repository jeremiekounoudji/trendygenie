import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/global_variables.dart';

class SupportSection extends StatelessWidget {
  const SupportSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(GlobalVariables.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Support & Help',
            style: GlobalVariables.headingStyle,
          ),
          const SizedBox(height: GlobalVariables.largePadding),
          _buildFAQSection(),
          const SizedBox(height: GlobalVariables.largePadding),
          _buildContactForm(),
        ],
      ),
    );
  }

  Widget _buildFAQSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(GlobalVariables.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Frequently Asked Questions',
              style: GlobalVariables.subheadingStyle,
            ),
            const SizedBox(height: GlobalVariables.defaultPadding),
            ExpansionPanelList.radio(
              children: [
                ExpansionPanelRadio(
                  value: 0,
                  headerBuilder: (context, isExpanded) => ListTile(
                    title: Text(
                      'How do I add a new service?',
                      style: GlobalVariables.subheadingStyle.copyWith(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  body: const Padding(
                    padding: EdgeInsets.all(GlobalVariables.defaultPadding),
                    child: Text(
                      'To add a new service, click on the "Services" tab and then click the "+" button. Fill in the required information and click "Save".',
                    ),
                  ),
                ),
                ExpansionPanelRadio(
                  value: 1,
                  headerBuilder: (context, isExpanded) => ListTile(
                    title: Text(
                      'How do I update my business hours?',
                      style: GlobalVariables.subheadingStyle.copyWith(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  body: const Padding(
                    padding: EdgeInsets.all(GlobalVariables.defaultPadding),
                    child: Text(
                      'Go to the "Company" tab and scroll down to the "Business Hours" section. You can update the hours for each day of the week.',
                    ),
                  ),
                ),
                ExpansionPanelRadio(
                  value: 2,
                  headerBuilder: (context, isExpanded) => ListTile(
                    title: Text(
                      'How do I view my analytics?',
                      style: GlobalVariables.subheadingStyle.copyWith(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  body: const Padding(
                    padding: EdgeInsets.all(GlobalVariables.defaultPadding),
                    child: Text(
                      'The "Overview" tab shows your key metrics and analytics. You can view detailed statistics about your services, orders, and customer engagement.',
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

  Widget _buildContactForm() {
    final formKey = GlobalKey<FormState>();
    final subjectController = TextEditingController();
    final messageController = TextEditingController();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(GlobalVariables.defaultPadding),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Contact Support',
                style: GlobalVariables.subheadingStyle,
              ),
              const SizedBox(height: GlobalVariables.defaultPadding),
              TextFormField(
                controller: subjectController,
                decoration: const InputDecoration(
                  labelText: 'Subject',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a subject';
                  }
                  return null;
                },
              ),
              const SizedBox(height: GlobalVariables.defaultPadding),
              TextFormField(
                controller: messageController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your message';
                  }
                  return null;
                },
              ),
              const SizedBox(height: GlobalVariables.largePadding),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // TODO: Implement support ticket submission
                      Get.snackbar(
                        'Success',
                        'Your message has been sent. We\'ll get back to you soon.',
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                      subjectController.clear();
                      messageController.clear();
                    }
                  },
                  icon: const Icon(Icons.send),
                  label: const Text('Send Message'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GlobalVariables.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(GlobalVariables.defaultPadding),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 