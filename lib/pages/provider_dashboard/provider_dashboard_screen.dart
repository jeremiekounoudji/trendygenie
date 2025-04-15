import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/globalVariable.dart';
import '../../widgets/responsive_layout.dart';
import 'sections/overview_section.dart';
import 'sections/business_section.dart';
import 'sections/company_section.dart';
import 'sections/support_section.dart';

class ProviderDashboardScreen extends StatelessWidget {
  final RxInt currentIndex = 0.obs;
  final List<Widget> sections = [
    const OverviewSection(),
    const BusinessSection(),
    const CompanySection(),
    const SupportSection(),
  ];

  ProviderDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(),
        tablet: _buildTabletLayout(),
        desktop: _buildDesktopLayout(),
      ),
      floatingActionButton: Obx(() => currentIndex.value == 1 
        ? FloatingActionButton(
            onPressed: () {
              // Navigate to add business page
              // Get.to(() => CreateBusinessPage());
            },
            backgroundColor: firstColor,
            child: const Icon(Icons.add),
          )
        : const SizedBox()),
      bottomNavigationBar: Obx(() => NavigationBar(
        selectedIndex: currentIndex.value,
        onDestinationSelected: (index) => currentIndex.value = index,
        backgroundColor: Colors.white,
        elevation: 0,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Overview',
          ),
          NavigationDestination(
            icon: Icon(Icons.business_outlined),
            selectedIcon: Icon(Icons.business),
            label: 'Businesses',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle_outlined),
            selectedIcon: Icon(Icons.account_circle),
            label: 'Company',
          ),
          NavigationDestination(
            icon: Icon(Icons.support_outlined),
            selectedIcon: Icon(Icons.support),
            label: 'Support',
          ),
        ],
      )),
    );
  }

  Widget _buildMobileLayout() {
    return SafeArea(
      child: Obx(() => sections[currentIndex.value]),
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        NavigationRail(
          selectedIndex: currentIndex.value,
          onDestinationSelected: (index) => currentIndex.value = index,
          labelType: NavigationRailLabelType.selected,
          destinations: [
            NavigationRailDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard),
              label: Text('Overview'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.business_outlined),
              selectedIcon: Icon(Icons.business),
              label: Text('Businesses'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.account_circle_outlined),
              selectedIcon: Icon(Icons.account_circle),
              label: Text('Company'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.support_outlined),
              selectedIcon: Icon(Icons.support),
              label: Text('Support'),
            ),
          ],
        ),
        Expanded(
          child: SafeArea(
            child: Obx(() => sections[currentIndex.value]),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        NavigationRail(
          extended: true,
          selectedIndex: currentIndex.value,
          onDestinationSelected: (index) => currentIndex.value = index,
          destinations: [
            NavigationRailDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard),
              label: Text('Overview'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.business_outlined),
              selectedIcon: Icon(Icons.business),
              label: Text('Businesses'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.account_circle_outlined),
              selectedIcon: Icon(Icons.account_circle),
              label: Text('Company'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.support_outlined),
              selectedIcon: Icon(Icons.support),
              label: Text('Support'),
            ),
          ],
        ),
        Expanded(
          child: SafeArea(
            child: Obx(() => sections[currentIndex.value]),
          ),
        ),
      ],
    );
  }
} 