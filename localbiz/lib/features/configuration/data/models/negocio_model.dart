import 'package:cloud_firestore/cloud_firestore.dart';

/// Perfil do negócio vinculado ao usuário autenticado.
/// Persistido na coleção `negocios/{uid}`.
class NegocioModel {
  final String nome;
  final String ramoAtividade;
  final String cnpjCpf;
  final String whatsapp;
  final String endereco;
  final String fotoUrl;

  const NegocioModel({
    this.nome = '',
    this.ramoAtividade = 'Ambos',
    this.cnpjCpf = '',
    this.whatsapp = '',
    this.endereco = '',
    this.fotoUrl = '',
  });

  factory NegocioModel.fromFirestore(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>?) ?? {};
    return NegocioModel(
      nome: data['nome'] as String? ?? '',
      ramoAtividade: data['ramoAtividade'] as String? ?? 'Ambos',
      cnpjCpf: data['cnpjCpf'] as String? ?? '',
      whatsapp: data['whatsapp'] as String? ?? '',
      endereco: data['endereco'] as String? ?? '',
      fotoUrl: data['fotoUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'nome': nome,
    'ramoAtividade': ramoAtividade,
    'cnpjCpf': cnpjCpf,
    'whatsapp': whatsapp,
    'endereco': endereco,
  };
}
