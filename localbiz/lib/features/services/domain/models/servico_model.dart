class ServicoModel {
  final String id;
  final String nome;
  final String categoria;
  final double preco;
  final String icone;
  final bool ativo;

  const ServicoModel({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.preco,
    required this.icone,
    required this.ativo,
  });

  factory ServicoModel.fromMap(String id, Map<String, dynamic> map) {
    return ServicoModel(
      id: id,
      nome: map['nome'] as String? ?? '',
      categoria: map['categoria'] as String? ?? '',
      preco: (map['preco'] as num?)?.toDouble() ?? 0,
      icone: map['icone'] as String? ?? 'spa_outlined',
      ativo: map['ativo'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'categoria': categoria,
      'preco': preco,
      'icone': icone,
      'ativo': ativo,
    };
  }
}