import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:localbiz/features/services/models/agendamento_model.dart';

abstract class AgendamentosRepositoryContract {
  Future<void> criarAgendamento(Map<String, dynamic> payload);

  String referenciaServico(String servicoId);

  Stream<List<AgendamentoModel>> listarPorServico(String servicoId);
}

class AgendamentosRepository implements AgendamentosRepositoryContract {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  static const _logTag = '[Firestore][agendamentos]';

  AgendamentosRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  @override
  Future<void> criarAgendamento(Map<String, dynamic> payload) async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) {
      throw StateError('Nenhum usuário autenticado para criar o agendamento.');
    }
    debugPrint('$_logTag add agendamentos user=${user.uid}');
    try {
      final doc = await _firestore.collection('agendamentos').add({
        ...payload,
        // Amarração dinâmica: vincula o agendamento ao negócio/usuário logado,
        // permitindo que os relatórios filtrem pelos dados do próprio negócio.
        'negocioId': user.uid,
        'criado_por': user.email,
        'createdAt': FieldValue.serverTimestamp(),
      });
      debugPrint('$_logTag criado agendamentos/${doc.id}');
    } catch (error, stackTrace) {
      debugPrint('$_logTag erro criarAgendamento: $error');
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  @override
  String referenciaServico(String servicoId) {
    return servicoId;
  }

  @override
  Stream<List<AgendamentoModel>> listarPorServico(String servicoId) {
    debugPrint('$_logTag listen agendamentos where servicoId == $servicoId');
    return _firestore
        .collection('agendamentos')
        .where('servicoId', isEqualTo: servicoId)
        .snapshots()
        .map((snap) {
          debugPrint(
            '$_logTag snapshot listarPorServico servicoId=$servicoId docs=${snap.docs.length}',
          );
          return snap.docs
              .map((d) => AgendamentoModel.fromMap(d.id, d.data()))
              .toList();
        })
        .handleError((Object error, StackTrace stackTrace) {
          debugPrint(
            '$_logTag erro listarPorServico servicoId=$servicoId: $error',
          );
          Error.throwWithStackTrace(error, stackTrace);
        });
  }
}
