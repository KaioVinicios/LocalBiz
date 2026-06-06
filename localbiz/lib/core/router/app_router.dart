import 'package:flutter/material.dart';
import 'package:localbiz/core/router/app_route.dart';
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
import 'package:localbiz/features/services/presentation/screens/services_scheduling.dart';
import 'package:localbiz/features/produtos/presentation/screens/produtos_page.dart';
import 'package:localbiz/features/vendas/presentation/screens/venda_page.dart';

class AppRouter {
  const AppRouter._();

  static String get initialRoute => AppRoute.login.path;

  static Map<String, WidgetBuilder> get routes => {
    AppRoute.home.path: (context) => const DashboardPage(),
    AppRoute.dashboard.path: (context) => const DashboardPage(),
    AppRoute.login.path: (context) => const LoginPage(),
    AppRoute.forgotPassword.path: (context) => const ForgotPasswordPage(),
    AppRoute.register.path: (context) => const RegisterPage(),
    AppRoute.clientes.path: (context) => const ClientesPage(),
    AppRoute.produtos.path: (context) => const ProdutosPage(),
    AppRoute.configuracoes.path: (context) => const ConfigurationPage(),
    AppRoute.vendas.path: (context) => const VendaPage(),
    AppRoute.services.path: (context) => const ServicosScreen(),
    AppRoute.serviceCreate.path: (context) => const ServiceCreatePage(),
    AppRoute.serviceEdit.path: (context) => const ServiceEditPage(),
    AppRoute.serviceDetails.path: (context) => const DetalheServicoScreen( servicoId: ''),  
    AppRoute.serviceSchedules.path: (context) =>
        const AgendamentoServicoScreen(),
    AppRoute.configuration.path: (context) => const ConfigurationPage(),
    AppRoute.businessProfile.path: (context) => const BusinessProfilePage(),
    AppRoute.report.path: (context) => const ReportPage(),
    AppRoute.relatorios.path: (context) => const ReportPage(),
  };
}
