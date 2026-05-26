import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localbiz/core/router/app_route.dart';
import 'package:localbiz/main.dart';

void main() {
  Future<void> abrirClientes(WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.pushNamed(AppRoute.clientes.path);
    await tester.pumpAndSettle();
  }

  Future<void> abrirProdutos(WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.pushNamed(AppRoute.produtos.path);
    await tester.pumpAndSettle();
  }

  testWidgets('abre tela de clientes', (tester) async {
    await abrirClientes(tester);

    expect(find.text('Clientes'), findsOneWidget);
    expect(find.text('Mariana Silva'), findsOneWidget);
  });

  testWidgets('cadastra novo cliente', (tester) async {
    await abrirClientes(tester);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(1), 'Bruno Lima');
    await tester.tap(find.text('Salvar Cliente'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'Bruno');
    await tester.pump();

    expect(find.text('Bruno Lima'), findsOneWidget);
  });

  testWidgets('filtra clientes na busca', (tester) async {
    await abrirClientes(tester);

    await tester.enterText(find.byType(TextField).first, 'Julian');
    await tester.pump();

    expect(find.text('Julian Torres'), findsOneWidget);
    expect(find.text('Mariana Silva'), findsNothing);

    await tester.enterText(find.byType(TextField).first, '9876543');
    await tester.pump();

    expect(find.text('Ana Patricia'), findsOneWidget);
    expect(find.text('Julian Torres'), findsNothing);
  });

  testWidgets('abre dados do cliente e volta para lista', (tester) async {
    await abrirClientes(tester);

    await tester.tap(find.text('Carlos Mendes'));
    await tester.pump();

    expect(find.text('Carlos Mendes'), findsOneWidget);
    expect(find.text('carlos@email.com'), findsOneWidget);
    expect(find.text('Histórico'), findsOneWidget);
    expect(find.text('Corte Masculino'), findsOneWidget);

    await tester.tap(find.text('VOLTAR'));
    await tester.pump();

    expect(find.text('Clientes'), findsOneWidget);
    expect(find.text('Mariana Silva'), findsOneWidget);
  });

  testWidgets('edita cliente', (tester) async {
    await abrirClientes(tester);

    await tester.tap(find.text('Mariana Silva'));
    await tester.pump();
    await tester.tap(find.byTooltip('Editar cliente'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'Mariana Costa');
    await tester.enterText(find.byType(TextField).at(1), '(79) 99999-0000');
    await tester.enterText(find.byType(TextField).at(2), 'costa@email.com');
    await tester.tap(find.text('Salvar Cliente'));
    await tester.pumpAndSettle();

    expect(find.text('Mariana Costa'), findsOneWidget);
    expect(find.text('(79) 99999-0000'), findsOneWidget);
    expect(find.text('costa@email.com'), findsOneWidget);

    await tester.tap(find.text('VOLTAR'));
    await tester.pump();

    expect(find.text('Mariana Costa'), findsOneWidget);
    expect(find.text('Mariana Silva'), findsNothing);
  });

  testWidgets('exclui cliente', (tester) async {
    await abrirClientes(tester);

    await tester.tap(find.text('Carlos Mendes'));
    await tester.pump();
    await tester.tap(find.byTooltip('Excluir cliente'));
    await tester.pumpAndSettle();

    expect(find.text('Excluir cliente'), findsOneWidget);
    expect(find.text('Deseja excluir Carlos Mendes?'), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, 'Excluir'));
    await tester.pumpAndSettle();

    expect(find.text('Clientes'), findsOneWidget);
    expect(find.text('Carlos Mendes'), findsNothing);
  });

  testWidgets('produtos: lista e busca', (tester) async {
    await abrirProdutos(tester);

    expect(find.text('Produtos'), findsWidgets);
    expect(find.text('Fini Salada de Frutas'), findsOneWidget);
    expect(find.text('Estoque: 48 unidades'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'Bebidas');
    await tester.pump();

    expect(find.text('Fini Salada de Frutas'), findsNothing);
    expect(find.text('Nenhum produto encontrado'), findsOneWidget);
  });

  testWidgets('produtos: cadastro e edicao', (tester) async {
    await abrirProdutos(tester);

    await tester.tap(find.byTooltip('Adicionar produto'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'Chocolate 70%');
    await tester.enterText(find.byType(TextField).at(1), 'R\$ 12,00');
    await tester.enterText(find.byType(TextField).at(2), '123456789');
    await tester.tap(find.text('Concluir'));
    await tester.pumpAndSettle();

    expect(find.text('Chocolate 70%'), findsOneWidget);
    expect(find.text('Estoque: 0 unidades'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'Fini');
    await tester.pump();
    await tester.tap(find.byTooltip('Editar produto'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'Fini Frutas Mix');
    await tester.enterText(find.byType(TextField).at(1), 'R\$ 9,90');
    await tester.tap(find.text('Concluir'));
    await tester.pumpAndSettle();

    expect(find.text('Fini Frutas Mix'), findsOneWidget);
    expect(find.text('R\$ 9,90'), findsOneWidget);
  });

  testWidgets('produtos: exclusao', (tester) async {
    await abrirProdutos(tester);

    await tester.tap(find.byTooltip('Excluir produto'));
    await tester.pumpAndSettle();

    expect(find.text('Excluir produto'), findsOneWidget);
    expect(find.text('Deseja excluir Fini Salada de Frutas?'), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, 'Excluir'));
    await tester.pumpAndSettle();

    expect(find.text('Fini Salada de Frutas'), findsNothing);
    expect(find.text('Nenhum produto encontrado'), findsOneWidget);
  });

  testWidgets('produtos: estoque', (tester) async {
    await abrirProdutos(tester);

    await tester.tap(find.byTooltip('Estoque do produto'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '7');
    await tester.tap(find.text('Concluir'));
    await tester.pumpAndSettle();

    expect(find.text('Estoque: 55 unidades'), findsOneWidget);

    await tester.tap(find.byTooltip('Estoque do produto'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Saída'));
    await tester.pump();
    await tester.enterText(find.byType(TextField).first, '10');
    await tester.tap(find.text('Concluir'));
    await tester.pumpAndSettle();

    expect(find.text('Estoque: 45 unidades'), findsOneWidget);
  });
}
