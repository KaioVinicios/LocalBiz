import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localbiz/core/router/app_route.dart';
import 'package:localbiz/core/ui/nav_bar_button.dart';
import 'package:localbiz/features/clientes/presentation/widgets/cliente_list_item.dart';
import 'package:localbiz/features/produtos/presentation/widgets/produto_list_item.dart';
import 'package:localbiz/main.dart';

void main() {
  void configurarViewport(WidgetTester tester, Size size) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<void> abrirClientes(WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    tester.takeException();

    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.pushNamed(AppRoute.clientes.path);
    await tester.pumpAndSettle();
  }

  Future<void> abrirProdutos(WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    tester.takeException();

    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.pushNamed(AppRoute.produtos.path);
    await tester.pumpAndSettle();
  }

  Future<void> abrirConfiguracoes(WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    tester.takeException();

    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.pushNamed(AppRoute.configuration.path);
    await tester.pumpAndSettle();
  }

  Future<void> entrarNoApp(WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.widgetWithText(ElevatedButton, 'Entrar'));
    await tester.pumpAndSettle();
  }

  testWidgets('app inicia no login', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Entrar'), findsWidgets);
    expect(
      find.text('Bem-vindo de volta ao seu comércio local'),
      findsOneWidget,
    );
  });

  testWidgets('login funciona no web', (tester) async {
    configurarViewport(tester, const Size(1200, 900));
    await tester.pumpWidget(const MyApp());

    final campoSize = tester.getSize(find.byType(TextField).first);
    final botaoSize = tester.getSize(
      find.widgetWithText(ElevatedButton, 'Entrar'),
    );

    expect(campoSize.width, greaterThan(600));
    expect(botaoSize.width, greaterThan(600));
    expect(tester.takeException(), isNull);
  });

  testWidgets('cadastro funciona no web', (tester) async {
    configurarViewport(tester, const Size(1200, 900));
    await tester.pumpWidget(const MyApp());

    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.pushNamed(AppRoute.register.path);
    await tester.pumpAndSettle();

    final campoSize = tester.getSize(find.byType(TextField).first);
    final botaoSize = tester.getSize(
      find.widgetWithText(ElevatedButton, 'Criar Conta'),
    );

    expect(campoSize.width, greaterThan(600));
    expect(botaoSize.width, greaterThan(600));
    expect(tester.takeException(), isNull);
  });

  testWidgets('login e cadastro funcionam no mobile', (tester) async {
    configurarViewport(tester, const Size(390, 844));
    await tester.pumpWidget(const MyApp());

    expect(find.text('Entrar'), findsWidgets);
    expect(tester.takeException(), isNull);

    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.pushNamed(AppRoute.register.path);
    await tester.pumpAndSettle();

    expect(find.text('Crie sua conta\nno LocalBiz'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('login mockado abre dashboard', (tester) async {
    await entrarNoApp(tester);

    expect(find.text('Resumo de Hoje'), findsOneWidget);
    expect(find.text('Alertas importantes'), findsOneWidget);
  });

  testWidgets('login abre cadastro', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.ensureVisible(find.text(' cadastrar'));
    await tester.tap(find.text(' cadastrar'));
    await tester.pumpAndSettle();

    expect(find.text('Crie sua conta\nno LocalBiz'), findsOneWidget);
  });

  testWidgets('abre cadastro pelo login no web', (
    tester,
  ) async {
    configurarViewport(tester, const Size(1200, 900));
    await tester.pumpWidget(const MyApp());

    await tester.ensureVisible(find.text(' cadastrar'));
    await tester.tap(find.text(' cadastrar'));
    await tester.pumpAndSettle();

    final titulo = find.text('Crie sua conta\nno LocalBiz');
    final botao = find.widgetWithText(ElevatedButton, 'Criar Conta');
    final tituloTop = tester.getTopLeft(titulo).dy;
    final tituloBottom = tester.getBottomRight(titulo).dy;
    final botaoTop = tester.getTopLeft(botao).dy;
    final botaoBottom = tester.getBottomRight(botao).dy;

    expect(tituloTop, greaterThan(0));
    expect(tituloBottom, lessThan(900));
    expect(botaoTop, greaterThan(0));
    expect(botaoBottom, lessThan(900));
    expect(tester.takeException(), isNull);
  });

  testWidgets('cadastro aceito abre dashboard', (tester) async {
    configurarViewport(tester, const Size(900, 1000));
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text(' cadastrar'));
    await tester.pumpAndSettle();
    final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
    checkbox.onChanged?.call(true);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Criar Conta'));
    await tester.pumpAndSettle();

    expect(find.text('Resumo de Hoje'), findsOneWidget);
  });

  testWidgets('login abre recuperacao de senha', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Esqueci minha senha'));
    await tester.pumpAndSettle();

    expect(find.text('Esqueceu sua\nsenha?'), findsOneWidget);
  });

  testWidgets('recuperacao de senha volta para login', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Esqueci minha senha'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.widgetWithText(ElevatedButton, 'Enviar Link de Recuperação'),
    );
    await tester.tap(
      find.widgetWithText(ElevatedButton, 'Enviar Link de Recuperação'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Entrar'), findsWidgets);
    expect(
      find.text('Link de recuperação enviado com sucesso'),
      findsOneWidget,
    );
  });

  testWidgets('sair da conta volta para login', (tester) async {
    await entrarNoApp(tester);

    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.pushNamed(AppRoute.configuration.path);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Sair da Conta'),
      300,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Sair da Conta'));
    await tester.pumpAndSettle();

    expect(find.text('Entrar'), findsWidgets);
    expect(find.text('Resumo de Hoje'), findsNothing);
  });

  testWidgets('abre tela de clientes', (tester) async {
    await abrirClientes(tester);

    expect(find.text('Clientes'), findsOneWidget);
    expect(find.text('Mariana Silva'), findsOneWidget);
  });

  testWidgets('clientes: cards expandem no viewport web', (tester) async {
    configurarViewport(tester, const Size(1200, 800));
    await abrirClientes(tester);

    final cardSize = tester.getSize(find.byType(ClienteListItem).first);

    expect(cardSize.width, greaterThan(600));
    expect(tester.takeException(), isNull);
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

  testWidgets('produtos: cards expandem no viewport web', (tester) async {
    configurarViewport(tester, const Size(1200, 800));
    await abrirProdutos(tester);

    final cardSize = tester.getSize(find.byType(ProdutoListItem).first);

    expect(cardSize.width, greaterThan(600));
    expect(tester.takeException(), isNull);
  });

  testWidgets('produtos nao exibe nav bar inferior da feature', (tester) async {
    await abrirProdutos(tester);

    expect(find.byType(NavBarButton), findsNothing);
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

  testWidgets('clientes e produtos renderizam no viewport mobile', (
    tester,
  ) async {
    configurarViewport(tester, const Size(390, 844));

    await abrirClientes(tester);
    expect(find.text('Clientes'), findsOneWidget);
    expect(find.text('Mariana Silva'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await abrirProdutos(tester);
    expect(find.text('Produtos'), findsWidgets);
    expect(find.text('Fini Salada de Frutas'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('configuracoes nao exibe nav bar inferior da feature', (
    tester,
  ) async {
    await abrirConfiguracoes(tester);

    expect(find.text('Meu Negócio Local'), findsOneWidget);
    expect(find.byType(NavBarButton), findsNothing);
  });

  testWidgets('cadastro nao exibe seta automatica no app bar', (tester) async {
    await tester.pumpWidget(const MyApp());

    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.pushNamed(AppRoute.register.path);
    await tester.pumpAndSettle();

    final appBar = find.byType(AppBar);
    expect(
      find.descendant(of: appBar, matching: find.byIcon(Icons.arrow_back)),
      findsNothing,
    );
    expect(find.text('VOLTAR PARA LOGIN'), findsOneWidget);
  });
}
