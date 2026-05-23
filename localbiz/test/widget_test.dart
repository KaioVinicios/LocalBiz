import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localbiz/clientes/clientes_page.dart';
import 'package:localbiz/main.dart';
import 'package:localbiz/theme/app_design_tokens.dart';
import 'package:localbiz/widgets/app_list_card.dart';

void main() {
  testWidgets('abre tela de clientes', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Clientes'), findsOneWidget);
    expect(find.text('Mariana Silva'), findsOneWidget);
  });

  testWidgets('respeita medidas dos cards de clientes', (tester) async {
    await tester.pumpWidget(const MyApp());

    var primeiroCard = find.byType(AppListCard).first;

    expect(
      tester.getSize(primeiroCard),
      const Size(AppSizes.contentWidth, AppSizes.clientCardHeight),
    );
  });

  testWidgets('abre form de novo cliente', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('Novo Cliente'), findsOneWidget);
    expect(find.byType(NovoClienteForm), findsOneWidget);
    expect(
      tester.getSize(find.byKey(const ValueKey('novo-cliente-form-sheet'))),
      const Size(AppSizes.screenMaxWidth, AppSizes.clientFormHeight),
    );
  });

  testWidgets('salva novo cliente', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    await tester.enterText(find.byType(TextField).at(1), 'Bruno Lima');
    await tester.tap(find.text('Salvar Cliente'));
    await tester.pump();
    await tester.enterText(find.byType(TextField).at(0), 'Bruno');
    await tester.pump();

    expect(find.text('Bruno Lima'), findsOneWidget);
  });

  testWidgets('busca filtra por nome e telefone', (tester) async {
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
}
