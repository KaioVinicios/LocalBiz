import 'package:flutter/material.dart';
import 'package:localbiz/features/services/models/servico_model.dart';
import 'package:localbiz/features/services/presentation/widgets/service_form_fields.dart';
import 'package:localbiz/features/services/repositories/servicos_repositories.dart';

class ServiceEditPage extends StatelessWidget {
  const ServiceEditPage({super.key, this.servico, this.repository});

  final ServicoModel? servico;
  final ServicosRepositoryContract? repository;

  @override
  Widget build(BuildContext context) {
    final servicoAtual = servico;
    final servicosRepository = repository ?? ServicosRepository();

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
              return servicosRepository.atualizar(
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
