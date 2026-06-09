import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:localbiz/features/configuration/data/models/relatorio_model.dart';

class RelatorioRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference _relatoriosDoUsuario(String uid) =>
      _db.collection('usuarios').doc(uid).collection('relatorios');

  /// Converte uma data ISO (`yyyy-MM-dd`) ou BR (`dd/MM/yyyy`) para `DateTime`
  /// na meia-noite local. Usado para os limites do período do relatório.
  DateTime? _parseData(String data) {
    final texto = data.trim();
    if (texto.isEmpty) return null;
    final iso = DateTime.tryParse(texto);
    if (iso != null) return DateTime(iso.year, iso.month, iso.day);
    final partes = texto.split('/');
    if (partes.length == 3) {
      final dia = int.tryParse(partes[0]);
      final mes = int.tryParse(partes[1]);
      final ano = int.tryParse(partes[2]);
      if (dia != null && mes != null && ano != null) {
        return DateTime(ano, mes, dia);
      }
    }
    return null;
  }

  /// Gera o relatório do período conforme o `tipo`, persiste em
  /// `usuarios/{uid}/relatorios` e devolve o modelo para exibição na tela.
  ///
  /// - **Vendas**: nº de vendas e faturamento (de `negocios/{uid}/vendas`).
  /// - **Financeiro**: arrecadado em produtos (vendas) e em serviços
  ///   (agendamentos do negócio), separados e somados.
  /// - **Agendamentos**: quantos já foram finalizados (data passada) e quantos
  ///   estão em aberto (data futura) no período.
  Future<RelatorioModel> gerar({
    required String uid,
    required String tipo,
    required String dataInicio,
    required String dataFim,
    required String formato,
    required String destino,
  }) async {
    final inicio = _parseData(dataInicio);
    final fim = _parseData(dataFim);
    // Limite superior exclusivo: cobre o dia de fim por inteiro (até 23:59:59).
    final fimExclusivo = fim?.add(const Duration(days: 1));

    var quantidade = 0;
    var valorProdutos = 0.0;
    var valorServicos = 0.0;
    var finalizados = 0;
    var emAberto = 0;

    switch (tipo) {
      case 'Vendas':
        final (qtd, total) = await _agregarVendas(uid, inicio, fimExclusivo);
        quantidade = qtd;
        valorProdutos = total;
      case 'Financeiro':
        final (_, total) = await _agregarVendas(uid, inicio, fimExclusivo);
        valorProdutos = total;
        valorServicos = await _somarServicos(uid, inicio, fim);
      case 'Agendamentos':
        final (fin, abertos) = await _contarAgendamentos(uid, inicio, fim);
        finalizados = fin;
        emAberto = abertos;
        quantidade = fin + abertos;
    }

    final valorTotal = valorProdutos + valorServicos;

    final dados = <String, dynamic>{
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
      // Amarração dinâmica: vincula o relatório ao usuário do Firebase Auth.
      'criado_por': _auth.currentUser?.email,
      'geradoEm': FieldValue.serverTimestamp(),
    };
    final docRef = await _relatoriosDoUsuario(uid).add(dados);

    return RelatorioModel(
      id: docRef.id,
      tipo: tipo,
      dataInicio: dataInicio,
      dataFim: dataFim,
      formato: formato,
      destino: destino,
      quantidade: quantidade,
      valorTotal: valorTotal,
      valorProdutos: valorProdutos,
      valorServicos: valorServicos,
      finalizados: finalizados,
      emAberto: emAberto,
      geradoEm: DateTime.now(),
    );
  }

  /// Soma as vendas do usuário no período (filtra por `criadoEm`).
  /// Retorna `(quantidade de vendas, faturamento em reais)`.
  Future<(int, double)> _agregarVendas(
    String uid,
    DateTime? inicio,
    DateTime? fimExclusivo,
  ) async {
    final snap = await _db
        .collection('negocios')
        .doc(uid)
        .collection('vendas')
        .get();

    var quantidade = 0;
    var totalCentavos = 0;
    for (final doc in snap.docs) {
      final d = doc.data();
      final criadoEm = (d['criadoEm'] as Timestamp?)?.toDate();
      if (criadoEm == null) continue;
      if (inicio != null && criadoEm.isBefore(inicio)) continue;
      if (fimExclusivo != null && !criadoEm.isBefore(fimExclusivo)) continue;
      quantidade++;
      totalCentavos += (d['totalCentavos'] as num?)?.toInt() ?? 0;
    }
    return (quantidade, totalCentavos / 100.0);
  }

  /// Soma o arrecadado em serviços: agendamentos do negócio no período
  /// (filtra por `data`), desconsiderando cancelados. Retorna o total em reais.
  Future<double> _somarServicos(
    String uid,
    DateTime? inicio,
    DateTime? fim,
  ) async {
    final snap = await _agendamentosDoNegocio(uid);
    var total = 0.0;
    for (final doc in snap.docs) {
      final d = doc.data();
      final status = (d['status'] as String? ?? '').toLowerCase();
      if (status == 'cancelado') continue;
      final data = _parseData(d['data'] as String? ?? '');
      if (data == null) continue;
      if (inicio != null && data.isBefore(inicio)) continue;
      if (fim != null && data.isAfter(fim)) continue;
      total += (d['valor'] as num?)?.toDouble() ?? 0.0;
    }
    return total;
  }

  /// Conta agendamentos do negócio no período, classificando pela data:
  /// finalizados (data já passou) x em aberto (data ainda por vir).
  Future<(int, int)> _contarAgendamentos(
    String uid,
    DateTime? inicio,
    DateTime? fim,
  ) async {
    final agora = DateTime.now();
    final hoje = DateTime(agora.year, agora.month, agora.day);
    final snap = await _agendamentosDoNegocio(uid);

    var finalizados = 0;
    var emAberto = 0;
    for (final doc in snap.docs) {
      final d = doc.data();
      final status = (d['status'] as String? ?? '').toLowerCase();
      if (status == 'cancelado') continue;
      final data = _parseData(d['data'] as String? ?? '');
      if (data == null) continue;
      if (inicio != null && data.isBefore(inicio)) continue;
      if (fim != null && data.isAfter(fim)) continue;
      if (data.isBefore(hoje)) {
        finalizados++;
      } else {
        emAberto++;
      }
    }
    return (finalizados, emAberto);
  }

  /// Agendamentos vinculados ao negócio logado (`negocioId == uid`).
  Future<QuerySnapshot<Map<String, dynamic>>> _agendamentosDoNegocio(
    String uid,
  ) {
    return _db
        .collection('agendamentos')
        .where('negocioId', isEqualTo: uid)
        .get();
  }

  /// Histórico de relatórios gerados pelo usuário, mais recentes primeiro.
  Stream<List<RelatorioModel>> historico(String uid) {
    return _relatoriosDoUsuario(uid)
        .orderBy('geradoEm', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(RelatorioModel.fromFirestore).toList());
  }
}
