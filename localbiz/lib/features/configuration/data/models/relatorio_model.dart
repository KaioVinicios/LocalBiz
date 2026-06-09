import 'package:cloud_firestore/cloud_firestore.dart';

/// Relatório gerado e arquivado em `usuarios/{uid}/relatorios`.
/// Guarda os filtros usados e os totais apurados no período, conforme o tipo.
class RelatorioModel {
  final String id;
  final String tipo; // Financeiro | Vendas | Agendamentos
  final String dataInicio; // ISO yyyy-MM-dd
  final String dataFim; // ISO yyyy-MM-dd
  final String formato; // PDF | CSV | XLSX
  final String destino; // Email | Whatsapp

  // Vendas
  final int quantidade; // nº de vendas no período
  final double valorTotal; // faturamento total (produtos + serviços)

  // Financeiro
  final double valorProdutos; // arrecadado em produtos (vendas)
  final double valorServicos; // arrecadado em serviços (agendamentos)

  // Agendamentos
  final int finalizados; // agendamentos cuja data já passou
  final int emAberto; // agendamentos cuja data ainda está por vir

  final DateTime? geradoEm;

  const RelatorioModel({
    required this.id,
    required this.tipo,
    required this.dataInicio,
    required this.dataFim,
    required this.formato,
    required this.destino,
    this.quantidade = 0,
    this.valorTotal = 0,
    this.valorProdutos = 0,
    this.valorServicos = 0,
    this.finalizados = 0,
    this.emAberto = 0,
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
      valorTotal: (d['valorTotal'] as num?)?.toDouble() ?? 0.0,
      valorProdutos: (d['valorProdutos'] as num?)?.toDouble() ?? 0.0,
      valorServicos: (d['valorServicos'] as num?)?.toDouble() ?? 0.0,
      finalizados: (d['finalizados'] as num?)?.toInt() ?? 0,
      emAberto: (d['emAberto'] as num?)?.toInt() ?? 0,
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
    'valorTotal': valorTotal,
    'valorProdutos': valorProdutos,
    'valorServicos': valorServicos,
    'finalizados': finalizados,
    'emAberto': emAberto,
    'geradoEm': FieldValue.serverTimestamp(),
  };
}
