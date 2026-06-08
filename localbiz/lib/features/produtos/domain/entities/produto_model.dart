import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

class Produto {
  Produto({
    this.id,
    required this.categoria,
    required this.nome,
    required this.precoCentavos,
    required this.codigoBarras,
    required this.estoqueAtual,
    required this.estoqueLocal,
    this.imagemUrl = '',
    this.imagemAsset,
    this.imagemBytes,
  });

  String? id;
  String categoria;
  String nome;
  int precoCentavos;
  String codigoBarras;
  int estoqueAtual;
  String estoqueLocal;
  String imagemUrl;
  String? imagemAsset;
  Uint8List? imagemBytes;

  factory Produto.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return Produto(
      id: doc.id,
      categoria: data['categoria'] as String? ?? 'Sem categoria',
      nome: data['nome'] as String? ?? '',
      precoCentavos: (data['precoCentavos'] as num?)?.toInt() ?? 0,
      codigoBarras: data['codigoBarras'] as String? ?? '',
      estoqueAtual: (data['estoqueAtual'] as num?)?.toInt() ?? 0,
      estoqueLocal: data['estoqueLocal'] as String? ?? 'Estoque A',
      imagemUrl: data['imagemUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'categoria': categoria,
    'nome': nome,
    'precoCentavos': precoCentavos,
    'codigoBarras': codigoBarras,
    'estoqueAtual': estoqueAtual,
    'estoqueLocal': estoqueLocal,
    'imagemUrl': imagemUrl,
  };
}
