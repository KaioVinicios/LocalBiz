import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../widgets/labeled_fields.dart';

class BusinessProfilePage extends StatefulWidget {
  const BusinessProfilePage({super.key});

  @override
  State<BusinessProfilePage> createState() => _BusinessProfilePageState();
}

class _BusinessProfilePageState extends State<BusinessProfilePage> {
  final _nameController = TextEditingController(text: 'Meu negócio Local');
  final _cnpjController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _addressController = TextEditingController();
  String _activity = 'Ambos';

  @override
  void dispose() {
    _nameController.dispose();
    _cnpjController.dispose();
    _whatsappController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            const _TopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Perfil do Negócio',
                      style: TextStyle(
                        fontSize: 30,
                        height: 1.1,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Altere os dados abaixo para mudança do perfil de negócio.',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.35,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 28),
                    LabeledTextField(
                      label: 'Nome da Empresa',
                      hint: 'Meu negócio Local',
                      controller: _nameController,
                    ),
                    const SizedBox(height: 20),
                    LabeledDropdown(
                      label: 'Ramo da Atividade',
                      value: _activity,
                      items: const ['Ambos', 'Produtos', 'Serviços'],
                      onChanged: (v) =>
                          setState(() => _activity = v ?? _activity),
                    ),
                    const SizedBox(height: 20),
                    LabeledTextField(
                      label: 'CNPJ ou CPF',
                      hint: '00.000.000/0000-00',
                      controller: _cnpjController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    LabeledTextField(
                      label: 'Whatsapp de Contato',
                      hint: '(79) 99999-9999',
                      controller: _whatsappController,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 20),
                    LabeledTextField(
                      label: 'Endereço Completo',
                      hint: 'Rua, Número, Bairro , Cidade',
                      controller: _addressController,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: FormSubmitButton(
                label: 'Salvar Alterações',
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.of(context).maybePop(),
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.arrow_back,
                      size: 20, color: AppColors.textPrimary),
                  SizedBox(width: 8),
                  Text(
                    'VOLTAR',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.divider),
            ),
            child: const Icon(Icons.help_outline,
                size: 20, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
