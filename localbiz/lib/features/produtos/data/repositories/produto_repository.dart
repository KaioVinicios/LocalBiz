import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:localbiz/features/produtos/domain/entities/produto_model.dart';

class ProdutoRepository {
  ProdutoRepository({FirebaseFirestore? firestore, FirebaseStorage? storage})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _storage = storage ?? FirebaseStorage.instance;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  CollectionReference<Map<String, dynamic>> _colecao(String uid) =>
      _firestore.collection('negocios').doc(uid).collection('produtos');

  Stream<List<Produto>> observar(String uid) {
    return _colecao(uid)
        .orderBy('nome')
        .snapshots()
        .map((snap) => snap.docs.map(Produto.fromFirestore).toList());
  }

  Future<Produto> criar(
    String uid,
    Produto produto, {
    Uint8List? imagemBytes,
  }) async {
    final ref = await _colecao(uid).add({
      ...produto.toMap(),
      'criadoEm': FieldValue.serverTimestamp(),
      'atualizadoEm': FieldValue.serverTimestamp(),
    });
    produto.id = ref.id;

    if (imagemBytes != null) {
      produto.imagemUrl = await _enviarImagem(uid, ref.id, imagemBytes);
    }
    return produto;
  }

  Future<void> atualizar(
    String uid,
    Produto produto, {
    Uint8List? novaImagemBytes,
  }) async {
    final id = produto.id;
    if (id == null) {
      throw ArgumentError('Produto sem id não pode ser atualizado.');
    }

    if (novaImagemBytes != null) {
      produto.imagemUrl = await _enviarImagem(uid, id, novaImagemBytes);
    }

    await _colecao(uid).doc(id).update({
      'categoria': produto.categoria,
      'nome': produto.nome,
      'preco': produto.preco,
      'codigoBarras': produto.codigoBarras,
      'estoqueLocal': produto.estoqueLocal,
      'imagemUrl': produto.imagemUrl,
      'atualizadoEm': FieldValue.serverTimestamp(),
    });
  }

  Future<void> excluir(String uid, String produtoId) async {
    await _colecao(uid).doc(produtoId).delete();
    try {
      await _storage.ref().child('produtos/$uid/$produtoId.jpg').delete();
    } on FirebaseException {
      return;
    }
  }

  Future<void> movimentarEstoque(
    String uid,
    String produtoId, {
    required int delta,
    String? estoqueLocal,
  }) {
    final doc = _colecao(uid).doc(produtoId);
    return _firestore.runTransaction((tx) async {
      final snap = await tx.get(doc);
      final atual = (snap.data()?['estoqueAtual'] as num?)?.toInt() ?? 0;
      final novo = atual + delta;
      tx.update(doc, {
        'estoqueAtual': novo < 0 ? 0 : novo,
        if (estoqueLocal != null) 'estoqueLocal': estoqueLocal,
        'atualizadoEm': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<String> _enviarImagem(
    String uid,
    String produtoId,
    Uint8List bytes,
  ) async {
    final ref = _storage.ref().child('produtos/$uid/$produtoId.jpg');
    await ref.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
    final url = await ref.getDownloadURL();
    await _colecao(uid).doc(produtoId).update({'imagemUrl': url});
    return url;
  }
}
