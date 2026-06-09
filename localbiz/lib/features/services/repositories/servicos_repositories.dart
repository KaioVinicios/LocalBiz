import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:localbiz/features/services/models/servico_model.dart';

class ServicosRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ServicosRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  Stream<List<ServicoModel>> listarAtivos() {
    final uid = _auth.currentUser?.uid;

    return _firestore
        .collection('servicos')
        .where('ativo', isEqualTo: true)
        .where('negocioId', isEqualTo: uid) // <- filtro por negócio
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => ServicoModel.fromMap(d.id, d.data()))
            .toList());
  }

  Future<ServicoModel?> buscarPorId(String id) async {
    final doc = await _firestore.collection('servicos').doc(id).get();
    if (!doc.exists) return null;
    return ServicoModel.fromMap(doc.id, doc.data()!);
  }

  Future<void> criar(ServicoModel servico) async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('Nenhum usuário autenticado.');

    await _firestore.collection('servicos').add({
      ...servico.toMap(),
      'negocioId': user.uid, 
      'criado_por': user.email, 
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}