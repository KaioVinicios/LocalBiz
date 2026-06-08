import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localbiz/features/vendas/models/venda_produto_model.dart';

class VendaRepository {
  final _db = FirebaseFirestore.instance;


  Stream<List<VendaProdutoModel>> listarProdutos(String negocioId) {
    return _db
        .collection('produtos')
        .where('negocioId', isEqualTo: negocioId)
        .where('ativo', isEqualTo: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map(VendaProdutoModel.fromFirestore).toList());
  }


  Future<void> finalizarVenda({
    required String negocioId,
    required List<Map<String, dynamic>> itens,
    required double total,
  }) async {
    final batch = _db.batch();


    final vendaRef = _db.collection('vendas').doc();
    batch.set(vendaRef, {
      'negocioId': negocioId,
      'itens': itens,
      'total': total,
      'criadoEm': FieldValue.serverTimestamp(),
    });


    for (final item in itens) {
      final produtoRef = _db.collection('produtos').doc(item['produtoId']);
      batch.update(produtoRef, {
        'estoqueAtual': FieldValue.increment(-item['quantidade']),
      });
    }

    await batch.commit();
  }
}