import 'package:flutter/material.dart';
import 'package:localbiz/features/services/models/servico_model.dart';
import 'package:localbiz/features/services/presentation/screens/auth/auth_service.dart';
import 'package:localbiz/features/services/presentation/widgets/service_form_fields.dart';
import 'package:localbiz/features/services/repositories/servicos_repositories.dart';

class ServiceEditPage extends StatelessWidget {
  const ServiceEditPage({
    super.key,
    this.servico,
    this.repository,
    this.negocioId,
  });

  final ServicoModel? servico;
  final ServicosRepositoryContract? repository;
  final String? negocioId;

  @override
  Widget build(BuildContext context) {
    final servicoAtual = servico;
    final servicosRepository = repository ?? ServicosRepository();
    final uid = negocioId ?? AuthService().usuarioAtual?.uid;

    return ServiceFormScaffold(
      title: 'Editar Serviço',
      description:
          'Para edição das  informações do serviço é necessário modificar os campos abaixo.',
      image: const ServiceHeroImage(),
      category: servicoAtual?.categoria ?? 'Serviços Capilares',
      name: servicoAtual?.nome ?? 'Corte + Hidratação',
      price: 'R\$ ${_formatCurrency(servicoAtual?.preco ?? 120)}',
      popResult: true,
      onSubmit: servicoAtual == null
          ? null
          : (value) {
              if (uid == null || uid.isEmpty) {
                throw StateError('Faça login para editar serviços.');
              }
              return servicosRepository.atualizar(
                uid,
                ServicoModel(
                  id: servicoAtual.id,
                  nome: value.name,
                  categoria: value.category,
                  preco: value.price,
                  icone: servicoAtual.icone,
                  ativo: servicoAtual.ativo,
                ),
              );
            },
    );
  }

  String _formatCurrency(double value) {
    return value.toStringAsFixed(2).replaceAll('.', ',');
  }
}
