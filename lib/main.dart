import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trendygenie/pages/authentication/login/login_page.dart';
import 'package:trendygenie/pages/authentication/register/register_page.dart';
import 'package:trendygenie/pages/authentication/register/register_step_four.dart';
import 'package:trendygenie/services/supabase_service.dart';
import 'package:trendygenie/controllers/auth_controller.dart';
import 'package:trendygenie/pages/authentication/certification_pending_page.dart';
  import 'package:trendygenie/controllers/company_controller.dart';

import 'pages/authentication/register/register_step_three.dart';
import 'pages/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize();
  
  Get.put(AuthController());
  Get.put(CompanyController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TrendyGenie',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/register/type-selection', page: () => RegisterStepThree()),
        GetPage(name: '/register/company-details', page: () => RegisterStepFour()),
        GetPage(
          name: '/certification-pending', 
          page: () => const CertificationPendingPage()
        ),
        // ... other routes
      ],
    );
  }
}
