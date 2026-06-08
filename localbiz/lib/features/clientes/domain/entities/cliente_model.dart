import 'package:cloud_firestore/cloud_firestore.dart';

class Cliente {
  Cliente({
    this.id,
    required this.nome,
    required this.telefone,
    required this.email,
    this.historico = const [],
  });

  String? id;
  String nome;
  String telefone;
  String email;
  List<ClienteHistorico> historico;

  factory Cliente.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    final historicoBruto = data['historico'] as List<dynamic>? ?? const [];

    return Cliente(
      id: doc.id,
      nome: data['nome'] as String? ?? '',
      telefone: data['telefone'] as String? ?? '',
      email: data['email'] as String? ?? '',
      historico: historicoBruto
          .whereType<Map<String, dynamic>>()
          .map(ClienteHistorico.fromMap)
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
    'nome': nome,
    'telefone': telefone,
    'email': email,
    'historico': historico.map((item) => item.toMap()).toList(),
  };
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

  factory ClienteHistorico.fromMap(Map<String, dynamic> map) {
    return ClienteHistorico(
      data: map['data'] as String? ?? '',
      servico: map['servico'] as String? ?? '',
      valor: map['valor'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'data': data,
    'servico': servico,
    'valor': valor,
  };
}
