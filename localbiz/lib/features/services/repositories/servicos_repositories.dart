import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:localbiz/features/services/models/servico_model.dart';

abstract class ServicosRepositoryContract {
  Stream<List<ServicoModel>> listarAtivos();

  Future<ServicoModel?> buscarPorId(String id);

  Future<ServicoModel> criar(ServicoModel servico);

  Future<void> atualizar(ServicoModel servico);
}

class ServicosRepository implements ServicosRepositoryContract {
  final FirebaseFirestore _firestore;
  static const _logTag = '[Firestore][servicos]';

  ServicosRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<ServicoModel>> listarAtivos() {
    debugPrint('$_logTag listen servicos where ativo == true');
    return _firestore
        .collection('servicos')
        .where('ativo', isEqualTo: true)
        .snapshots()
        .map((snap) {
          debugPrint('$_logTag snapshot listarAtivos docs=${snap.docs.length}');
          return snap.docs
              .map((d) => ServicoModel.fromMap(d.id, d.data()))
              .toList();
        })
        .handleError((Object error, StackTrace stackTrace) {
          debugPrint('$_logTag erro listarAtivos: $error');
          Error.throwWithStackTrace(error, stackTrace);
        });
  }

  @override
  Future<ServicoModel?> buscarPorId(String id) async {
    debugPrint('$_logTag get servicos/$id');
    try {
      final doc = await _firestore.collection('servicos').doc(id).get();
      debugPrint('$_logTag resultado buscarPorId id=$id exists=${doc.exists}');
      if (!doc.exists) return null;
      return ServicoModel.fromMap(doc.id, doc.data()!);
    } catch (error, stackTrace) {
      debugPrint('$_logTag erro buscarPorId id=$id: $error');
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  @override
  Future<ServicoModel> criar(ServicoModel servico) async {
    debugPrint('$_logTag add servicos nome=${servico.nome}');
    try {
      final doc = await _firestore.collection('servicos').add({
        ...servico.toMap(),
        'criadoEm': FieldValue.serverTimestamp(),
        'atualizadoEm': FieldValue.serverTimestamp(),
      });
      debugPrint('$_logTag criado servicos/${doc.id}');
      return ServicoModel(
        id: doc.id,
        nome: servico.nome,
        categoria: servico.categoria,
        preco: servico.preco,
        icone: servico.icone,
        ativo: servico.ativo,
      );
    } catch (error, stackTrace) {
      debugPrint('$_logTag erro criar: $error');
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  @override
  Future<void> atualizar(ServicoModel servico) async {
    if (servico.id.isEmpty) {
      throw ArgumentError('Serviço sem id não pode ser atualizado.');
    }

    debugPrint('$_logTag update servicos/${servico.id}');
    try {
      await _firestore.collection('servicos').doc(servico.id).update({
        ...servico.toMap(),
        'atualizadoEm': FieldValue.serverTimestamp(),
      });
      debugPrint('$_logTag atualizado servicos/${servico.id}');
    } catch (error, stackTrace) {
      debugPrint('$_logTag erro atualizar id=${servico.id}: $error');
      Error.throwWithStackTrace(error, stackTrace);
    }
  }
}
