import 'package:firebase_auth/firebase_auth.dart';

class AuthGuard {
  const AuthGuard._();

  static bool canAccess() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return false;
    }

    final email = user.email;

    if (email == null) {
      return false;
    }

    return email.endsWith('@souunit.com.br');
  }
}