import 'package:cloud_firestore/cloud_firestore.dart';

class ServicoModel {
  final String id;
  final String nome;
  final String categoria;
  final double preco;
  final String icone;
  final bool ativo;
  final DateTime criadoEm;
  final DateTime atualizadoEm;
  final String criadoPor;
  final String negocioId;

  const ServicoModel({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.preco,
    required this.icone,
    required this.ativo,
    required this.criadoEm,
    required this.atualizadoEm,
    required this.criadoPor,
    required this.negocioId,
  });

  factory ServicoModel.fromMap(String id, Map<String, dynamic> map) {
    return ServicoModel(
      id: id,
      nome: map['nome'] as String? ?? '',
      categoria: map['categoria'] as String? ?? '',
      preco: (map['preco'] as num?)?.toDouble() ?? 0,
      icone: map['icone'] as String? ?? 'spa_outlined',
      ativo: map['ativo'] as bool? ?? true,
      criadoEm: (map['criadoEm'] as Timestamp?)?.toDate() ?? DateTime.now(),
      atualizadoEm: (map['atualizadoEm'] as Timestamp?)?.toDate() ?? DateTime.now(),
      criadoPor: map['criado_por'] as String? ?? '',
      negocioId: map['negocioId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'categoria': categoria,
      'preco': preco,
      'icone': icone,
      'ativo': ativo,
      'criadoEm': Timestamp.fromDate(criadoEm),
      'atualizadoEm': Timestamp.fromDate(atualizadoEm),
      'criado_por': criadoPor,
      'negocioId': negocioId,
    };
  }
}