import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localbiz/main.dart';

Future<void> pumpApp(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pumpWidget(const MyApp());
}

void main() {
  testWidgets('app inicia no dashboard e navega para rotas principais', (
    tester,
  ) async {
    await pumpApp(tester);

    expect(find.text('Resumo de Hoje'), findsOneWidget);
    expect(find.text('Faturamento de Hoje'), findsOneWidget);
    expect(find.text('Alertas importantes'), findsOneWidget);

    await tester.tap(find.text('Clientes').first);
    await tester.pumpAndSettle();
    expect(find.text('Mariana Silva'), findsOneWidget);

    await pumpApp(tester);
    await tester.tap(find.byIcon(Icons.stars_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Serviços'), findsWidgets);
    expect(find.text('Corte e Hidratação'), findsWidgets);

    await pumpApp(tester);
    await tester.tap(find.text('Venda'));
    await tester.pumpAndSettle();
    expect(find.text('Nova Venda'), findsOneWidget);

    await pumpApp(tester);
    await tester.tap(find.text('Agendar'));
    await tester.pumpAndSettle();
    expect(find.text('Agendamento'), findsOneWidget);

    await pumpApp(tester);
    await tester.tap(find.text('Produtos'));
    await tester.pumpAndSettle();
    expect(find.text('Produtos'), findsWidgets);
    expect(find.text('Fini Salada de Frutas'), findsWidgets);

    await pumpApp(tester);
    await tester.tap(find.text('Configurações'));
    await tester.pumpAndSettle();
    expect(find.text('Meu Negócio Local'), findsOneWidget);
  });

  testWidgets('dashboard abre cadastro de serviço', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Mais'));
    await tester.pumpAndSettle();

    expect(find.text('Cadastro de Serviço'), findsOneWidget);
    expect(
      find.text('Preencha os dados abaixo para o cadastro de um serviço.'),
      findsOneWidget,
    );
    expect(find.text('Categoria'), findsOneWidget);
    expect(find.text('Selecione'), findsOneWidget);
    expect(find.text('Nome'), findsOneWidget);
    expect(find.text('Preço'), findsOneWidget);
    expect(find.text('Concluir'), findsOneWidget);
  });

  testWidgets('cadastro de serviço permite preencher campos', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Mais'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Serviços Capilares').last);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'Escova');
    await tester.enterText(find.byType(TextFormField).at(1), '8000');
    await tester.pump();

    expect(find.text('Serviços Capilares'), findsOneWidget);
    expect(find.text('Escova'), findsOneWidget);
    expect(find.text('R\$ 80,00'), findsOneWidget);
  });

  testWidgets(
    'lista de serviços abre edição de serviço pelo botão adicionar e detalhe',
    (tester) async {
      await pumpApp(tester);

      await tester.tap(find.byIcon(Icons.stars_outlined));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(find.text('Cadastro de Serviço'), findsOneWidget);

      await pumpApp(tester);
      await tester.tap(find.byIcon(Icons.stars_outlined));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Corte e Hidratação').first);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      expect(find.text('Editar Serviço'), findsOneWidget);
      expect(
        find.text(
          'Para edição das  informações do serviço é necessário modificar os campos abaixo.',
        ),
        findsOneWidget,
      );
      expect(find.text('Serviços Capilares'), findsOneWidget);
      expect(find.text('Corte + Hidratação'), findsOneWidget);
      expect(find.text('R\$ 120,00'), findsOneWidget);
    },
  );
}
