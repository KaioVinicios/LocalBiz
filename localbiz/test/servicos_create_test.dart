import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localbiz/features/services/models/servico_model.dart';
import 'package:localbiz/features/services/presentation/screens/service_create_page.dart';
import 'package:localbiz/features/services/repositories/servicos_repositories.dart';

void main() {
  testWidgets('cadastro de servico salva item no repositorio', (tester) async {
    final repository = _FakeServicosRepository();

    await tester.pumpWidget(
      MaterialApp(home: ServiceCreatePage(repository: repository)),
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
    expect(repository.criados.single.nome, 'Escova');
    expect(repository.criados.single.categoria, 'Serviços Capilares');
    expect(repository.criados.single.preco, 80);
    expect(repository.criados.single.ativo, isTrue);
  });
}

class _FakeServicosRepository implements ServicosRepositoryContract {
  final criados = <ServicoModel>[];

  @override
  Future<ServicoModel?> buscarPorId(String id) async => null;

  @override
  Future<ServicoModel> criar(ServicoModel servico) async {
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
  Future<void> atualizar(ServicoModel servico) async {}

  @override
  Stream<List<ServicoModel>> listarAtivos() => Stream.value(const []);
}
