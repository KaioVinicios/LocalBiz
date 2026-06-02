import 'package:flutter/material.dart';
import 'package:localbiz/clientes/clientes_page.dart';
import 'package:localbiz/forgot_password/forgot_password_page.dart';
import 'package:localbiz/login/login_page.dart';
import 'package:localbiz/pages/configuration/configuration_page.dart';
import 'package:localbiz/produtos/produtos_page.dart';
import 'package:localbiz/register/register_page.dart';
import 'package:localbiz/services/service_listing.dart';
import 'package:localbiz/services/services_details.dart';
import 'package:localbiz/theme/app_colors.dart';
import 'package:localbiz/vendas/venda_page.dart';
import 'package:localbiz/services/services_scheduling.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
        '/home': (context) => const VendaPage(),
        '/login': (context) => const LoginPage(),
        '/recuperar-senha': (context) => const ForgotPasswordPage(),
        '/signin': (context) => const RegisterPage(),
        '/clientes': (context) => const ClientesPage(),
        '/produtos': (context) => const ProdutosPage(),
        '/configuracoes': (context) => const ConfigurationPage(),
        '/vendas': (context) => const VendaPage(),
        '/services': (context) => const ServicosScreen(),
        '/service-details': (context) =>
            const DetalheServicoScreen(servicoId: ''),
        '/service-schedules': (context) => const AgendamentoServicoScreen(),
        '/configuration': (context) => const ConfigurationPage(),
      },
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blue),
        scaffoldBackgroundColor: AppColors.surface,
      ),
      home: const ServicosScreen(),
    );
  }
}
