import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/company_controller.dart';
import '../../../utils/global_variables.dart';
import '../../../widgets/custom_shimmer.dart';
import '../../../models/company_model.dart';

class CompanySection extends StatelessWidget {
  const CompanySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CompanyController());

    return SingleChildScrollView(
      padding: const EdgeInsets.all(GlobalVariables.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: GlobalVariables.largePadding),
          Obx(() {
            if (controller.isLoading.value) {
              return _buildLoadingState();
            }
            if (controller.error.value.isNotEmpty) {
              return _buildErrorState(controller.error.value);
            }
            return _buildCompanyForm(controller, context);
          }),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      'Company Profile',
      style: GlobalVariables.headingStyle,
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: [
        const CustomShimmer(height: 200, width: double.infinity),
        const SizedBox(height: GlobalVariables.defaultPadding),
        const CustomShimmer(height: 400, width: double.infinity),
      ],
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: GlobalVariables.secondaryColor,
          ),
          const SizedBox(height: GlobalVariables.smallPadding),
          Text(
            error,
            style: GlobalVariables.subheadingStyle.copyWith(
              color: GlobalVariables.secondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: GlobalVariables.defaultPadding),
          ElevatedButton(
            onPressed: () => Get.find<CompanyController>().fetchCompany(),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyForm(CompanyController controller, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLogoSection(controller),
        const SizedBox(height: GlobalVariables.largePadding),
        _buildBasicInfoSection(controller),
        const SizedBox(height: GlobalVariables.largePadding),
        _buildBusinessHoursSection(controller),
        const SizedBox(height: GlobalVariables.largePadding),
        _buildLocationSection(controller),
        const SizedBox(height: GlobalVariables.largePadding),
        _buildDangerZone(controller, context),
      ],
    );
  }

  Widget _buildLogoSection(CompanyController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(GlobalVariables.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Company Logo',
              style: GlobalVariables.subheadingStyle,
            ),
            const SizedBox(height: GlobalVariables.defaultPadding),
            Center(
              child: GestureDetector(
                onTap: () => controller.pickLogo(),
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(GlobalVariables.borderRadius),
                    image: controller.company.value?.companyLogo != null
                        ? DecorationImage(
                            image: NetworkImage(controller.company.value!.companyLogo!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: controller.company.value?.companyLogo == null
                      ? Icon(
                          Icons.add_photo_alternate,
                          size: 50,
                          color: Colors.grey[400],
                        )
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection(CompanyController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(GlobalVariables.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Information',
              style: GlobalVariables.subheadingStyle,
            ),
            const SizedBox(height: GlobalVariables.defaultPadding),
            TextFormField(
              initialValue: controller.company.value?.name,
              decoration: const InputDecoration(
                labelText: 'Company Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => controller.updateField('name', value),
            ),
            const SizedBox(height: GlobalVariables.smallPadding),
            TextFormField(
              initialValue: controller.company.value?.description,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => controller.updateField('description', value),
            ),
            // Add more fields as needed
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessHoursSection(CompanyController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(GlobalVariables.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Business Hours',
              style: GlobalVariables.subheadingStyle,
            ),
            const SizedBox(height: GlobalVariables.defaultPadding),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 7,
              itemBuilder: (context, index) {
                final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
                final hours = controller.company.value?.businessHours ?? [];
                final currentHours = hours.length > index ? hours[index] : '';

                return Padding(
                  padding: const EdgeInsets.only(bottom: GlobalVariables.smallPadding),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text(days[index]),
                      ),
                      Expanded(
                        child: TextFormField(
                          initialValue: currentHours,
                          decoration: InputDecoration(
                            hintText: 'e.g., 09:00-18:00',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.copy),
                              onPressed: () {
                                if (index > 0 && hours.length > index - 1) {
                                  final newHours = List<String>.from(hours);
                                  newHours[index] = hours[index - 1];
                                  controller.updateBusinessHours(newHours);
                                }
                              },
                            ),
                          ),
                          onChanged: (value) {
                            final newHours = List<String>.from(hours);
                            if (newHours.length <= index) {
                              newHours.addAll(List.filled(index - newHours.length + 1, ''));
                            }
                            newHours[index] = value;
                            controller.updateBusinessHours(newHours);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSection(CompanyController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(GlobalVariables.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Location',
              style: GlobalVariables.subheadingStyle,
            ),
            const SizedBox(height: GlobalVariables.defaultPadding),
            TextFormField(
              initialValue: controller.company.value?.address,
              decoration: const InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => controller.updateField('address', value),
            ),
            const SizedBox(height: GlobalVariables.smallPadding),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: controller.company.value?.latitude?.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Latitude',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final lat = double.tryParse(value);
                      if (lat != null) {
                        controller.updateLocation(
                          lat,
                          controller.company.value?.longitude ?? 0,
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(width: GlobalVariables.smallPadding),
                Expanded(
                  child: TextFormField(
                    initialValue: controller.company.value?.longitude?.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Longitude',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final lng = double.tryParse(value);
                      if (lng != null) {
                        controller.updateLocation(
                          controller.company.value?.latitude ?? 0,
                          lng,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: GlobalVariables.smallPadding),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement map picker
                },
                icon: const Icon(Icons.map),
                label: const Text('Pick Location on Map'),
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
    );
  }

  Widget _buildDangerZone(CompanyController controller, BuildContext context) {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(GlobalVariables.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Danger Zone',
              style: GlobalVariables.subheadingStyle.copyWith(
                color: Colors.red,
              ),
            ),
            const SizedBox(height: GlobalVariables.defaultPadding),
            Text(
              'Once you delete your company, there is no going back. Please be certain.',
              style: TextStyle(color: Colors.red.shade700),
            ),
            const SizedBox(height: GlobalVariables.defaultPadding),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showDeleteConfirmation(context, controller),
                icon: const Icon(Icons.delete_forever),
                label: const Text('Delete Company'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(GlobalVariables.defaultPadding),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(
    BuildContext context,
    CompanyController controller,
  ) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Company'),
        content: const Text(
          'Are you sure you want to delete your company? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              final success = await controller.deleteCompany();
              if (success) {
                Get.offAllNamed('/');
              }
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
} 