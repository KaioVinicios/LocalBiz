import 'package:flutter/material.dart';
import 'package:localbiz/features/services/presentation/widgets/service_form_fields.dart';

class ServiceCreatePage extends StatelessWidget {
  const ServiceCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ServiceFormScaffold(
      title: 'Cadastro de Serviço',
      description: 'Preencha os dados abaixo para o cadastro de um serviço.',
      image: ServicePlaceholderImage(),
      category: 'Selecione',
    );
  }
}
