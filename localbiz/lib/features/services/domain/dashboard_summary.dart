import 'dart:math' as math;

class DashboardResumoVendas {
  const DashboardResumoVendas({
    required this.faturamentoHoje,
    required this.vendasHoje,
    required this.faturamentoOntem,
  });

  const DashboardResumoVendas.vazio()
    : faturamentoHoje = 0,
      vendasHoje = 0,
      faturamentoOntem = 0;

  final double faturamentoHoje;
  final int vendasHoje;
  final double faturamentoOntem;

  int get variacaoPercentual {
    if (faturamentoOntem <= 0) {
      return faturamentoHoje > 0 ? 100 : 0;
    }

    final percentual =
        ((faturamentoHoje - faturamentoOntem) / faturamentoOntem) * 100;
    return percentual.truncate();
  }

  String get variacaoFormatada {
    final valor = variacaoPercentual;
    final sinal = valor >= 0 ? '+' : '';
    return '$sinal$valor% vs. ontem';
  }
}

class ProdutoEstoqueBaixo {
  const ProdutoEstoqueBaixo({
    required this.id,
    required this.nome,
    required this.estoqueAtual,
  });

  final String id;
  final String nome;
  final int estoqueAtual;
}

String formatarMoedaBr(double valor) {
  final negativo = valor < 0;
  final absoluto = valor.abs();
  final partes = absoluto.toStringAsFixed(2).split('.');
  final inteiro = partes.first;
  final centavos = partes.last;
  final buffer = StringBuffer();

  for (var i = 0; i < inteiro.length; i++) {
    final restante = inteiro.length - i;
    buffer.write(inteiro[i]);
    if (restante > 1 && restante % 3 == 1) {
      buffer.write('.');
    }
  }

  return '${negativo ? '-' : ''}R\$ ${buffer.toString()},$centavos';
}

DateTime inicioDoDia(DateTime data) {
  return DateTime(data.year, data.month, data.day);
}

bool mesmoDia(DateTime data, DateTime referencia) {
  return data.year == referencia.year &&
      data.month == referencia.month &&
      data.day == referencia.day;
}

int limitarEstoque(int valor) => math.max(valor, 0);
