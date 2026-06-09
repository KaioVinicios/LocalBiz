import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:localbiz/features/services/models/agendamento_model.dart';

class AgendamentosRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  AgendamentosRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  Future<void> criarAgendamento(Map<String, dynamic> payload) async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) {
      throw StateError('Nenhum usuário autenticado para criar o agendamento.');
    }
    await _firestore.collection('agendamentos').add({
      ...payload,
      // Amarração dinâmica: vincula o agendamento ao negócio/usuário logado,
      // permitindo que os relatórios filtrem pelos dados do próprio negócio.
      'negocioId': user.uid,
      'criado_por': user.email,
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
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => AgendamentoModel.fromMap(d.id, d.data()))
              .toList(),
        );
  }
}