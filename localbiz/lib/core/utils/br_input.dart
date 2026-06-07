import 'package:flutter/services.dart';

/// Utilitários de máscara e validação para campos brasileiros
/// (CPF/CNPJ e telefone/WhatsApp).

String somenteDigitos(String valor) => valor.replaceAll(RegExp(r'\D'), '');

// ----------------------------------------------------------------------------
// Máscaras (auxiliadores de preenchimento)
// ----------------------------------------------------------------------------

/// Formata progressivamente como CPF (até 11 dígitos) ou CNPJ (12 a 14).
class CpfCnpjInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var d = somenteDigitos(newValue.text);
    if (d.length > 14) d = d.substring(0, 14);
    final mascarado = d.length <= 11 ? _mascararCpf(d) : _mascararCnpj(d);
    return TextEditingValue(
      text: mascarado,
      selection: TextSelection.collapsed(offset: mascarado.length),
    );
  }

  String _mascararCpf(String d) {
    final b = StringBuffer();
    for (var i = 0; i < d.length; i++) {
      if (i == 3 || i == 6) b.write('.');
      if (i == 9) b.write('-');
      b.write(d[i]);
    }
    return b.toString();
  }

  String _mascararCnpj(String d) {
    final b = StringBuffer();
    for (var i = 0; i < d.length; i++) {
      if (i == 2 || i == 5) b.write('.');
      if (i == 8) b.write('/');
      if (i == 12) b.write('-');
      b.write(d[i]);
    }
    return b.toString();
  }
}

/// Formata telefone: (00) 0000-0000 (fixo) ou (00) 00000-0000 (celular).
class TelefoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var d = somenteDigitos(newValue.text);
    if (d.length > 11) d = d.substring(0, 11);

    final celular = d.length == 11;
    final b = StringBuffer();
    for (var i = 0; i < d.length; i++) {
      if (i == 0) b.write('(');
      if (i == 2) b.write(') ');
      if (celular && i == 7) b.write('-');
      if (!celular && i == 6) b.write('-');
      b.write(d[i]);
    }
    final texto = b.toString();
    return TextEditingValue(
      text: texto,
      selection: TextSelection.collapsed(offset: texto.length),
    );
  }
}

// ----------------------------------------------------------------------------
// Validadores
// ----------------------------------------------------------------------------

bool validarCpf(String valor) {
  final d = somenteDigitos(valor);
  if (d.length != 11) return false;
  if (RegExp(r'^(\d)\1{10}$').hasMatch(d)) return false;

  int digitoVerificador(int qtd) {
    var soma = 0;
    for (var i = 0; i < qtd; i++) {
      soma += int.parse(d[i]) * (qtd + 1 - i);
    }
    final resto = (soma * 10) % 11;
    return resto == 10 ? 0 : resto;
  }

  return digitoVerificador(9) == int.parse(d[9]) &&
      digitoVerificador(10) == int.parse(d[10]);
}

bool validarCnpj(String valor) {
  final d = somenteDigitos(valor);
  if (d.length != 14) return false;
  if (RegExp(r'^(\d)\1{13}$').hasMatch(d)) return false;

  const pesos1 = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
  const pesos2 = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];

  int digitoVerificador(List<int> pesos, int qtd) {
    var soma = 0;
    for (var i = 0; i < qtd; i++) {
      soma += int.parse(d[i]) * pesos[i];
    }
    final resto = soma % 11;
    return resto < 2 ? 0 : 11 - resto;
  }

  return digitoVerificador(pesos1, 12) == int.parse(d[12]) &&
      digitoVerificador(pesos2, 13) == int.parse(d[13]);
}

/// Aceita um CPF (11 dígitos) ou um CNPJ (14 dígitos) válido.
bool validarCpfCnpj(String valor) {
  final d = somenteDigitos(valor);
  if (d.length == 11) return validarCpf(d);
  if (d.length == 14) return validarCnpj(d);
  return false;
}

/// Telefone fixo (10 dígitos) ou celular (11), com DDD válido (não inicia em 0).
bool validarTelefone(String valor) {
  final d = somenteDigitos(valor);
  if (d.length != 10 && d.length != 11) return false;
  if (d[0] == '0') return false;
  return true;
}
