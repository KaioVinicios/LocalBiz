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
import 'package:localbiz/widgets/nav_bar.dart';

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
        '/home': (context) => const _HomeMenuTestePage(),
        '/login': (context) => const LoginPage(),
        '/recuperar-senha': (context) => const ForgotPasswordPage(),
        '/signin': (context) => const RegisterPage(),
        '/clientes': (context) => const ClientesPage(),
        '/produtos': (context) => const ProdutosPage(),
        '/configuracoes': (context) => const ConfigurationPage(),
        '/services': (context) => const ServicosScreen(),
        '/service-details': (context) => const DetalheServicoScreen(),
        '/configuration': (context) => const ConfigurationPage(),
      },
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blue),
        scaffoldBackgroundColor: AppColors.surface,
      ),
      home: const _HomeMenuTestePage(),
    );
  }
}

class _HomeMenuTestePage extends StatelessWidget {
  const _HomeMenuTestePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          'menu teste',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      bottomNavigationBar: const NavBar(initialIndex: 0),
    );
  }
}
