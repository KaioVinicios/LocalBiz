import 'package:flutter/material.dart';
import 'package:localbiz/core/router/app_route.dart';
import 'package:localbiz/features/auth/presentation/screens/forgot_password_page.dart';
import 'package:localbiz/features/auth/presentation/screens/login_page.dart';
import 'package:localbiz/features/auth/presentation/screens/register_page.dart';
import 'package:localbiz/features/clientes/presentation/screens/clientes_page.dart';
import 'package:localbiz/features/configuration/presentation/screens/business_profile_page.dart';
import 'package:localbiz/features/configuration/presentation/screens/configuration_page.dart';
import 'package:localbiz/features/configuration/presentation/screens/help_support_page.dart';
import 'package:localbiz/features/configuration/presentation/screens/report_page.dart';
import 'package:localbiz/features/services/presentation/screens/dashboard_page.dart';
import 'package:localbiz/features/services/presentation/screens/service_create_page.dart';
import 'package:localbiz/features/services/presentation/screens/service_edit_page.dart';
import 'package:localbiz/features/services/presentation/screens/service_listing.dart';
import 'package:localbiz/features/services/presentation/screens/services_details.dart';
import 'package:localbiz/features/services/presentation/screens/services_scheduling.dart';
import 'package:localbiz/features/produtos/presentation/screens/produtos_page.dart';
import 'package:localbiz/features/vendas/models/venda_model.dart';
import 'package:localbiz/features/vendas/presentation/screens/venda_historico_page.dart';
import 'package:localbiz/features/vendas/presentation/screens/venda_page.dart';
import 'package:localbiz/core/guards/protected_route.dart';

class AppRouter {
  const AppRouter._();

  static String get initialRoute => AppRoute.login.path;

  static Map<String, WidgetBuilder> get routes => {
    AppRoute.login.path: (context) => const LoginPage(),
    AppRoute.forgotPassword.path: (context) => const ForgotPasswordPage(),
    AppRoute.register.path: (context) => const RegisterPage(),

    AppRoute.home.path: (context) =>
        const ProtectedRoute(child: DashboardPage()),
    AppRoute.dashboard.path: (context) =>
        const ProtectedRoute(child: DashboardPage()),
    AppRoute.clientes.path: (context) =>
        const ProtectedRoute(child: ClientesPage()),
    AppRoute.produtos.path: (context) =>
        const ProtectedRoute(child: ProdutosPage()),
    AppRoute.configuracoes.path: (context) =>
        const ProtectedRoute(child: ConfigurationPage()),
    AppRoute.vendas.path: (context) => const ProtectedRoute(child: VendaPage()),
    AppRoute.vendasHistorico.path: (context) =>
        const ProtectedRoute(child: VendaHistoricoPage()),
    AppRoute.vendaEdit.path: (context) {
      final venda = ModalRoute.of(context)?.settings.arguments as VendaModel?;
      return ProtectedRoute(child: VendaPage(vendaInicial: venda));
    },
    AppRoute.services.path: (context) =>
        const ProtectedRoute(child: ServicosScreen()),
    AppRoute.serviceCreate.path: (context) =>
        const ProtectedRoute(child: ServiceCreatePage()),
    AppRoute.serviceEdit.path: (context) =>
        const ProtectedRoute(child: ServiceEditPage()),
    AppRoute.serviceDetails.path: (context) =>
        const ProtectedRoute(child: DetalheServicoScreen(servicoId: '')),
    AppRoute.serviceSchedules.path: (context) =>
        const ProtectedRoute(child: AgendamentoServicoScreen()),
    AppRoute.configuration.path: (context) =>
        const ProtectedRoute(child: ConfigurationPage()),
    AppRoute.businessProfile.path: (context) =>
        const ProtectedRoute(child: BusinessProfilePage()),
    AppRoute.report.path: (context) =>
        const ProtectedRoute(child: ReportPage()),
    AppRoute.relatorios.path: (context) =>
        const ProtectedRoute(child: ReportPage()),
    AppRoute.ajuda.path: (context) =>
        const ProtectedRoute(child: HelpSupportPage()),
  };
}
