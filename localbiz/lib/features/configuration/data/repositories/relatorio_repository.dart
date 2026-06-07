import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localbiz/features/configuration/data/models/relatorio_model.dart';

class RelatorioRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference _relatoriosDoUsuario(String uid) =>
      _db.collection('usuarios').doc(uid).collection('relatorios');

  /// Agrega os agendamentos no período informado (datas ISO yyyy-MM-dd),
  /// calcula os totais, persiste o relatório em `usuarios/{uid}/relatorios`
  /// e devolve o modelo resultante para exibição na tela.
  Future<RelatorioModel> gerar({
    required String uid,
    required String tipo,
    required String dataInicio,
    required String dataFim,
    required String formato,
    required String destino,
  }) async {
    // Os agendamentos guardam `data` em ISO (yyyy-MM-dd), que ordena
    // lexicograficamente — então o intervalo funciona como string.
    final snap = await _db
        .collection('agendamentos')
        .where('data', isGreaterThanOrEqualTo: dataInicio)
        .where('data', isLessThanOrEqualTo: dataFim)
        .get();

    var quantidade = 0;
    var cancelados = 0;
    var valorTotal = 0.0;

    for (final doc in snap.docs) {
      final d = doc.data();
      final status = (d['status'] as String? ?? '').toLowerCase();
      final valor = (d['valor'] as num?)?.toDouble() ?? 0.0;
      quantidade++;
      if (status == 'cancelado') {
        cancelados++;
      } else {
        valorTotal += valor;
      }
    }

    final docRef = await _relatoriosDoUsuario(uid).add({
      'tipo': tipo,
      'dataInicio': dataInicio,
      'dataFim': dataFim,
      'formato': formato,
      'destino': destino,
      'quantidade': quantidade,
      'cancelados': cancelados,
      'valorTotal': valorTotal,
      'geradoEm': FieldValue.serverTimestamp(),
    });

    return RelatorioModel(
      id: docRef.id,
      tipo: tipo,
      dataInicio: dataInicio,
      dataFim: dataFim,
      formato: formato,
      destino: destino,
      quantidade: quantidade,
      cancelados: cancelados,
      valorTotal: valorTotal,
      geradoEm: DateTime.now(),
    );
  }

  /// Histórico de relatórios gerados pelo usuário, mais recentes primeiro.
  Stream<List<RelatorioModel>> historico(String uid) {
    return _relatoriosDoUsuario(uid)
        .orderBy('geradoEm', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(RelatorioModel.fromFirestore).toList());
  }
}
