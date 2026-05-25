class Cliente {
  Cliente({
    required this.nome,
    required this.telefone,
    required this.email,
    required this.historico,
  });

  String nome;
  String telefone;
  String email;
  List<ClienteHistorico> historico;
}

class ClienteHistorico {
  const ClienteHistorico({
    required this.data,
    required this.servico,
    required this.valor,
  });

  final String data;
  final String servico;
  final String valor;
}
