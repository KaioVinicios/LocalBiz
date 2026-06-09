import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:localbiz/features/services/domain/models/agendamento_model.dart';

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

  CollectionReference _agendamentosRef(String negocioId, String servicoId) {
    return _firestore
        .collection('negocios')
        .doc(negocioId)
        .collection('servicos')
        .doc(servicoId)
        .collection('agendamentos');
  }

  @override
  Future<void> criarAgendamento(Map<String, dynamic> payload) async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) {
      throw StateError('Nenhum usuário autenticado para criar o agendamento.');
    }
    final servicoId = payload['servicoId'] as String?;
    if (servicoId == null || servicoId.isEmpty) {
      throw ArgumentError('servicoId ausente no payload.');
    }
    final negocioId = user.uid;
    debugPrint(
      '$_logTag add agendamentos negocioId=$negocioId servicoId=$servicoId',
    );
    try {
      final doc = await _agendamentosRef(negocioId, servicoId).add({
        ...payload,
        'negocioId': negocioId,
        'criado_por': user.email,
        'createdAt': FieldValue.serverTimestamp(),
      });
      debugPrint(
        '$_logTag criado negocios/$negocioId/servicos/$servicoId/agendamentos/${doc.id}',
      );
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
    final negocioId = _auth.currentUser?.uid ?? '';
    if (negocioId.isEmpty) return Stream.value(const []);
    debugPrint(
      '$_logTag listen negocios/$negocioId/servicos/$servicoId/agendamentos',
    );
    return _agendamentosRef(negocioId, servicoId)
        .snapshots()
        .map((snap) {
          debugPrint(
            '$_logTag snapshot listarPorServico servicoId=$servicoId docs=${snap.docs.length}',
          );
          return snap.docs
              .map(
                (d) => AgendamentoModel.fromMap(
                  d.id,
                  d.data() as Map<String, dynamic>,
                ),
              )
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
