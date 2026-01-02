import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/company_controller.dart';
import '../../models/business_model.dart';
import '../../utils/globalVariable.dart';
import '../provider_dashboard/sections/services/add_service_page.dart';
import '../../controllers/company_services_controller.dart';
import 'widgets/index.dart';

class CompanyServicesPage extends StatefulWidget {
  final String companyId;
  final String categoryName;
  final String companyName;
  final BusinessModel? business; // Add business parameter

  const CompanyServicesPage({
    super.key,
    required this.companyId,
    required this.categoryName,
    required this.companyName,
    this.business, // Optional business parameter
  });

  @override
  State<CompanyServicesPage> createState() => _CompanyServicesPageState();
}

class _CompanyServicesPageState extends State<CompanyServicesPage> {
  late final ScrollController _scrollController;
  late final CompanyServicesController controller;
  final CompanyController companyController = Get.find<CompanyController>();
  
  bool get isOwner {
    // Check if current user's company owns this business
    final currentCompany = companyController.company.value;
    return currentCompany != null && 
           currentCompany.id == widget.companyId && 
           widget.business != null;
  }

  @override
  void initState() {
    super.initState();
    controller = Get.put(CompanyServicesController(companyId: widget.companyId));
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      controller.loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      floatingActionButton: isOwner
          ? FloatingActionButton(
              heroTag: 'add_service_fab',
              backgroundColor: firstColor,
              child: Icon(Icons.add, color: whiteColor),
              onPressed: () => Get.to(() => AddServicePage(business: widget.business!)),
            )
          : null,
      bottomNavigationBar: isOwner && widget.business != null
          ? EditBusinessBottomBar(business: widget.business!)
          : null,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            CompanyHeader(
              companyName: widget.companyName,
              categoryName: widget.categoryName,
              onBack: () => Get.back(),
            ),

            // Business Description Section
            BusinessDescriptionSection(
              business: widget.business,
              isOwner: isOwner,
              companyName: widget.companyName,
            ),

            // Services List
            Expanded(
              child: ServicesList(
                controller: controller,
                scrollController: _scrollController,
                categoryName: widget.categoryName,
                business: widget.business,
                isOwner: isOwner,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 