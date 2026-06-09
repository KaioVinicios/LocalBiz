import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localbiz/features/vendas/models/venda_model.dart';
import 'package:localbiz/features/vendas/models/venda_produto_model.dart';

abstract interface class VendaRepositoryContract {
  Stream<List<VendaProdutoModel>> listarProdutos(String negocioId);

  Stream<List<VendaModel>> observarVendas(String negocioId);

  Future<void> criarVenda({
    required String negocioId,
    required List<VendaItemModel> itens,
  });

  Future<void> atualizarVenda({
    required String negocioId,
    required String vendaId,
    required List<VendaItemModel> itens,
  });
}

class VendaRepository implements VendaRepositoryContract {
  VendaRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _produtos(String uid) =>
      _firestore.collection('negocios').doc(uid).collection('produtos');

  CollectionReference<Map<String, dynamic>> _vendas(String uid) =>
      _firestore.collection('negocios').doc(uid).collection('vendas');

  @override
  Stream<List<VendaProdutoModel>> listarProdutos(String negocioId) {
    return _produtos(negocioId)
        .orderBy('nome')
        .snapshots()
        .map((snap) => snap.docs.map(VendaProdutoModel.fromFirestore).toList());
  }

  @override
  Stream<List<VendaModel>> observarVendas(String negocioId) {
    return _vendas(negocioId)
        .orderBy('criadoEm', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(VendaModel.fromFirestore).toList());
  }

  @override
  Future<void> criarVenda({
    required String negocioId,
    required List<VendaItemModel> itens,
  }) async {
    if (itens.isEmpty) {
      throw ArgumentError('A venda precisa ter pelo menos um item.');
    }

    final vendaRef = _vendas(negocioId).doc();
    final totalCentavos = VendaModel.calcularTotalCentavos(itens);

    await _firestore.runTransaction((tx) async {
      tx.set(vendaRef, {
        'negocioId': negocioId,
        'itens': itens.map((item) => item.toMap()).toList(),
        'totalCentavos': totalCentavos,
        'criadoEm': FieldValue.serverTimestamp(),
        'atualizadoEm': FieldValue.serverTimestamp(),
      });

      for (final item in itens) {
        tx.update(_produtos(negocioId).doc(item.produtoId), {
          'estoqueAtual': FieldValue.increment(-item.quantidade),
          'atualizadoEm': FieldValue.serverTimestamp(),
        });
      }
    });
  }

  @override
  Future<void> atualizarVenda({
    required String negocioId,
    required String vendaId,
    required List<VendaItemModel> itens,
  }) async {
    if (itens.isEmpty) {
      throw ArgumentError('A venda precisa ter pelo menos um item.');
    }

    final vendaRef = _vendas(negocioId).doc(vendaId);
    final totalCentavos = VendaModel.calcularTotalCentavos(itens);

    await _firestore.runTransaction((tx) async {
      final vendaAtual = await tx.get(vendaRef);
      if (!vendaAtual.exists) {
        throw StateError('Venda não encontrada.');
      }

      final vendaAntiga = VendaModel.fromFirestore(vendaAtual);
      final diferencas = VendaModel.calcularDiferencaEstoque(
        antiga: vendaAntiga.itens,
        nova: itens,
      );

      tx.update(vendaRef, {
        'itens': itens.map((item) => item.toMap()).toList(),
        'totalCentavos': totalCentavos,
        'atualizadoEm': FieldValue.serverTimestamp(),
      });

      for (final entry in diferencas.entries) {
        tx.update(_produtos(negocioId).doc(entry.key), {
          'estoqueAtual': FieldValue.increment(entry.value),
          'atualizadoEm': FieldValue.serverTimestamp(),
        });
      }
    });
  }
}
