import 'package:flutter/material.dart';
import 'package:localbiz/core/theme/app_colors.dart';
import 'package:localbiz/features/auth/presentation/screens/forgot_password_page.dart';
import 'package:localbiz/features/auth/presentation/screens/login_page.dart';
import 'package:localbiz/features/auth/presentation/screens/register_page.dart';
import 'package:localbiz/features/clientes/presentation/screens/clientes_page.dart';
import 'package:localbiz/features/configuration/presentation/screens/business_profile_page.dart';
import 'package:localbiz/features/configuration/presentation/screens/configuration_page.dart';
import 'package:localbiz/features/configuration/presentation/screens/report_page.dart';
import 'package:localbiz/features/services/presentation/screens/dashboard_page.dart';
import 'package:localbiz/features/services/presentation/screens/service_create_page.dart';
import 'package:localbiz/features/services/presentation/screens/service_edit_page.dart';
import 'package:localbiz/features/services/presentation/screens/service_listing.dart';
import 'package:localbiz/features/services/presentation/screens/services_details.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LocalBiz',
      routes: {
        '/home': (context) => const DashboardPage(),
        '/login': (context) => const LoginPage(),
        '/recuperar-senha': (context) => const ForgotPasswordPage(),
        '/signin': (context) => const RegisterPage(),
        '/clientes': (context) => const ClientesPage(),
        '/services': (context) => const ServicosScreen(),
        '/services/new': (context) => const ServiceCreatePage(),
        '/services/edit': (context) => const ServiceEditPage(),
        '/service-details': (context) => const DetalheServicoScreen(),
        '/configuration': (context) => const ConfigurationPage(),
        '/business-profile': (context) => const BusinessProfilePage(),
        '/report': (context) => const ReportPage(),
      },
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blue),
        scaffoldBackgroundColor: AppColors.surface,
      ),
      home: const DashboardPage(),
    );
  }
}
