import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localbiz/features/services/domain/dashboard_summary.dart';

abstract interface class DashboardRepositoryContract {
  Stream<DashboardResumoVendas> observarResumoVendasHoje(String uid);

  Stream<List<ProdutoEstoqueBaixo>> observarEstoqueBaixo(
    String uid, {
    int limite = 5,
  });
}

class DashboardRepository implements DashboardRepositoryContract {
  DashboardRepository({
    FirebaseFirestore? firestore,
    DateTime Function()? clock,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _clock = clock ?? DateTime.now;

  final FirebaseFirestore _firestore;
  final DateTime Function() _clock;

  CollectionReference<Map<String, dynamic>> _produtos(String uid) =>
      _firestore.collection('negocios').doc(uid).collection('produtos');

  CollectionReference<Map<String, dynamic>> _vendas(String uid) =>
      _firestore.collection('negocios').doc(uid).collection('vendas');

  @override
  Stream<DashboardResumoVendas> observarResumoVendasHoje(String uid) {
    final hoje = inicioDoDia(_clock());
    final ontem = hoje.subtract(const Duration(days: 1));
    final amanha = hoje.add(const Duration(days: 1));

    return _vendas(uid)
        .where('criadoEm', isGreaterThanOrEqualTo: Timestamp.fromDate(ontem))
        .where('criadoEm', isLessThan: Timestamp.fromDate(amanha))
        .snapshots()
        .map((snap) {
          var faturamentoHoje = 0.0;
          var vendasHoje = 0;
          var faturamentoOntem = 0.0;

          for (final doc in snap.docs) {
            final data = doc.data();
            final criadoEm = (data['criadoEm'] as Timestamp?)?.toDate();
            final totalCentavos = (data['totalCentavos'] as num?)?.toInt();
            final total = totalCentavos != null
                ? totalCentavos / 100
                : (data['total'] as num?)?.toDouble() ?? 0;

            if (criadoEm == null) {
              continue;
            }

            if (mesmoDia(criadoEm, hoje)) {
              faturamentoHoje += total;
              vendasHoje++;
            } else if (mesmoDia(criadoEm, ontem)) {
              faturamentoOntem += total;
            }
          }

          return DashboardResumoVendas(
            faturamentoHoje: faturamentoHoje,
            vendasHoje: vendasHoje,
            faturamentoOntem: faturamentoOntem,
          );
        });
  }

  @override
  Stream<List<ProdutoEstoqueBaixo>> observarEstoqueBaixo(
    String uid, {
    int limite = 5,
  }) {
    return _produtos(uid)
        .where('estoqueAtual', isLessThanOrEqualTo: limite)
        .orderBy('estoqueAtual')
        .limit(3)
        .snapshots()
        .map(
          (snap) => snap.docs.map((doc) {
            final data = doc.data();
            return ProdutoEstoqueBaixo(
              id: doc.id,
              nome: data['nome'] as String? ?? '',
              estoqueAtual: (data['estoqueAtual'] as num?)?.toInt() ?? 0,
            );
          }).toList(),
        );
  }
}
