import 'package:flutter/material.dart';
import 'package:localbiz/core/guards/auth_guards.dart';

import '../../features/auth/presentation/screens/login_page.dart';

class ProtectedRoute extends StatelessWidget {
  final Widget child;

  const ProtectedRoute({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (!AuthGuard.canAccess()) {
      return const LoginPage();
    }

    return child;
  }
}