import 'package:cloud_firestore/cloud_firestore.dart';

class VendaProdutoModel {
  VendaProdutoModel({
    required this.id,
    required this.nome,
    required this.preco,
    required this.estoqueAtual,
    required this.negocioId,
  });

  final String id;
  final String nome;
  final double preco;
  final int estoqueAtual;
  final String negocioId;

  bool get emEstoque => estoqueAtual > 0;

  factory VendaProdutoModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return VendaProdutoModel(
      id: doc.id,
      nome: data['nome'] ?? '',
      preco: (data['preco'] as num).toDouble(),
      estoqueAtual: (data['estoqueAtual'] as num).toInt(),
      negocioId: data['negocioId'] ?? '',
    );
  }
}