import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localbiz/features/services/models/servico_model.dart';

class ServicosRepository {
  final FirebaseFirestore _firestore;

  ServicosRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<ServicoModel>> listarAtivos() {
    return _firestore
        .collection('servicos')
        .where('ativo', isEqualTo: true)
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
}