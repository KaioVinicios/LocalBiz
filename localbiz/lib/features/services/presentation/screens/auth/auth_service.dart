import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;


  // Validação obrigatória do domínio institucional
  bool _validarDominio(User? user) {
    if (user == null || user.email == null) return false;
    if (user.email!.endsWith('@souunit.com.br')) {
      return true;
    } else {
      logout(); // Desloga imediatamente se for intruso
      return false;
    }
  }

  Future<User?> cadastrarComEmail({
    required String email,
    required String password,
    required String nomeCompleto,
    required String nomeNegocio,
    required String telefone,
  }) async {
    if(!email.endsWith('@souunit.com.br')) {
      throw Exception("Apenas e-mails @souunit.com.br são permitidos.");
    }

 // 1. Cria a conta de autenticação no Firebase Auth
    UserCredential credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;

    // 2. Salva os campos complementares no Cloud Firestore vinculados ao ID do usuário
    if (user != null) {
      await _db.collection('usuarios').doc(user.uid).set({
        'nome_completo': nomeCompleto,
        'nome_negocio': nomeNegocio,
        'telefone': telefone,
        'email': email,
        'criado_em': FieldValue.serverTimestamp(),
        // Atende ao requisito de amarração dinâmica de dados exigido na disciplina:
        'usuario_logado': email, 
      });
    }

    return user;
    
  }

  // Login tradicional E-mail/Senha
  Future<User?> loginComEmail(String email, String password) async {
    UserCredential credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (_validarDominio(credential.user)) {
      return credential.user;
    } else {
      throw Exception("Acesso negado. Use o e-mail @souunit.com.br.");
    }
  }

  // Login com o Provedor do Google
  Future<User?> loginComGoogle() async {
    if (kIsWeb) {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      googleProvider.setCustomParameters({'prompt': 'select_account'});
      UserCredential userCredential = await _auth.signInWithPopup(googleProvider);
      
      if (_validarDominio(userCredential.user)) {
        return userCredential.user;
      } else {
        throw Exception("Acesso negado. A conta Google deve ser @souunit.com.br.");
      }
    }
    return null;
  }

  Future<void> logout() async => await _auth.signOut();
}
