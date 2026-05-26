import 'package:flutter/material.dart';
import 'package:localbiz/features/services/presentation/widgets/service_form_fields.dart';

class ServiceEditPage extends StatelessWidget {
  const ServiceEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ServiceFormScaffold(
      title: 'Editar Serviço',
      description:
          'Para edição das  informações do serviço é necessário modificar os campos abaixo.',
      image: ServiceHeroImage(),
      category: 'Serviços Capilares',
      name: 'Corte + Hidratação',
      price: 'R\$ 120,00',
    );
  }
}
