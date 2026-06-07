import 'package:cloud_firestore/cloud_firestore.dart';

/// Relatório gerado e arquivado em `usuarios/{uid}/relatorios`.
/// Guarda os filtros usados e os totais apurados no período.
class RelatorioModel {
  final String id;
  final String tipo; // Financeiro | Movimentação | Vendas
  final String dataInicio; // ISO yyyy-MM-dd
  final String dataFim; // ISO yyyy-MM-dd
  final String formato; // PDF | CSV | XLSX
  final String destino; // Email | Whatsapp
  final int quantidade; // agendamentos no período
  final int cancelados;
  final double valorTotal; // soma dos valores (exceto cancelados)
  final DateTime? geradoEm;

  const RelatorioModel({
    required this.id,
    required this.tipo,
    required this.dataInicio,
    required this.dataFim,
    required this.formato,
    required this.destino,
    required this.quantidade,
    required this.cancelados,
    required this.valorTotal,
    this.geradoEm,
  });

  factory RelatorioModel.fromFirestore(DocumentSnapshot doc) {
    final d = (doc.data() as Map<String, dynamic>?) ?? {};
    return RelatorioModel(
      id: doc.id,
      tipo: d['tipo'] as String? ?? '',
      dataInicio: d['dataInicio'] as String? ?? '',
      dataFim: d['dataFim'] as String? ?? '',
      formato: d['formato'] as String? ?? '',
      destino: d['destino'] as String? ?? '',
      quantidade: (d['quantidade'] as num?)?.toInt() ?? 0,
      cancelados: (d['cancelados'] as num?)?.toInt() ?? 0,
      valorTotal: (d['valorTotal'] as num?)?.toDouble() ?? 0.0,
      geradoEm: (d['geradoEm'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
    'tipo': tipo,
    'dataInicio': dataInicio,
    'dataFim': dataFim,
    'formato': formato,
    'destino': destino,
    'quantidade': quantidade,
    'cancelados': cancelados,
    'valorTotal': valorTotal,
    'geradoEm': FieldValue.serverTimestamp(),
  };
}
