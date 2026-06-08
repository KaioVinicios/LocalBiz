class AgendamentoModel {
  final String id;
  final String servicoId;
  final String clienteNome;
  final String clienteTelefone;
  final String categoriaCliente;
  final String data;
  final String hora;
  final double valor;
  final String status;

  const AgendamentoModel({
    required this.id,
    required this.servicoId,
    required this.clienteNome,
    required this.clienteTelefone,
    required this.categoriaCliente,
    required this.data,
    required this.hora,
    required this.valor,
    required this.status,
  });

  factory AgendamentoModel.fromMap(String id, Map<String, dynamic> map) {
    return AgendamentoModel(
      id: id,
      servicoId: map['servicoId'] as String? ?? '',
      clienteNome: map['clienteNome'] as String? ?? '',
      clienteTelefone: map['clienteTelefone'] as String? ?? '',
      categoriaCliente: map['categoriaCliente'] as String? ?? '',
      data: map['data'] as String? ?? '',
      hora: map['hora'] as String? ?? '',
      valor: (map['valor'] as num?)?.toDouble() ?? 0,
      status: map['status'] as String? ?? '',
    );
  }
}