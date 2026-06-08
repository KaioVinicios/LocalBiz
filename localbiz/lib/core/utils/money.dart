// Utilidades para tratar valores monetários como centavos (int).
//
// Dinheiro é armazenado e calculado sempre em centavos para evitar erros de
// arredondamento de ponto flutuante. A conversão para `double`/texto acontece
// apenas na borda de exibição.

/// Converte o texto digitado pelo usuário em centavos.
///
/// Aceita formatos como `'12,50'`, `'12.50'`, `'R$ 12,50'`, `'1.234,56'` ou
/// `'1250'`. Quando há vírgula, ela é tratada como separador decimal (pt-BR) e
/// pontos como separadores de milhar.
int centavosFromInput(String input) {
  var s = input.replaceAll(RegExp(r'[^0-9,.]'), '').trim();
  if (s.isEmpty) return 0;
  if (s.contains(',')) {
    s = s.replaceAll('.', '').replaceAll(',', '.');
  }
  final reais = double.tryParse(s) ?? 0;
  return (reais * 100).round();
}

/// Formata centavos no padrão brasileiro sem o prefixo de moeda.
///
/// Ex.: `1250 -> '12,50'`, `5 -> '0,05'`, `125000 -> '1250,00'`.
String formatCentavos(int centavos) {
  final reais = centavos ~/ 100;
  final resto = (centavos % 100).abs();
  return '$reais,${resto.toString().padLeft(2, '0')}';
}
