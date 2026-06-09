import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localbiz/core/utils/money.dart';

class VendaItemModel {
  const VendaItemModel({
    required this.produtoId,
    required this.nome,
    required this.precoCentavos,
    required this.quantidade,
  });

  final String produtoId;
  final String nome;
  final int precoCentavos;
  final int quantidade;

  int get subtotalCentavos => precoCentavos * quantidade;

  double get precoReais => precoCentavos / 100;

  VendaItemModel copyWith({
    String? produtoId,
    String? nome,
    int? precoCentavos,
    int? quantidade,
  }) {
    return VendaItemModel(
      produtoId: produtoId ?? this.produtoId,
      nome: nome ?? this.nome,
      precoCentavos: precoCentavos ?? this.precoCentavos,
      quantidade: quantidade ?? this.quantidade,
    );
  }

  factory VendaItemModel.fromMap(Map<String, dynamic> map) {
    return VendaItemModel(
      produtoId: map['produtoId'] as String? ?? '',
      nome: map['nome'] as String? ?? '',
      precoCentavos:
          (map['precoCentavos'] as num?)?.toInt() ??
          _centavosFromLegacyValue(map['preco']),
      quantidade: (map['quantidade'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    'produtoId': produtoId,
    'nome': nome,
    'precoCentavos': precoCentavos,
    'quantidade': quantidade,
  };

  static int _centavosFromLegacyValue(dynamic valor) {
    if (valor == null) {
      return 0;
    }
    if (valor is num) {
      return (valor * 100).round();
    }
    return centavosFromInput(valor.toString());
  }
}

class VendaModel {
  const VendaModel({
    required this.id,
    required this.itens,
    required this.totalCentavos,
    this.criadoEm,
    this.atualizadoEm,
  });

  final String id;
  final List<VendaItemModel> itens;
  final int totalCentavos;
  final DateTime? criadoEm;
  final DateTime? atualizadoEm;

  double get totalReais => totalCentavos / 100;

  factory VendaModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return VendaModel.fromMap(doc.id, doc.data() ?? const <String, dynamic>{});
  }

  factory VendaModel.fromMap(String id, Map<String, dynamic> map) {
    final itensBrutos = map['itens'] as List<dynamic>? ?? const [];

    return VendaModel(
      id: id,
      itens: itensBrutos
          .whereType<Map<String, dynamic>>()
          .map(VendaItemModel.fromMap)
          .toList(),
      totalCentavos:
          (map['totalCentavos'] as num?)?.toInt() ??
          VendaItemModel._centavosFromLegacyValue(map['total']),
      criadoEm: (map['criadoEm'] as Timestamp?)?.toDate(),
      atualizadoEm: (map['atualizadoEm'] as Timestamp?)?.toDate(),
    );
  }

  static int calcularTotalCentavos(List<VendaItemModel> itens) {
    return itens.fold(0, (total, item) => total + item.subtotalCentavos);
  }

  static Map<String, int> calcularDiferencaEstoque({
    required List<VendaItemModel> antiga,
    required List<VendaItemModel> nova,
  }) {
    final diferencas = <String, int>{};

    for (final item in antiga) {
      diferencas.update(
        item.produtoId,
        (valor) => valor + item.quantidade,
        ifAbsent: () => item.quantidade,
      );
    }

    for (final item in nova) {
      diferencas.update(
        item.produtoId,
        (valor) => valor - item.quantidade,
        ifAbsent: () => -item.quantidade,
      );
    }

    diferencas.removeWhere((_, valor) => valor == 0);
    return diferencas;
  }
}
