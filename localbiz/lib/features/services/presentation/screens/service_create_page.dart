import 'package:flutter/material.dart';
import 'package:localbiz/features/services/models/servico_model.dart';
import 'package:localbiz/features/services/presentation/screens/auth/auth_service.dart';
import 'package:localbiz/features/services/presentation/widgets/service_form_fields.dart';
import 'package:localbiz/features/services/repositories/servicos_repositories.dart';

class ServiceCreatePage extends StatelessWidget {
  const ServiceCreatePage({super.key, this.repository, this.negocioId});

  final ServicosRepositoryContract? repository;
  final String? negocioId;

  @override
  Widget build(BuildContext context) {
    final servicosRepository = repository ?? ServicosRepository();
    final uid = negocioId ?? AuthService().usuarioAtual?.uid;

    return ServiceFormScaffold(
      title: 'Cadastro de Serviço',
      description: 'Preencha os dados abaixo para o cadastro de um serviço.',
      image: const ServicePlaceholderImage(),
      category: 'Selecione',
      onSubmit: (value) {
        if (uid == null || uid.isEmpty) {
          throw StateError('Faça login para cadastrar serviços.');
        }
        return servicosRepository.criar(
          uid,
          ServicoModel(
            id: '',
            nome: value.name,
            categoria: value.category,
            preco: value.price,
            icone: 'spa_outlined',
            ativo: true,
          ),
        );
      },
    );
  }
}
