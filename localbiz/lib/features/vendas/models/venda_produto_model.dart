import 'package:cloud_firestore/cloud_firestore.dart';

class VendaProdutoModel {
  VendaProdutoModel({
    required this.id,
    required this.nome,
    required this.precoCentavos,
    required this.estoqueAtual,
    required this.negocioId,
  });

  final String id;
  final String nome;
  final int precoCentavos;
  final int estoqueAtual;
  final String negocioId;

  bool get emEstoque => estoqueAtual > 0;

  /// Preço em reais, usado apenas na borda de exibição/cálculo.
  double get precoReais => precoCentavos / 100;

  factory VendaProdutoModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return VendaProdutoModel(
      id: doc.id,
      nome: data['nome'] ?? '',
      precoCentavos: (data['precoCentavos'] as num?)?.toInt() ?? 0,
      estoqueAtual: (data['estoqueAtual'] as num?)?.toInt() ?? 0,
      negocioId: data['negocioId'] ?? '',
    );
  }
}