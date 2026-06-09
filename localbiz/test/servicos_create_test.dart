import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localbiz/features/services/models/servico_model.dart';
import 'package:localbiz/features/services/presentation/screens/service_create_page.dart';
import 'package:localbiz/features/services/repositories/servicos_repositories.dart';

void main() {
  testWidgets('cadastro de servico salva item no repositorio', (tester) async {
    final repository = _FakeServicosRepository();

    await tester.pumpWidget(
      MaterialApp(
        home: ServiceCreatePage(repository: repository, negocioId: 'negocio-1'),
      ),
    );

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Serviços Capilares').last);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'Escova');
    await tester.enterText(find.byType(TextFormField).at(1), '8000');
    await tester.pump();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Concluir'));
    await tester.pumpAndSettle();

    expect(repository.criados, hasLength(1));
    expect(repository.negociosCriados.single, 'negocio-1');
    expect(repository.criados.single.nome, 'Escova');
    expect(repository.criados.single.categoria, 'Serviços Capilares');
    expect(repository.criados.single.preco, 80);
    expect(repository.criados.single.ativo, isTrue);
  });
}

class _FakeServicosRepository implements ServicosRepositoryContract {
  final criados = <ServicoModel>[];
  final negociosCriados = <String>[];

  @override
  Future<ServicoModel?> buscarPorId(String negocioId, String id) async => null;

  @override
  Future<ServicoModel> criar(String negocioId, ServicoModel servico) async {
    negociosCriados.add(negocioId);
    criados.add(servico);
    return ServicoModel(
      id: 's${criados.length}',
      nome: servico.nome,
      categoria: servico.categoria,
      preco: servico.preco,
      icone: servico.icone,
      ativo: servico.ativo,
    );
  }

  @override
  Future<void> atualizar(String negocioId, ServicoModel servico) async {}

  @override
  Stream<List<ServicoModel>> listarAtivos(String negocioId) {
    return Stream.value(const []);
  }
}
