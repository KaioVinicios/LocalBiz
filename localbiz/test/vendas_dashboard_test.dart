import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localbiz/features/services/data/dashboard_repository.dart';
import 'package:localbiz/features/services/domain/dashboard_summary.dart';
import 'package:localbiz/features/services/presentation/screens/dashboard_page.dart';
import 'package:localbiz/features/vendas/models/venda_model.dart';
import 'package:localbiz/features/vendas/models/venda_produto_model.dart';
import 'package:localbiz/features/vendas/presentation/screens/venda_historico_page.dart';
import 'package:localbiz/features/vendas/presentation/screens/venda_page.dart';
import 'package:localbiz/features/vendas/repositories/venda_repository.dart';

void main() {
  group('vendas domain', () {
    test('parseia preco numerico e texto em real brasileiro', () {
      expect(VendaProdutoModel.parsePrecoCentavos(12), 1200);
      expect(VendaProdutoModel.parsePrecoCentavos(12.9), 1290);
      expect(VendaProdutoModel.parsePrecoCentavos('R\$ 1.234,56'), 123456);
      expect(VendaProdutoModel.parsePrecoCentavos('9,90'), 990);
      expect(VendaProdutoModel.parsePrecoCentavos(''), 0);
    });

    test('calcula total e diferenca de estoque ao editar venda', () {
      final antiga = [
        const VendaItemModel(
          produtoId: 'p1',
          nome: 'Chocolate',
          precoCentavos: 1000,
          quantidade: 2,
        ),
        const VendaItemModel(
          produtoId: 'p2',
          nome: 'Suco',
          precoCentavos: 500,
          quantidade: 1,
        ),
      ];
      final nova = [
        const VendaItemModel(
          produtoId: 'p1',
          nome: 'Chocolate',
          precoCentavos: 1000,
          quantidade: 1,
        ),
        const VendaItemModel(
          produtoId: 'p3',
          nome: 'Agua',
          precoCentavos: 300,
          quantidade: 4,
        ),
      ];

      expect(VendaModel.calcularTotalCentavos(nova), 2200);
      expect(VendaModel.calcularDiferencaEstoque(antiga: antiga, nova: nova), {
        'p1': 1,
        'p2': 1,
        'p3': -4,
      });
    });
  });

  testWidgets('nova venda cria registro com itens do carrinho', (tester) async {
    final repository = _FakeVendaRepository(
      produtos: [
        VendaProdutoModel(
          id: 'p1',
          nome: 'Chocolate',
          precoCentavos: 990,
          estoqueAtual: 8,
          negocioId: 'negocio-1',
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: VendaPage(repository: repository, negocioId: 'negocio-1'),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('+ Adicionar'));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.add).last);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Cobrar'));
    await tester.pumpAndSettle();

    expect(repository.criadas, hasLength(1));
    expect(repository.criadas.single.negocioId, 'negocio-1');
    expect(repository.criadas.single.itens.single.produtoId, 'p1');
    expect(repository.criadas.single.itens.single.quantidade, 1);
    expect(find.text('Venda Finalizada!'), findsOneWidget);
  });

  testWidgets('historico abre edicao e salva venda existente', (tester) async {
    final venda = VendaModel(
      id: 'v1',
      itens: const [
        VendaItemModel(
          produtoId: 'p1',
          nome: 'Chocolate',
          precoCentavos: 990,
          quantidade: 1,
        ),
      ],
      totalCentavos: 990,
      criadoEm: DateTime(2026, 6, 8, 10),
    );
    final repository = _FakeVendaRepository(
      produtos: [
        VendaProdutoModel(
          id: 'p1',
          nome: 'Chocolate',
          precoCentavos: 990,
          estoqueAtual: 8,
          negocioId: 'negocio-1',
        ),
      ],
      vendas: [venda],
    );

    await tester.pumpWidget(
      MaterialApp(
        routes: {
          '/editar': (context) => VendaPage(
            repository: repository,
            negocioId: 'negocio-1',
            vendaInicial:
                ModalRoute.of(context)!.settings.arguments! as VendaModel,
          ),
        },
        home: VendaHistoricoPage(
          repository: repository,
          negocioId: 'negocio-1',
          editRoutePath: '/editar',
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Chocolate').first);
    await tester.pumpAndSettle();
    expect(find.text('Editar Venda'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add).last);
    await tester.pump();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Salvar'));
    await tester.pumpAndSettle();

    expect(repository.atualizadas, hasLength(1));
    expect(repository.atualizadas.single.vendaId, 'v1');
    expect(repository.atualizadas.single.itens.single.quantidade, 2);
  });

  testWidgets('dashboard renderiza resumo de vendas e estoque baixo', (
    tester,
  ) async {
    final repository = _FakeDashboardRepository(
      resumo: const DashboardResumoVendas(
        faturamentoHoje: 120.5,
        vendasHoje: 3,
        faturamentoOntem: 100,
      ),
      estoque: const [
        ProdutoEstoqueBaixo(id: 'p1', nome: 'Chocolate', estoqueAtual: 2),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: DashboardPage(repository: repository, usuarioId: 'negocio-1'),
      ),
    );
    await tester.pump();

    expect(find.text('Resumo de Hoje'), findsOneWidget);
    expect(find.text('R\$ 120,50'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('+20% vs. ontem'), findsOneWidget);
    expect(find.text('Chocolate'), findsOneWidget);
    expect(find.text('2 un.'), findsOneWidget);
  });
}

class _VendaCriada {
  const _VendaCriada({required this.negocioId, required this.itens});

  final String negocioId;
  final List<VendaItemModel> itens;
}

class _VendaAtualizada {
  const _VendaAtualizada({
    required this.negocioId,
    required this.vendaId,
    required this.itens,
  });

  final String negocioId;
  final String vendaId;
  final List<VendaItemModel> itens;
}

class _FakeVendaRepository implements VendaRepositoryContract {
  _FakeVendaRepository({required this.produtos, this.vendas = const []});

  final List<VendaProdutoModel> produtos;
  final List<VendaModel> vendas;
  final criadas = <_VendaCriada>[];
  final atualizadas = <_VendaAtualizada>[];

  @override
  Stream<List<VendaProdutoModel>> listarProdutos(String negocioId) {
    return Stream.value(produtos);
  }

  @override
  Stream<List<VendaModel>> observarVendas(String negocioId) {
    return Stream.value(vendas);
  }

  @override
  Future<void> criarVenda({
    required String negocioId,
    required List<VendaItemModel> itens,
  }) async {
    criadas.add(_VendaCriada(negocioId: negocioId, itens: List.of(itens)));
  }

  @override
  Future<void> atualizarVenda({
    required String negocioId,
    required String vendaId,
    required List<VendaItemModel> itens,
  }) async {
    atualizadas.add(
      _VendaAtualizada(
        negocioId: negocioId,
        vendaId: vendaId,
        itens: List.of(itens),
      ),
    );
  }
}

class _FakeDashboardRepository implements DashboardRepositoryContract {
  const _FakeDashboardRepository({required this.resumo, required this.estoque});

  final DashboardResumoVendas resumo;
  final List<ProdutoEstoqueBaixo> estoque;

  @override
  Stream<DashboardResumoVendas> observarResumoVendasHoje(String uid) {
    return Stream.value(resumo);
  }

  @override
  Stream<List<ProdutoEstoqueBaixo>> observarEstoqueBaixo(
    String uid, {
    int limite = 5,
  }) {
    return Stream.value(estoque);
  }
}
