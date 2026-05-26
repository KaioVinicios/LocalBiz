import 'package:flutter/material.dart';
import 'package:localbiz/core/router/app_router.dart';
import 'package:localbiz/core/theme/app_colors.dart';

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
      initialRoute: AppRouter.initialRoute,
      routes: AppRouter.routes,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blue),
        scaffoldBackgroundColor: AppColors.surface,
      ),
    );
  }
}
