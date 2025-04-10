import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/services_controller.dart';
import '../../../utils/global_variables.dart';
import '../../../widgets/responsive_layout.dart';
import '../../../widgets/service_card.dart';
import '../../../widgets/custom_shimmer.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ServicesController());

    return RefreshIndicator(
      onRefresh: () => controller.fetchServices(null, null,loadMore: false),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(GlobalVariables.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: GlobalVariables.largePadding),
            _buildServicesList(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'My Services',
          style: GlobalVariables.headingStyle,
        ),
        ElevatedButton.icon(
          onPressed: () => Get.toNamed('/add-service'),
          icon: const Icon(Icons.add),
          label: const Text('Add Service'),
          style: ElevatedButton.styleFrom(
            backgroundColor: GlobalVariables.primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: GlobalVariables.defaultPadding,
              vertical: GlobalVariables.smallPadding,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(GlobalVariables.smallBorderRadius),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServicesList(ServicesController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingShimmer();
      }

      if (controller.error.value.isNotEmpty) {
        return _buildErrorWidget(controller.error.value);
      }

      if (controller.services.isEmpty) {
        return _buildEmptyState();
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ResponsiveLayout.isMobile(Get.context!) ? 1 : 2,
          crossAxisSpacing: GlobalVariables.defaultPadding,
          mainAxisSpacing: GlobalVariables.defaultPadding,
          childAspectRatio: 1.5,
        ),
        itemCount: controller.services.length,
        itemBuilder: (context, index) {
          final service = controller.services[index];
          return ServiceCard(
            service: service,
            onEdit: () => Get.toNamed('/edit-service', arguments: service),
            onDelete: () => _showDeleteDialog(context, controller, service.id!),
          );
        },
      );
    });
  }

  Widget _buildLoadingShimmer() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveLayout.isMobile(Get.context!) ? 1 : 2,
        crossAxisSpacing: GlobalVariables.defaultPadding,
        mainAxisSpacing: GlobalVariables.defaultPadding,
        childAspectRatio: 1.5,
      ),
      itemCount: 4,
      itemBuilder: (context, index) => const CustomShimmer(
        height: 200,
        width: double.infinity,
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
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
            onPressed: () => Get.put(ServicesController()).fetchServices(null, null),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: GlobalVariables.smallPadding),
          Text(
            'No services yet',
            style: GlobalVariables.subheadingStyle,
          ),
          const SizedBox(height: GlobalVariables.smallPadding),
          ElevatedButton(
            onPressed: () => Get.toNamed('/add-service'),
            child: const Text('Add Your First Service'),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteDialog(
    BuildContext context,
    ServicesController controller,
    String serviceId,
  ) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Service'),
        content: const Text('Are you sure you want to delete this service?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await controller.deleteService(serviceId);
            },
            child: Text(
              'Delete',
              style: TextStyle(color: GlobalVariables.secondaryColor),
            ),
          ),
        ],
      ),
    );
  }
} 