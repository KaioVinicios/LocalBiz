import 'package:flutter/material.dart';
import 'package:localbiz/core/router/app_router.dart';
import 'package:localbiz/core/theme/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDj0ZFRUbTUXOFpfc7i3W3nT1zBORL0ul4",
      authDomain: "localbiz-d523b.firebaseapp.com",
      projectId: "localbiz-d523b",
      storageBucket: "localbiz-d523b.firebasestorage.app",
      messagingSenderId: "316070364598",
      appId: "1:316070364598:web:b4098807a50e25dbd6ad17",
    ),
  );
  
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
