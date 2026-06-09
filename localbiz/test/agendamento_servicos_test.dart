import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localbiz/features/services/models/agendamento_model.dart';
import 'package:localbiz/features/services/models/servico_model.dart';
import 'package:localbiz/features/services/presentation/screens/services_scheduling.dart';
import 'package:localbiz/features/services/repositories/agendamentos_repositories.dart';
import 'package:localbiz/features/services/repositories/servicos_repositories.dart';

void main() {
  testWidgets('agendamento carrega servicos no select de procedimento', (
    tester,
  ) async {
    final servicosRepository = _FakeServicosRepository(
      servicos: const [
        ServicoModel(
          id: 's1',
          nome: 'Escova',
          categoria: 'Serviços Capilares',
          preco: 80,
          icone: 'spa_outlined',
          ativo: true,
        ),
      ],
    );
    final agendamentosRepository = _FakeAgendamentosRepository();

    await tester.pumpWidget(
      MaterialApp(
        home: AgendamentoServicoScreen(
          servicosRepository: servicosRepository,
          agendamentosRepository: agendamentosRepository,
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Selecionar procedimento'), findsOneWidget);

    await tester.tap(find.byType(DropdownButton<ServicoModel>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Escova').last);
    await tester.pumpAndSettle();

    expect(find.text('Escova'), findsOneWidget);
    expect(find.text('R\$ 80,00'), findsOneWidget);
    expect(find.text('Serviços Capilares'), findsOneWidget);
  });
}

class _FakeServicosRepository implements ServicosRepositoryContract {
  const _FakeServicosRepository({required this.servicos});

  final List<ServicoModel> servicos;

  @override
  Future<ServicoModel?> buscarPorId(String id) async {
    for (final servico in servicos) {
      if (servico.id == id) {
        return servico;
      }
    }
    return null;
  }

  @override
  Future<ServicoModel> criar(ServicoModel servico) async => servico;

  @override
  Stream<List<ServicoModel>> listarAtivos() => Stream.value(servicos);
}

class _FakeAgendamentosRepository implements AgendamentosRepositoryContract {
  @override
  Future<void> criarAgendamento(Map<String, dynamic> payload) async {}

  @override
  Stream<List<AgendamentoModel>> listarPorServico(String servicoId) {
    return Stream.value(const []);
  }

  @override
  String referenciaServico(String servicoId) => servicoId;
}
