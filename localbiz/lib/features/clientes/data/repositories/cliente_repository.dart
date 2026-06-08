import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localbiz/features/clientes/domain/entities/cliente_model.dart';

class ClienteRepository {
  ClienteRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _colecao(String uid) =>
      _firestore.collection('negocios').doc(uid).collection('clientes');

  Stream<List<Cliente>> observar(String uid) {
    return _colecao(uid)
        .orderBy('nome')
        .snapshots()
        .map((snap) => snap.docs.map(Cliente.fromFirestore).toList());
  }

  Future<Cliente> criar(String uid, Cliente cliente) async {
    final ref = await _colecao(uid).add({
      ...cliente.toMap(),
      'criadoEm': FieldValue.serverTimestamp(),
      'atualizadoEm': FieldValue.serverTimestamp(),
    });
    cliente.id = ref.id;
    return cliente;
  }

  Future<void> atualizar(String uid, Cliente cliente) async {
    final id = cliente.id;
    if (id == null) {
      throw ArgumentError('Cliente sem id não pode ser atualizado.');
    }
    await _colecao(uid).doc(id).update({
      'nome': cliente.nome,
      'telefone': cliente.telefone,
      'email': cliente.email,
      'atualizadoEm': FieldValue.serverTimestamp(),
    });
  }

  Future<void> excluir(String uid, String clienteId) {
    return _colecao(uid).doc(clienteId).delete();
  }

  Future<void> registrarAtendimento(
    String uid,
    String clienteId,
    ClienteHistorico atendimento,
  ) {
    return _colecao(uid).doc(clienteId).update({
      'historico': FieldValue.arrayUnion([atendimento.toMap()]),
      'atualizadoEm': FieldValue.serverTimestamp(),
    });
  }
}
