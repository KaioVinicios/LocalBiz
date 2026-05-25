import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localbiz/main.dart';

void main() {
  testWidgets('abre tela de clientes', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Clientes'), findsOneWidget);
    expect(find.text('Mariana Silva'), findsOneWidget);
  });

  testWidgets('cadastra novo cliente', (tester) async {
    await tester.pumpWidget(const MyApp());

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
    await tester.pumpWidget(const MyApp());

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
    await tester.pumpWidget(const MyApp());

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
    await tester.pumpWidget(const MyApp());

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
    await tester.pumpWidget(const MyApp());

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
}
