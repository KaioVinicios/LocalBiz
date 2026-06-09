import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localbiz/core/router/app_route.dart';
import 'package:localbiz/features/services/models/agendamento_model.dart';
import 'package:localbiz/features/services/models/servico_model.dart';
import 'package:localbiz/features/services/presentation/screens/service_edit_page.dart';
import 'package:localbiz/features/services/presentation/screens/services_details.dart';
import 'package:localbiz/features/services/repositories/agendamentos_repositories.dart';
import 'package:localbiz/features/services/repositories/servicos_repositories.dart';

void main() {
  const servico = ServicoModel(
    id: 's1',
    nome: 'Corte',
    categoria: 'Serviços Capilares',
    preco: 70,
    icone: 'spa_outlined',
    ativo: true,
  );

  testWidgets('detalhe abre tela de edicao pelo icone', (tester) async {
    final servicosRepository = _FakeServicosRepository(servico: servico);

    await tester.pumpWidget(
      MaterialApp(
        routes: {
          AppRoute.serviceEdit.path: (context) {
            return ServiceEditPage(
              repository: servicosRepository,
              servico:
                  ModalRoute.of(context)!.settings.arguments! as ServicoModel,
            );
          },
        },
        home: DetalheServicoScreen(
          servicoId: 's1',
          servicosRepository: servicosRepository,
          agendamentosRepository: _FakeAgendamentosRepository(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();

    expect(find.text('Editar Serviço'), findsOneWidget);
    expect(find.text('Corte'), findsOneWidget);
    expect(find.text('R\$ 70,00'), findsOneWidget);
  });

  testWidgets('edicao de servico atualiza dados no repositorio', (
    tester,
  ) async {
    final servicosRepository = _FakeServicosRepository(servico: servico);

    await tester.pumpWidget(
      MaterialApp(
        home: ServiceEditPage(repository: servicosRepository, servico: servico),
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'Corte Premium');
    await tester.enterText(find.byType(TextFormField).at(1), '9000');
    await tester.pump();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Concluir'));
    await tester.pumpAndSettle();

    expect(servicosRepository.atualizados, hasLength(1));
    expect(servicosRepository.atualizados.single.id, 's1');
    expect(servicosRepository.atualizados.single.nome, 'Corte Premium');
    expect(
      servicosRepository.atualizados.single.categoria,
      'Serviços Capilares',
    );
    expect(servicosRepository.atualizados.single.preco, 90);
    expect(servicosRepository.atualizados.single.ativo, isTrue);
  });
}

class _FakeServicosRepository implements ServicosRepositoryContract {
  _FakeServicosRepository({required this.servico});

  final ServicoModel servico;
  final atualizados = <ServicoModel>[];

  @override
  Future<ServicoModel?> buscarPorId(String id) async => servico;

  @override
  Future<ServicoModel> criar(ServicoModel servico) async => servico;

  @override
  Future<void> atualizar(ServicoModel servico) async {
    atualizados.add(servico);
  }

  @override
  Stream<List<ServicoModel>> listarAtivos() => Stream.value([servico]);
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
