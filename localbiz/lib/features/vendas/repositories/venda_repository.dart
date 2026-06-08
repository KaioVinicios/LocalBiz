import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localbiz/features/vendas/models/venda_produto_model.dart';

class VendaRepository {
  final _db = FirebaseFirestore.instance;


  CollectionReference<Map<String, dynamic>> _produtos(String negocioId) =>
      _db.collection('negocios').doc(negocioId).collection('produtos');

  Stream<List<VendaProdutoModel>> listarProdutos(String negocioId) {
    return _produtos(negocioId)
        .orderBy('nome')
        .snapshots()
        .map((snap) =>
            snap.docs.map(VendaProdutoModel.fromFirestore).toList());
  }


  Future<void> finalizarVenda({
    required String negocioId,
    required List<Map<String, dynamic>> itens,
    required int totalCentavos,
  }) async {
    final batch = _db.batch();

    final negocioRef = _db.collection('negocios').doc(negocioId);

    final vendaRef = negocioRef.collection('vendas').doc();
    batch.set(vendaRef, {
      'negocioId': negocioId,
      'itens': itens,
      'totalCentavos': totalCentavos,
      'criadoEm': FieldValue.serverTimestamp(),
    });


    for (final item in itens) {
      final produtoRef =
          negocioRef.collection('produtos').doc(item['produtoId'] as String);
      batch.update(produtoRef, {
        'estoqueAtual': FieldValue.increment(-(item['quantidade'] as int)),
      });
    }

    await batch.commit();
  }
}