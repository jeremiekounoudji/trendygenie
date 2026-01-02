import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/globalVariable.dart';
import '../../widgets/responsive_layout.dart';
import 'overview/overview_section.dart';
import 'sections/business/business_section.dart';
import 'company/company_section.dart';
import 'sections/support_section.dart';
import 'sections/transactions/transactions_section.dart';
import 'sections/business/create_business_page.dart';

class ProviderDashboardScreen extends StatelessWidget {
  final RxInt currentIndex = 0.obs;
  final List<Widget> sections = [
    const OverviewSection(),
    const BusinessSection(),
    const CompanySection(),
    const TransactionsSection(),
    const SupportSection(),
  ];

  ProviderDashboardScreen({super.key});

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
            heroTag: 'dashboard_fab',
            onPressed: () {
              // Navigate to add business page
              Get.to(() => const CreateBusinessPage());
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
          const NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Overview',
          ),
          const NavigationDestination(
            icon: Icon(Icons.business_outlined),
            selectedIcon: Icon(Icons.business),
            label: 'Businesses',
          ),
          const NavigationDestination(
            icon: Icon(Icons.account_circle_outlined),
            selectedIcon: Icon(Icons.account_circle),
            label: 'Company',
          ),
          const NavigationDestination(
            icon: Icon(Icons.payments_outlined),
            selectedIcon: Icon(Icons.payments),
            label: 'Transactions',
          ),
          const NavigationDestination(
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
            const NavigationRailDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard),
              label: Text('Overview'),
            ),
            const NavigationRailDestination(
              icon: Icon(Icons.business_outlined),
              selectedIcon: Icon(Icons.business),
              label: Text('Businesses'),
            ),
            const NavigationRailDestination(
              icon: Icon(Icons.account_circle_outlined),
              selectedIcon: Icon(Icons.account_circle),
              label: Text('Company'),
            ),
            const NavigationRailDestination(
              icon: Icon(Icons.payments_outlined),
              selectedIcon: Icon(Icons.payments),
              label: Text('Transactions'),
            ),
            const NavigationRailDestination(
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
            const NavigationRailDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard),
              label: Text('Overview'),
            ),
            const NavigationRailDestination(
              icon: Icon(Icons.business_outlined),
              selectedIcon: Icon(Icons.business),
              label: Text('Businesses'),
            ),
            const NavigationRailDestination(
              icon: Icon(Icons.account_circle_outlined),
              selectedIcon: Icon(Icons.account_circle),
              label: Text('Company'),
            ),
            const NavigationRailDestination(
              icon: Icon(Icons.payments_outlined),
              selectedIcon: Icon(Icons.payments),
              label: Text('Transactions'),
            ),
            const NavigationRailDestination(
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