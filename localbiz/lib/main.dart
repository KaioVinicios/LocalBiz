import 'package:flutter/material.dart';
import 'package:localbiz/clientes/clientes_page.dart';
import 'package:localbiz/forgot_password/forgot_password_page.dart';
import 'package:localbiz/login/login_page.dart';
import 'package:localbiz/register/register_page.dart';
import 'package:localbiz/theme/app_colors.dart';

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
        '/login': (context) => const LoginPage(),
        '/recuperar-senha': (context) => const ForgotPasswordPage(),
        '/signin': (context) => const RegisterPage(),
        '/clientes': (context) => const ClientesPage(),
      },
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blue),
        scaffoldBackgroundColor: AppColors.surface,
      ),
      home: const ClientesPage(),
    );
  }
}
