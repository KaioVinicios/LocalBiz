import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/agendamento_model.dart';

class AgendamentosRepository {
  final FirebaseFirestore _firestore;

  AgendamentosRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> criarAgendamento(Map<String, dynamic> payload) async {
    await _firestore.collection('agendamentos').add({
      ...payload,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  String referenciaServico(String servicoId) {
    return servicoId;
  }

  Stream<List<AgendamentoModel>> listarPorServico(String servicoId) {
    return _firestore
        .collection('agendamentos')
        .where('servicoId', isEqualTo: servicoId)
        .orderBy('data')
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => AgendamentoModel.fromMap(d.id, d.data()))
              .toList(),
        );
  }
}
