import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:localbiz/features/configuration/data/models/negocio_model.dart';

class NegocioRepository {
  final CollectionReference _col =
      FirebaseFirestore.instance.collection('negocios');
  final FirebaseStorage _storage = FirebaseStorage.instance;

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
      'atualizadoEm': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return url;
  }
}
