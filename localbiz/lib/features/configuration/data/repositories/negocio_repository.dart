import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:localbiz/features/configuration/data/models/negocio_model.dart';

class NegocioRepository {
  final CollectionReference _col =
      FirebaseFirestore.instance.collection('negocios');
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// E-mail do usuário autenticado no momento da escrita.
  /// Atende à regra de amarração dinâmica de dados: nenhum registro pode ser
  /// salvo de forma anônima — todo write carrega o e-mail do Firebase Auth.
  String get _criadoPor {
    final email = _auth.currentUser?.email;
    if (email == null || email.isEmpty) {
      throw StateError('Nenhum usuário autenticado para salvar o registro.');
    }
    return email;
  }

  /// Carrega o perfil do negócio do usuário. Retorna `null` se ainda não existir.
  Future<NegocioModel?> carregar(String uid) async {
    final doc = await _col.doc(uid).get();
    if (!doc.exists) return null;
    return NegocioModel.fromFirestore(doc);
  }

  /// Stream do perfil para refletir mudanças em tempo real (ex: header da config).
  Stream<NegocioModel?> observar(String uid) {
    return _col
        .doc(uid)
        .snapshots()
        .map((doc) => doc.exists ? NegocioModel.fromFirestore(doc) : null);
  }

  /// Cria ou atualiza o perfil do negócio (merge para não apagar campos futuros).
  Future<void> salvar(String uid, NegocioModel negocio) async {
    await _col.doc(uid).set({
      ...negocio.toMap(),
      'criado_por': _criadoPor,
      'atualizadoEm': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Envia a foto do negócio para o Storage (`negocios/{uid}/foto.jpg`),
  /// grava a URL pública em `negocios/{uid}.fotoUrl` e retorna essa URL.
  Future<String> uploadFoto(String uid, Uint8List bytes) async {
    final ref = _storage.ref().child('negocios/$uid/foto.jpg');
    await ref.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
    final url = await ref.getDownloadURL();

    await _col.doc(uid).set({
      'fotoUrl': url,
      'criado_por': _criadoPor,
      'atualizadoEm': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return url;
  }
}
